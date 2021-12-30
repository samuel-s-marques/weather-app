import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/models/details_arguments.dart';
import 'package:weatherapp/services/weather_api.dart';
import 'package:weatherapp/widgets/card_forecast.dart';
import 'package:weatherapp/widgets/card_weather.dart';
import '../utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetailsArguments;

    final ScrollController _scrollController = ScrollController();
    var data = WeatherApi().getNextFiveDaysForecast(args.placeName, context);
    Locale currentLocale = Localizations.localeOf(context);
    String currentLanguageCode = currentLocale.languageCode;

    final now = DateTime.now();
    String formattedDate =
        DateFormat("MMM, d", currentLanguageCode).format(now);
    DateFormat hourFormatter = DateFormat("Hm", currentLanguageCode);
    DateFormat weekDayFormatter = DateFormat("EEEE", currentLanguageCode);

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
          toolbarHeight: 110,
          title: Text(
            AppLocalizations.of(context)!.back,
            style: GoogleFonts.getFont(
              "Overpass",
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.navigate_before),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.today,
                    style: GoogleFonts.getFont("Overpass",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    formattedDate,
                    style: GoogleFonts.getFont(
                      "Overpass",
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8, right: 8),
              child: FutureBuilder(
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
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

                          return const CircularProgressIndicator();
                        },
                      ),
                    );
                  }

                  return const SizedBox(
                    height: 170,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                },
                future: data,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.nextForecast,
                    style: GoogleFonts.getFont(
                      "Overpass",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const Icon(
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
                  return SizedBox(
                    height: 40.h,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 30.0, left: 30.0, top: 10),
                      child: RawScrollbar(
                        thumbColor: Colors.white,
                        radius: const Radius.circular(5),
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
                                var today =
                                    DateTime(now.year, now.month, now.day);
                                var day = weekDayFormatter
                                    .format(snapshot.data[index]!.date)
                                    .split("-")[0]
                                    .capitalize();

                                if (today.difference(snapshot.data[index]!.date).inDays == 0) {
                                  day = AppLocalizations.of(context)!.today;
                                } else if (today.difference(snapshot.data[index]!.date).inDays == -1) {
                                  day = AppLocalizations.of(context)!.tomorrow;
                                }

                                var hour = hourFormatter.format(snapshot.data[index]!.date);
                                var temperature = snapshot
                                    .data[index]!.temperature
                                    .toString()
                                    .split(" ")[0]
                                    .split(".")[0];
                                var weatherIcon = snapshot.data[index]!.weatherIcon;

                                return CardForecast(
                                  day: day,
                                  hour: hour,
                                  temperature: temperature,
                                  asset: weatherIcon,
                                );
                              }

                              return const CircularProgressIndicator(color: Colors.white);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 150.sp,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 17.0),
                    child: BoxedIcon(
                      WeatherIcons.day_sunny,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "OpenWeatherMap",
                    style: GoogleFonts.getFont("Overpass",
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
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
