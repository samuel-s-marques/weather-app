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
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  FloatingSearchBarController controller = FloatingSearchBarController();
  List<Marker> customMarkers = [];
  List<AutocompletePrediction> _results = [];
  bool _isLoading = false;

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
          future: Future.wait([
            WeatherDatabase().findAllRecentSearches(),
            WeatherDatabase().findAllFavoritePlaces()
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return buildFloatingSearchBar(snapshot.data);
            }

            return const CircularProgressIndicator();
          },
        ),
        buildFabs(),
      ]),
    );
  }

  Widget buildFloatingSearchBar(List<List<Place>> placeList) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var googlePlace = GooglePlace(dotenv.get('GOOGLE_PLACE_API_KEY'));

    List<Place> favoritePlaces = placeList[1];
    List<Place> recentPlaces = placeList[0];

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: FloatingSearchBar(
        controller: controller,
        queryStyle: GoogleFonts.getFont("Overpass",
            fontSize: 18, color: const Color(0xFF444E72)),
        borderRadius: BorderRadius.circular(15),
        progress: _isLoading,
        hint: AppLocalizations.of(context)!.searchHere,
        hintStyle: GoogleFonts.getFont("Overpass",
            fontSize: 18, color: const Color(0xFF838BAA)),
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) async {
          if (query.trim().isNotEmpty) {
            setState(() {
              _isLoading = true;
            });
          }

          var places = await googlePlace.autocomplete.get(query);
          _results = places!.predictions!;

          for (var result in _results) {
            WeatherDatabase().saveRecentSearch(Place(
              placeId: result.placeId ?? '',
              placeDescription: result.description ?? '',
            ));
          }

          setState(() {
            _isLoading = false;
          });
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 30),
                          child: Text(
                            "Recent search",
                            style: GoogleFonts.getFont(
                              "Overpass",
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF444E72),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _results.isNotEmpty
                          ? _results.length
                          : recentPlaces.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: _results.isNotEmpty
                              ? const Icon(Icons.place_outlined)
                              : const Icon(Icons.history_outlined),
                          onTap: () async {
                            var placeDetails = await googlePlace.details.get(
                                _results.isNotEmpty
                                    ? _results[index].placeId ?? ''
                                    : recentPlaces[index].placeId);

                            WeatherDatabase().saveFavoritePlace(Place(
                                placeId: _results.isNotEmpty
                                    ? _results[index].placeId ?? ''
                                    : recentPlaces[index].placeId,
                                placeDescription:
                                    placeDetails!.result!.name ?? ''));

                            goToLocation(
                              placeDetails.result!.geometry!.location!.lat,
                              placeDetails.result!.geometry!.location!.lng,
                            );
                            controller.close();
                          },
                          title: Text(
                            "${_results.isNotEmpty ? _results[index].description : recentPlaces[index].placeDescription}",
                            style: GoogleFonts.getFont(
                              "Overpass",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 30),
                          child: Text(
                            "Favorite place",
                            style: GoogleFonts.getFont(
                              "Overpass",
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF444E72),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: favoritePlaces.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.star),
                          onTap: () async {
                            var placeDetails = await googlePlace.details
                                .get(favoritePlaces[index].placeId);

                            goToLocation(
                              placeDetails!.result!.geometry!.location!.lat,
                              placeDetails.result!.geometry!.location!.lng,
                            );
                            controller.close();
                          },
                          title: Text(
                            favoritePlaces[index].placeDescription,
                            style: GoogleFonts.getFont(
                              "Overpass",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                              onPressed: () async {
                                WeatherDatabase().deleteWhere(
                                  favoritePlaces[index].placeId,
                                  'favoritePlaces',
                                );
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete_outline)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMap() {
    const CameraPosition _kGooglePlex = CameraPosition(
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
    controller.close();

    Position _currentPosition = await GeoApi().determinePosition();
    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(
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
        padding: const EdgeInsetsDirectional.only(bottom: 16, end: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: _goToMyPosition,
              backgroundColor: Colors.white,
              child: const Icon(Icons.gps_fixed, color: Color(0xFF4D4D4D)),
            ),
          ],
        ),
      ),
    );
  }
}
