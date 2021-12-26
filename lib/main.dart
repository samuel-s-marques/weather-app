import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/pages/forecast_page.dart';
import 'package:weatherapp/pages/home_page.dart';
import 'package:weatherapp/pages/map_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', ''),
        Locale('en', ''),
        Locale('es', ''),
        Locale('ja', ''),
      ],
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
        "/map": (context) => MapPage(),
      },
    );
  }
}
