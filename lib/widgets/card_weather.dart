import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardWeather extends StatelessWidget {
  final String temperature;
  final String asset;
  final String hour;
  final bool isActive;

  CardWeather({
    required this.temperature,
    required this.asset,
    required this.hour,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Card(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24,
            bottom: 24,
            left: 14,
            right: 14,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$temperature°",
                style: GoogleFonts.getFont(
                  "Overpass",
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Image.network(
                "http://openweathermap.org/img/wn/$asset@4x.png",
                width: 46,
              ),
              Text(
                hour,
                style: GoogleFonts.getFont(
                  "Overpass",
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
