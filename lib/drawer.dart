import 'package:flutter/material.dart';
import 'package:hackaton1/CoronaVirus.dart';
import 'package:hackaton1/stepTracking.dart';
import 'package:hackaton1/weather.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Color(0xff474b24),
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Weather'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(WeatherPage.routName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.run_circle),
              title: Text('Sport'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Track.routName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.coronavirus),
              title: Text('Covid-19'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(CoronaPage.routName);
              }),
        ],
      ),
    );
  }
}
