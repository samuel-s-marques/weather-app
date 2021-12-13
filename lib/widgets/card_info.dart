import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_icons/weather_icons.dart';

class CardInfo extends StatelessWidget {
  final String title;
  final String data;
  final IconData icon;
  final Color color;

  CardInfo.name(this.title, this.data, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: ListTile(
        leading: BoxedIcon(
          icon,
          color: color,
        ),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.getFont("Overpass",
                      fontSize: 16, color: Color(0xFF838BAA)),
                ),
                Text(data, style: GoogleFonts.getFont("Overpass", fontSize: 16, color: Color(0xFF444E72), fontWeight: FontWeight.bold),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
