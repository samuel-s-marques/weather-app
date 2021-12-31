import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/database/database.dart';
import 'package:weatherapp/models/details_arguments.dart';
import 'package:weatherapp/models/place.dart';
import 'package:weatherapp/pages/no_gps_page.dart';
import 'package:weatherapp/services/geo_api.dart';
import 'package:weatherapp/services/weather_api.dart';
import 'package:weatherapp/widgets/card_info.dart';
import '../utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SheetController controller = SheetController();
  var weatherData;

  Future<String?> getCurrentLocation() async {
    Position position = await GeoApi().determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    return placemarks[0].subAdministrativeArea;
  }

  Future<SharedPreferences> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF47BFDF),
              Color(0xFF4A91FF),
            ]),
      ),
      child: FutureBuilder(
        future: Future.wait([
          getCurrentLocation(),
          WeatherDatabase().findAllFavoritePlaces(),
          getPrefs()
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            String currentLocation = snapshot.data[0];
            List<Place> places = snapshot.data[1];
            SharedPreferences prefs = snapshot.data[2];

            Locale currentLocale = Localizations.localeOf(context);
            String currentLanguageCode = currentLocale.languageCode;
            DateFormat dateFormatter = DateFormat("d MMMM", currentLanguageCode);

            List<String> placesNames =
            places.map((place) => place.placeDescription).toList();
            placesNames.add(currentLocation);
            placesNames.add(prefs.getString('selectedPlace') ?? currentLocation);
            placesNames = placesNames.toSet().toList();
            String selectedPlace =
                prefs.getString('selectedPlace') ?? currentLocation;

            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                toolbarHeight: 110,
                title: DropdownSearch<String>(
                  showSearchBox: true,
                  dropdownSearchDecoration: InputDecoration(
                    hintStyle: GoogleFonts.getFont(
                      "Overpass",
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.white,
                    ),
                    border: InputBorder.none,
                  ),
                  dropDownButton: const Icon(Icons.keyboard_arrow_down_outlined),
                  emptyBuilder: (context, text) {
                    text = AppLocalizations.of(context)!.noData;

                    return Center(
                      child: Text(
                        text,
                        style: GoogleFonts.getFont(
                          "Overpass",
                          color: const Color(0xFF838BAA),
                        ),
                      ),
                    );
                  },
                  dropdownBuilder: (context, selectedItem) {
                    return ListTile(
                      dense: true,
                      title: Text(
                        selectedItem!,
                        style: GoogleFonts.getFont(
                          "Overpass",
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  popupItemBuilder:
                      (BuildContext context, String item, bool isSelected) {
                    return ListTile(
                      title: Text(
                        item,
                        style: GoogleFonts.getFont(
                          "Overpass",
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: const Color(0xFF444E72),
                        ),
                      ),
                    );
                  },
                  mode: Mode.DIALOG,
                  showSelectedItems: true,
                  items: placesNames,
                  onChanged: (String? place) async {
                    setState(() {
                      selectedPlace = place!;
                    });

                    await prefs.setString('selectedPlace', selectedPlace);
                  },
                  selectedItem: selectedPlace,
                ),
                leading: IconButton(
                  onPressed: () => Navigator.pushNamed(context, "/map"),
                  icon: const Icon(Icons.place_outlined),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      onPressed: () async {
                        if (weatherData.toJson()!.isNotEmpty) {
                          await showBottomSheetDialog(context, weatherData);
                        }
                      },
                      icon: const Icon(Icons.info),
                    ),
                  )
                ],
              ),
              body: FutureBuilder(
                future: WeatherApi().getCurrentWeather(selectedPlace, context),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    String temperature = snapshot.data!.temperature
                        .toString()
                        .split(" ")[0]
                        .split(".")[0];
                    String weatherDescription = snapshot
                        .data!.weatherDescription
                        .toString()
                        .capitalize();
                    double? windSpeed = snapshot.data!.windSpeed;
                    double? humidity = snapshot.data!.humidity;
                    String dateTime =
                    dateFormatter.format(snapshot.data!.date);
                    String weatherIcon = snapshot.data!.weatherIcon;
                    weatherData = snapshot.data!;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            "http://openweathermap.org/img/wn/$weatherIcon@4x.png",
                            fit: BoxFit.fill,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Card(
                              color: Colors.white.withOpacity(0.2),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white, width: 1.85),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(bottom: 26, top: 26),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.today}, $dateTime",
                                      style: GoogleFonts.getFont(
                                        "Overpass",
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Text(
                                        "$temperature°",
                                        style: GoogleFonts.getFont(
                                          "Overpass",
                                          fontSize: 48.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 30),
                                      child: Text(
                                        weatherDescription,
                                        style: GoogleFonts.getFont(
                                          "Overpass",
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: const [
                                            BoxedIcon(
                                              WeatherIcons.strong_wind,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 21.0, right: 23),
                                          child: Column(
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .wind,
                                                style: GoogleFonts.getFont(
                                                  "Overpass",
                                                  fontSize: 14.sp,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "$windSpeed m/s",
                                              style: GoogleFonts.getFont(
                                                "Overpass",
                                                fontSize: 14.sp,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: const [
                                            BoxedIcon(
                                              WeatherIcons.raindrop,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 21.0, right: 23),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .hum,
                                                style: GoogleFonts.getFont(
                                                  "Overpass",
                                                  fontSize: 14.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "$humidity %",
                                              style: GoogleFonts.getFont(
                                                "Overpass",
                                                fontSize: 14.sp,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                },
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 200),
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          "/details",
                          arguments: DetailsArguments(selectedPlace),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.forecastReport,
                              style: GoogleFonts.getFont(
                                "Overpass",
                                fontSize: 13.sp,
                                color: const Color(0xFF444E72),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.navigate_next,
                                color: Color(0xFF444E72),
                              ),
                            )
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          primary: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const NoGpsPage();
        },
      ),
    );
  }

  Future<void> showBottomSheetDialog(
      BuildContext context, Weather weatherData) async {
    final controller = SheetController();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    DateFormat hourFormatter = DateFormat("Hm", Platform.localeName);

    double tempMax = weatherData.tempMax!.celsius!.floorToDouble();
    double tempMin = weatherData.tempMin!.celsius!.floorToDouble();
    String sunriseHour = hourFormatter.format(weatherData.sunrise!.toLocal());
    String sunsetHour = hourFormatter.format(weatherData.sunset!.toLocal());
    double? windSpeed = weatherData.windSpeed;
    double? pressure = weatherData.pressure;
    double? humidity = weatherData.humidity;
    double? cloudiness = weatherData.cloudiness;

    await showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          cornerRadius: 27,
          controller: controller,
          duration: const Duration(milliseconds: 500),
          snapSpec: const SnapSpec(
            snap: true,
            initialSnap: 0.3,
            snappings: [
              0.3,
              0.9,
            ],
          ),
          scrollSpec: const ScrollSpec(
            showScrollbar: true,
          ),
          maxWidth: 500,
          minHeight: 350,
          isDismissable: true,
          dismissOnBackdropTap: true,
          isBackdropInteractable: true,
          onDismissPrevented: (backButton, backDrop) async {
            HapticFeedback.heavyImpact();

            if (backButton || backDrop) {
              const duration = Duration(milliseconds: 300);
              await controller.snapToExtent(0.2,
                  duration: duration, clamp: false);
              await controller.snapToExtent(0.4, duration: duration);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 3,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: const Color(0xFF838BAA),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 11),
                        child: Text(AppLocalizations.of(context)!.moreInfo,
                            style: textTheme.headline1),
                      ),
                      ListView(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        children:
                            ListTile.divideTiles(context: context, tiles: [
                          CardInfo.name(
                              AppLocalizations.of(context)!.maxTemp,
                              "$tempMax °C",
                              WeatherIcons.thermometer,
                              Colors.redAccent),
                          CardInfo.name(
                              AppLocalizations.of(context)!.minTemp,
                              "$tempMin °C",
                              WeatherIcons.thermometer_exterior,
                              Colors.lightBlue),
                          CardInfo.name(
                              AppLocalizations.of(context)!.sunrise,
                              sunriseHour,
                              WeatherIcons.sunrise,
                              Colors.orangeAccent),
                          CardInfo.name(
                              AppLocalizations.of(context)!.sunset,
                              sunsetHour,
                              WeatherIcons.sunset,
                              Colors.deepOrangeAccent),
                          CardInfo.name(
                              AppLocalizations.of(context)!.wind,
                              "$windSpeed m/s",
                              WeatherIcons.strong_wind,
                              Colors.grey),
                          CardInfo.name(
                              AppLocalizations.of(context)!.airPressure,
                              "$pressure Pa",
                              WeatherIcons.barometer,
                              Colors.lightBlueAccent),
                          CardInfo.name(
                              AppLocalizations.of(context)!.humidity,
                              "$humidity %",
                              WeatherIcons.humidity,
                              Colors.blueAccent),
                          CardInfo.name(AppLocalizations.of(context)!.cloudness,
                              "$cloudiness %", WeatherIcons.fog, Colors.grey),
                        ]).toList(),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
