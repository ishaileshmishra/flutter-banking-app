import 'dart:async';

import 'package:flutter/material.dart';

import 'package:alok/src/ui/login/LoginPage.dart';
import 'package:flutter/services.dart';

class ImageSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<ImageSplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 8);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    var scrnWidth = MediaQuery.of(context).size.width;
    var scrnHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: scrnHeight,
      width: scrnWidth,
      child: Image.asset('assets/images/splash.png'),
    ));
  }
}
