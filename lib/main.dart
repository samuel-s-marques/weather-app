import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weatherapp/pages/forecast_page.dart';
import 'package:weatherapp/pages/home_page.dart';
import 'package:weatherapp/pages/map_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  initializeDateFormatting(Platform.localeName, null)
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: GoogleFonts.getFont("Overpass",
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Color(0xFF444E72)),
          headline2: GoogleFonts.getFont("Overpass",
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF444E72)),
        ),
      ),
      home: HomePage(),
      routes: {
        "/details": (context) => const ForecastPage(),
        "/map": (context) => const MapPage(),
      },
    );
  }
}
