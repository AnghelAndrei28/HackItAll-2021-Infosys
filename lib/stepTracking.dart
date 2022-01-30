import 'dart:math';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackaton1/drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Track extends StatefulWidget {
  static const routName = "/tracks";

  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String time = 'waiting...';
  String distance = 'waiting...';

  late DateTime newDay;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    newDay = DateTime(now.year, now.month, now.day + 1);
    _initialise();
  }

  _initialise() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Position initCoordinates = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    sharedPreferences.setDouble('oldLatitude', initCoordinates.latitude);
    sharedPreferences.setDouble('oldLongitude', initCoordinates.longitude);
  }

  _newEntry(double latitude, double longitude) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    double oldLatitude = sharedPreferences.getDouble('oldLatitude') ?? 0;
    double oldLongitude = sharedPreferences.getDouble('oldLongitude') ?? 0;
    const R = 6371e3;
    var l1 = oldLatitude * pi / 180;
    var l2 = latitude * pi / 180;
    var ld = (latitude - oldLatitude) * pi / 180;
    var lo = (longitude - oldLongitude) * pi / 180;

    var a = sin(ld / 2) * sin(ld / 2) +
        cos(l1) * cos(l2) * sin(lo / 2) * sin(lo / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double getDistance = R * c;
    int distance =
        (sharedPreferences.getInt('distance') ?? 0) + getDistance.toInt();
    sharedPreferences.setDouble('oldLatitude', latitude);
    sharedPreferences.setDouble('oldLongitude', longitude);
    sharedPreferences.setInt('distance', distance);
  }

  _newDay(String nextDay) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('distance', 0);
    sharedPreferences.setString('nextDay', nextDay);
  }

  Future<String> _getDistance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return (sharedPreferences.getInt('distance') ?? 0).toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff8ddca4),
        endDrawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: Color(0x005fbb97),
          title: const Text('Step Tracker'),
        ),
        body: Container(
          child: Center(
            child: ListView(
              children: <Widget>[
                FutureBuilder(
                    future: _getDistance(),
                    builder: (ctx, response) {
                      return GestureDetector(
                        child: Container(
                            margin: EdgeInsets.all(70),
                            child: Image.asset('assets/pantof.png')),
                        onTap: () async {
                          if (await Permission.notification
                              .request()
                              .isGranted) {}
                          await BackgroundLocation.setAndroidNotification(
                            title: 'You are currently tracking your steps',
                            message: 'Keep up the good work',
                            icon: '@mipmap/ic_launcher',
                          );
                          //await BackgroundLocation.setAndroidConfiguration(1000);
                          await BackgroundLocation.startLocationService(
                              distanceFilter: 20);
                          BackgroundLocation.getLocationUpdates((location) {
                            setState(() {
                              latitude = location.latitude.toString();
                              longitude = location.longitude.toString();
                              double getLatitude = double.parse(latitude);
                              double getLongitude = double.parse(longitude);
                              DateTime fulltime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      location.time!.toInt());
                              time = DateFormat('dd-MM-yyyy').format(fulltime);
                              _newEntry(getLatitude, getLongitude);
                              distance = response.data.toString();
                              if (newDay.toString().compareTo(time) < 1) {
                                newDay = DateTime(fulltime.year, fulltime.month,
                                    fulltime.day + 1);
                                _newDay(newDay.toString());
                              }
                            });
                          });
                        },
                      );
                    }),
                Text(
                  'Today\'s Distance',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 17,
                ),
                locationData(distance + '  m'),
                SizedBox(
                  height: 40,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0x00474b24),
                      ),
                      onPressed: () {
                        BackgroundLocation.stopLocationService();
                      },
                      child: Text('Stop Step Tracker')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget locationData(String data) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
