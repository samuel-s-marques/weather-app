import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:weatherapp/database/database.dart';
import 'package:weatherapp/models/place.dart';
import 'package:weatherapp/services/geo_api.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  FloatingSearchBarController controller = FloatingSearchBarController();
  List<Marker> customMarkers = [];
  List<AutocompletePrediction> _results = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        buildMap(),
        FutureBuilder(
          future: WeatherDatabase().findAll(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<Place> places = snapshot.data;

              return buildFloatingSearchBar(places);
            }

            return buildFloatingSearchBar([]);
          },
        ),
        buildFabs(),
      ]),
    );
  }

  Widget buildFloatingSearchBar(List<Place> places) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var googlePlace = GooglePlace(dotenv.get('GOOGLE_PLACE_API_KEY'));

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: FloatingSearchBar(
        controller: controller,
        queryStyle: GoogleFonts.getFont("Overpass",
            fontSize: 18, color: Color(0xFF444E72)),
        borderRadius: BorderRadius.circular(15),
        hint: AppLocalizations.of(context)!.searchHere,
        hintStyle: GoogleFonts.getFont("Overpass",
            fontSize: 18, color: Color(0xFF838BAA)),
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) async {
          var places = await googlePlace.autocomplete.get(query);
          _results = places!.predictions!;

          for (var result in _results) {
            WeatherDatabase().save(Place(
              placeId: result.placeId ?? '',
              placeDescription: result.description ?? '',
            ));
          }

          setState(() {});
        },
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.mic),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    _results.length > 0 ? _results.length : places.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: _results.isNotEmpty
                        ? const Icon(Icons.place_outlined)
                        : const Icon(Icons.history_outlined),
                    onTap: () async {
                      var placeDetails = await googlePlace.details.get(
                          _results.isNotEmpty
                              ? _results[index].placeId ?? ''
                              : places[index].placeId);

                      goToLocation(placeDetails!.result!.geometry!.location!.lat, placeDetails.result!.geometry!.location!.lng);
                      controller.close();
                    },
                    title: Text(
                      "${_results.isNotEmpty ? _results[index].description : places[index].placeDescription}",
                      style: GoogleFonts.getFont(
                        "Overpass",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMap() {
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    );

    return GoogleMap(
      initialCameraPosition: _kGooglePlex,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: customMarkers.toSet(),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Future<void> _goToMyPosition() async {
    Position _currentPosition = await GeoApi().determinePosition();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          zoom: 16,
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        ),
      ),
    );
  }

  Future<void> goToLocation(latitude, longitude) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          zoom: 16,
          target: LatLng(latitude, longitude),
        ),
      ),
    );
  }

  Widget buildFabs() {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: 16, end: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: _goToMyPosition,
              backgroundColor: Colors.white,
              child: Icon(Icons.gps_fixed, color: Color(0xFF4D4D4D)),
            ),
          ],
        ),
      ),
    );
  }
}
