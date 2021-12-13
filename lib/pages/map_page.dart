import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(51.5, -0.09),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 30, right: 30),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300
                ),
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white,
                  spreadRadius: -3.0,
                  blurRadius: 6
                )
              ],
              borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextField(
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.getFont("Overpass",
                    fontSize: 18, color: Color(0xFF444E72)),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_sharp, color: Color(0xFF444E72),),),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(onPressed: () {},
                        icon: Icon(Icons.mic, color: Color(0xFF444E72),)),
                  ),
                  border: InputBorder.none,
                  hintText: "Search here",
                  hintStyle: GoogleFonts.getFont("Overpass",
                      fontSize: 18, color: Color(0xFF838BAA)),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
