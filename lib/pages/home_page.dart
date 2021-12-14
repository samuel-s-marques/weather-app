import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/services/geo_api.dart';
import 'package:weatherapp/services/weather_api.dart';
import 'package:weatherapp/widgets/card_info.dart';
import '../utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SheetController controller = SheetController();
  DateFormat dateFormatter = DateFormat("d MMMM", Platform.localeName);
  var weatherData;

  Future<String?> getData() async {
    Position position = await GeoApi().determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    return placemarks[0].subAdministrativeArea;
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
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            String location = snapshot.data!;

            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                toolbarHeight: 120,
                title: Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          location,
                          style: GoogleFonts.getFont("Overpass",
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                leading: IconButton(
                  onPressed: () => Navigator.pushNamed(context, "/map"),
                  icon: Icon(Icons.place_outlined),
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
                      icon: Icon(Icons.info),
                    ),
                  )
                ],
              ),
              body: Column(
                children: [
                  FutureBuilder(
                    future: WeatherApi().getCurrentWeather("São Paulo"),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        var temperature = snapshot.data!.temperature
                            .toString()
                            .split(" ")[0]
                            .split(".")[0];
                        var weatherDescription = snapshot
                            .data!.weatherDescription
                            .toString()
                            .capitalize();
                        var windSpeed = snapshot.data!.windSpeed;
                        var humidity = snapshot.data!.humidity;
                        var dateTime =
                            dateFormatter.format(snapshot.data!.date);
                        var weatherIcon = snapshot.data!.weatherIcon;
                        weatherData = snapshot.data!;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Center(
                                child: Image.network(
                                  "http://openweathermap.org/img/wn/$weatherIcon@4x.png",
                                  width: 171,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Card(
                                color: Colors.white.withOpacity(0.2),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white, width: 1.85),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 26, top: 26),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${AppLocalizations.of(context)!.today}, $dateTime",
                                        style: GoogleFonts.getFont("Overpass",
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          "$temperature°",
                                          style: GoogleFonts.getFont("Overpass",
                                              fontSize: 100,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30),
                                        child: Text(
                                          "$weatherDescription",
                                          style: GoogleFonts.getFont(
                                            "Overpass",
                                            fontSize: 24,
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
                                            children: [
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
                                                  AppLocalizations.of(context)!.wind,
                                                  style: GoogleFonts.getFont(
                                                    "Overpass",
                                                    fontSize: 18,
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
                                                  fontSize: 18,
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
                                            children: [
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
                                                  AppLocalizations.of(context)!.hum,
                                                  style: GoogleFonts.getFont(
                                                    "Overpass",
                                                    fontSize: 18,
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
                                                  fontSize: 18,
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
                        );
                      }

                      return CircularProgressIndicator(
                        color: Colors.white,
                      );
                    },
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 34),
                    child: Container(
                      constraints: BoxConstraints(minWidth: 200, maxWidth: 220),
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/details"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.forecastReport}",
                              style: GoogleFonts.getFont(
                                "Overpass",
                                fontSize: 17,
                                color: Color(0xFF444E72),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
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
                  )
                ],
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.gpsPermission,
                    style: GoogleFonts.getFont("Overpass",
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Geolocator.openAppSettings();
                      await Geolocator.openLocationSettings();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.tryAgain,
                      style: GoogleFonts.getFont(
                        "Overpass",
                        color: Color(0xFF444E72),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                  ),
                )
              ],
            ),
          );
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

    var tempMax = weatherData.tempMax!.celsius!.floorToDouble();
    var tempMin = weatherData.tempMin!.celsius!.floorToDouble();
    var sunriseHour = hourFormatter.format(weatherData.sunrise!.toLocal());
    var sunsetHour = hourFormatter.format(weatherData.sunset!.toLocal());
    var windSpeed = weatherData.windSpeed;
    var pressure = weatherData.pressure;
    var humidity = weatherData.humidity;
    var cloudiness = weatherData.cloudiness;

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
                              color: Color(0xFF838BAA),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 11),
                        child: Text(AppLocalizations.of(context)!.moreInfo, style: textTheme.headline1),
                      ),
                      ListView(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        children:
                            ListTile.divideTiles(context: context, tiles: [
                          CardInfo.name(AppLocalizations.of(context)!.maxTemp, "$tempMax °C",
                              WeatherIcons.thermometer, Colors.redAccent),
                          CardInfo.name(
                              AppLocalizations.of(context)!.minTemp,
                              "$tempMin °C",
                              WeatherIcons.thermometer_exterior,
                              Colors.lightBlue),
                          CardInfo.name(AppLocalizations.of(context)!.sunrise, sunriseHour,
                              WeatherIcons.sunrise, Colors.orangeAccent),
                          CardInfo.name(AppLocalizations.of(context)!.sunset, sunsetHour,
                              WeatherIcons.sunset, Colors.deepOrangeAccent),
                          CardInfo.name(AppLocalizations.of(context)!.wind, "$windSpeed m/s",
                              WeatherIcons.strong_wind, Colors.grey),
                          CardInfo.name(AppLocalizations.of(context)!.airPressure, "$pressure Pa",
                              WeatherIcons.barometer, Colors.lightBlueAccent),
                          CardInfo.name(AppLocalizations.of(context)!.humidity, "$humidity %",
                              WeatherIcons.humidity, Colors.blueAccent),
                          CardInfo.name(AppLocalizations.of(context)!.cloudness, "$cloudiness %",
                              WeatherIcons.fog, Colors.grey),
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
