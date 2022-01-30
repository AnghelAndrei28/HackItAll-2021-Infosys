import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hackaton1/CoronaVirus.dart';
import 'package:hackaton1/detailsCorona.dart';
import 'package:hackaton1/stepTracking.dart';
import 'package:hackaton1/welcomePage.dart';
import './weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Travel Info",
      home: WelcomePageScreen(),
      routes: {
        WeatherPage.routName: (ctx) => WeatherPage(),
        WelcomePageScreen.routName: (ctx) => WelcomePageScreen(),
        Track.routName: (ctx) => Track(),
        CoronaPage.routName: (ctx) => CoronaPage(),
        DetailsCorona.routName: (ctx) => DetailsCorona(),
      },
    );
  }
}
