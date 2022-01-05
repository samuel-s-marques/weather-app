import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:weatherapp/pages/forecast_page.dart';
import 'package:weatherapp/pages/home_page.dart';
import 'package:weatherapp/pages/map_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weatherapp/pages/no_gps_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'WeatherApp',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
            Locale('es', ''),
            Locale('ja', ''),
            Locale('pt', ''),
          ],
          theme: ThemeData(
            textTheme: TextTheme(
              headline1: GoogleFonts.getFont("Overpass",
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF444E72)),
              headline2: GoogleFonts.getFont("Overpass",
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF444E72)),
            ),
          ),
          initialRoute: '/home',
          routes: {
            "/home": (context) => const HomePage(),
            "/details": (context) => const ForecastPage(),
            "/map": (context) => const MapPage(),
            "/gps": (context) => const NoGpsPage(),
          },
        );
      },
    );
  }
}
