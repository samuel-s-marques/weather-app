import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardForecast extends StatelessWidget {
  final String temperature;
  final String asset;
  final String day;

  CardForecast({
    required this.temperature,
    required this.asset,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: GoogleFonts.getFont("Overpass",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Image.asset(
              "assets/images/$asset.png",
              width: 35,
            ),
            Text(
              "$temperature°",
              style: GoogleFonts.getFont(
                "Overpass",
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
