import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomePageScreen extends StatelessWidget {
  const WelcomePageScreen({Key? key}) : super(key: key);

  static const routName = '/start';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff8ddca4),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/weather');
          },
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                child: Image.asset('assets/Icon.png'),
                margin: EdgeInsets.all(50),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Travel Info',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff474b24),
                    fontSize: 20),
              ),
              SizedBox(
                height: 280,
              ),
              Text(
                'Powered by BECKS++',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Color(0xff474b24),
                    fontSize: 15),
              )
            ],
          ),
        ));
  }
}
