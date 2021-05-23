import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.lightGreen,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.width - 150,
              width: MediaQuery.of(context).size.width - 150,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  alignment: Alignment.center,
                  image: ExactAssetImage('assets/images/waiting.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              alignment: Alignment.topCenter,
            ),
            SizedBox(height: 100),
            Align(
              child: CircularProgressIndicator(),
              alignment: Alignment.bottomCenter,
            ),
            SizedBox(height: 20),
            Align(
              child: Text(
                'Version: v1.0.0',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
              ),
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
    );
  }
}
