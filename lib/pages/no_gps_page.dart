import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class NoGpsPage extends StatelessWidget {
  const NoGpsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  color: const Color(0xFF444E72),
                ),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
