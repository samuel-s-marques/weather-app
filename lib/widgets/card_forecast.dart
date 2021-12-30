import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardForecast extends StatelessWidget {
  final String day;
  final String hour;
  final String temperature;
  final String asset;

  CardForecast({
    required this.day,
    required this.hour,
    required this.temperature,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: GoogleFonts.getFont("Overpass",
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.left,
              ),
              Text(
                hour,
                style: GoogleFonts.getFont("Overpass",
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Image.network(
            "http://openweathermap.org/img/wn/$asset@4x.png",
            width: 50,
          ),
          Text(
            "$temperature°",
            style: GoogleFonts.getFont(
              "Overpass",
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
