import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_icons/weather_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
          toolbarHeight: 120,
          title: Padding(
            padding: const EdgeInsets.only(left: 22),
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "São Paulo",
                    style: GoogleFonts.getFont("Overpass",
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Icon(Icons.expand_more, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.place_outlined),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 28),
              child: Center(
                child: Image.asset(
                  "assets/images/light-mode/drop-light.png",
                  width: 171,
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Card(
                color: Colors.white.withOpacity(0.2),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 1.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 26, top: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Today, 12 September",
                        style: GoogleFonts.getFont("Overpass",
                            fontSize: 18, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          "29°",
                          style: GoogleFonts.getFont("Overpass",
                              fontSize: 100, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(
                          "Cloudy",
                          style: GoogleFonts.getFont(
                            "Overpass",
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              BoxedIcon(
                                WeatherIcons.strong_wind,
                                color: Colors.white,
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 21.0, right: 23),
                            child: Column(
                              children: [
                                Text(
                                  "Wind",
                                  style: GoogleFonts.getFont(
                                    "Overpass",
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "10 km/h",
                                style: GoogleFonts.getFont(
                                  "Overpass",
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              BoxedIcon(
                                WeatherIcons.raindrop,
                                color: Colors.white,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 21.0, right: 23),
                                child: Text(
                                  "Hum",
                                  style: GoogleFonts.getFont(
                                    "Overpass",
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "54 %",
                                style: GoogleFonts.getFont(
                                  "Overpass",
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 34),
              child: Container(
                width: 204,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forecast report",
                        style: GoogleFonts.getFont(
                          "Overpass",
                          fontSize: 17,
                          color: Color(0xFF444E72),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.navigate_next,
                          color: Color(0xFF444E72),
                        ),
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
