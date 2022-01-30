import 'package:flutter/material.dart';

class DetailsCorona extends StatelessWidget {
  const DetailsCorona({Key? key}) : super(key: key);

  static const routName = '/details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Color(0xff8ddca4),
      appBar: AppBar(
        backgroundColor: Color(0xff474b24),
        title: Text('Cases per day - ${args.toString()}'),
      ),
      body: Container(
        child: Column(
          children: [
            Image.network(
                "https://corona.dnsforfamily.com/graph.png?c=${args.toString()}"),
            SizedBox(
              height: 400,
            ),
            Text(
              'Powered by BECKS++',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
