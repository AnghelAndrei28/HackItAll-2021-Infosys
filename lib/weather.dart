import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:hackaton1/drawer.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  static const routName = '/weather';

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

final myController = TextEditingController();

class _WeatherPageState extends State<WeatherPage> {
  bool typing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8ddca4),
      appBar: AppBar(
        backgroundColor: Color(0xff474b24),
        title: typing ? TextBox() : Text('Weather'),
        leading: IconButton(
          icon: Icon(typing ? Icons.done : Icons.search),
          onPressed: () {
            setState(() {
              typing = !typing;
            });
          },
        ),
      ),
      endDrawer: AppDrawer(),
      body: Center(
        child: new InfoWeather(myController.text),
      ),
    );
  }
}

class InfoWeather extends StatelessWidget {
  String searchText;

  InfoWeather(this.searchText);

  DateTime now = DateTime.now();

  Color setColor(int color) {
    if (color == 0) {
      return Colors.green;
    } else if (color == 1) {
      return Colors.yellow;
    }

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: FutureBuilder(
              future: getLocation(),
              builder: (ctx, AsyncSnapshot<Position> place) {
                if (place.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return FutureBuilder(
                    future: myController.text == ""
                        ? fetchAirQuality(
                            place.data!.latitude, place.data!.longitude)
                        : fetchCity(myController.text),
                    builder: (ctx, AsyncSnapshot<dynamic> results) {
                      if (results.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      int color;
                      if (results.data["data"]["current"]["pollution"]["aqius"] <=
                          20) {
                        color = 0;
                      } else if (results.data["data"]["current"]["pollution"]
                                  ["aqius"] >
                              20 &&
                          results.data["data"]["current"]["pollution"]["aqius"] <=
                              79) {
                        color = 1;
                      } else {
                        color = 2;
                      }

                      String image =
                          results.data["data"]["current"]["weather"]["ic"];
                      switch (image) {
                        case "01d":
                          image = "assets/01d.png";
                          break;
                        case "01n":
                          image = "assets/01n.png";
                          break;
                        case "02d":
                          image = "assets/02d.png";
                          break;
                        case "02n":
                          image = "assets/02n.png";
                          break;
                        case "03d":
                          image = "assets/03d.png";
                          break;
                        case "04d":
                          image = "assets/04d.png";
                          break;
                        case "09d":
                          image = "assets/09d.png";
                          break;
                        case "10d":
                          image = "assets/10d.png";
                          break;
                        case "10n":
                          image = "assets/10n.png";
                          break;
                        case "11d":
                          image = "assets/11d.png";
                          break;
                        case "13d":
                          image = "assets/13d.png";
                          break;
                        case "50d":
                          image = "assets/50d.png";
                          break;
                      }

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                results.data["data"]["country"],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                results.data["data"]["city"],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              DateFormat.yMMMMd('en_US').format(now),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 65, right: 65, top: 30, bottom: 25),
                            child: Image.asset(
                              image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            results.data["data"]["current"]["weather"]["tp"]
                                    .toString() +
                                '°C',
                            style: TextStyle(fontSize: 35),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Stack(
                            children: [
                              Container(
                                width: 300,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: setColor(color),
                                ),
                                child: Text(
                                  'Air Quality',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              Container(
                                width: 200,
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  'Air Quality',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    });
              })),
    );
  }

  Future<dynamic> fetchAirQuality(double lat, double long) async {
    final response = await http.get(Uri.parse(
        "http://api.airvisual.com/v2/nearest_city?lat=$lat&lon=$long&key=6e30b967-a864-4b54-b11f-e13ec754629f"));
    return jsonDecode(response.body);
  }

  Future<dynamic> fetchCity(String city) async {
    final response = await http.get(Uri.parse(
        "http://api.airvisual.com/v2/city?city=$city&state=$city&country=Romania&key=6e30b967-a864-4b54-b11f-e13ec754629f"));
    return jsonDecode(response.body);
  }

  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        textAlign: TextAlign.center,
        controller: myController,
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Search'),
      ),
    );
  }
}
