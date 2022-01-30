import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:hackaton1/detailsCorona.dart';
import 'package:hackaton1/drawer.dart';

class CoronaPage extends StatefulWidget {
  const CoronaPage({Key? key}) : super(key: key);

  static const routName = '/corona';

  @override
  _CoronaPageState createState() => _CoronaPageState();
}

final myController2 = TextEditingController();

class _CoronaPageState extends State<CoronaPage> {
  bool typing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8ddca4),
      appBar: AppBar(
        backgroundColor: Color(0xff474b24),
        title: typing ? TextBox() : Text('Corona'),
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
      body: SingleChildScrollView(
        child: Container(
          child: new CoronaInfo(myController2.text),
        ),
      ),
    );
  }
}

class CoronaInfo extends StatelessWidget {
  String searchText;

  CoronaInfo(this.searchText);

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: getLocation(),
            builder: (ctx, AsyncSnapshot<Position> place) {
              if (place.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return FutureBuilder(
                  future: fetchAirQuality(
                      place.data!.latitude, place.data!.longitude),
                  builder: (ctx, AsyncSnapshot<dynamic> results) {
                    if (results.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return FutureBuilder(
                      future: fetchCoronaData(),
                      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        String country = results.data["data"]["country"];

                        return Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  myController2.text == ""
                                      ? results.data["data"]["country"]
                                      : myController2.text,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
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
                              margin: EdgeInsets.all(60),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, DetailsCorona.routName,
                                      arguments: myController2.text == "" ?
                                      snapshot.data[country]["All"]["abbreviation"] :
                                      snapshot.data[myController2.text]["All"]["abbreviation"]
                                  );
                                },
                                child: Image.asset(
                                  "assets/Swift.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                "Total Cases",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                myController2.text.toString() == ""
                                    ? snapshot.data[country]["All"]["confirmed"]
                                        .toString()
                                    : snapshot.data[myController2.text]["All"]
                                            ["confirmed"]
                                        .toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  });
            }));
  }

  Future<dynamic> fetchAirQuality(double lat, double long) async {
    final response = await http.get(Uri.parse(
        "http://api.airvisual.com/v2/nearest_city?lat=$lat&lon=$long&key=6e30b967-a864-4b54-b11f-e13ec754629f"));
    return jsonDecode(response.body);
  }

  Future<dynamic> fetchCoronaData() async {
    final response =
        await http.get(Uri.parse("https://covid-api.mmediagroup.fr/v1/cases"));
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
        controller: myController2,
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Search'),
      ),
    );
  }
}


