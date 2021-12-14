import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/services/weather_api.dart';
import 'package:weatherapp/widgets/card_forecast.dart';
import 'package:weatherapp/widgets/card_weather.dart';
import '../utils/utils.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  final ScrollController _scrollController = ScrollController();
  var data = WeatherApi().getNextFiveDaysForecast("São Paulo");

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    String formattedDate =
        DateFormat("MMM, d", Platform.localeName).format(now);
    DateFormat hourFormatter = DateFormat("Hm", Platform.localeName);
    DateFormat dayFormatter = DateFormat("MMM, d", Platform.localeName);
    DateFormat weekDayFormatter = DateFormat("EEEE", Platform.localeName);

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 120,
          title: Text(
            "Back",
            style: GoogleFonts.getFont("Overpass",
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.navigate_before),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today",
                    style: GoogleFonts.getFont("Overpass",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    formattedDate,
                    style: GoogleFonts.getFont(
                      "Overpass",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 8, right: 8),
              child: FutureBuilder(
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 9,
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.hasData) {
                            var temperature = snapshot.data[index]!.temperature
                                .toString()
                                .split(" ")[0]
                                .split(".")[0];
                            var time = hourFormatter
                                .format(snapshot.data[index]!.date);
                            var weatherIcon = snapshot.data[index]!.weatherIcon;

                            return CardWeather(
                                temperature: temperature,
                                asset: weatherIcon,
                                hour: time);
                          }

                          return CircularProgressIndicator();
                        },
                      ),
                    );
                  }

                  return CircularProgressIndicator(
                    color: Colors.white,
                  );
                },
                future: data,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Next Forecast",
                    style: GoogleFonts.getFont(
                      "Overpass",
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.event,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            FutureBuilder(
              future: data,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 30.0, left: 30.0, top: 23),
                      child: RawScrollbar(
                        thumbColor: Colors.white,
                        radius: Radius.circular(5),
                        isAlwaysShown: true,
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (snapshot.hasData) {
                                var now = DateTime.now();
                                var today = DateTime(now.year, now.month, now.day);
                                var day = weekDayFormatter.format(snapshot.data[index]!.date).split("-")[0].capitalize();

                                if (today.difference(snapshot.data[index]!.date).inDays == 0) {
                                  day = "Hoje";
                                } else if (today.difference(snapshot.data[index]!.date).inDays == -1) {
                                  day = "Amanhã";
                                }

                                var hour = hourFormatter.format(snapshot.data[index]!.date);
                                var temperature = snapshot
                                    .data[index]!.temperature
                                    .toString()
                                    .split(" ")[0]
                                    .split(".")[0];
                                var weatherIcon =
                                    snapshot.data[index]!.weatherIcon;

                                return CardForecast(
                                  day: day,
                                  hour: hour,
                                  temperature: temperature,
                                  asset: weatherIcon,
                                );
                              }

                              return CircularProgressIndicator(
                                  color: Colors.white);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return CircularProgressIndicator(color: Colors.white);
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 17.0),
                    child: BoxedIcon(
                      WeatherIcons.day_sunny,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "OpenWeatherMap",
                    style: GoogleFonts.getFont("Overpass",
                        fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
