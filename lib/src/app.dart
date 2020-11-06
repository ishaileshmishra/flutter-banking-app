import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:alok/res.dart';
import 'package:alok/src/ui/login/LoginPage.dart';
import 'package:alok/src/utils/constants.dart' as constant;

class AlokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Hive.openBox(constant.csHiveDB);
    return MaterialApp(
      color: Res.primaryColor,
      title: 'Alok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: FutureBuilder(
          future: Hive.openBox(constant.csHiveDB),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return LoginPage();

                // SplashScreen(
                //   seconds: 14,
                //   navigateAfterSeconds: LoginPage(),
                //   title: new Text(
                //     'Welcome In SplashScreen',
                //     style: new TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20.0,
                //     ),
                //   ),
                //   image: new Image.network(
                //       'https://flutter.io/images/catalog-widget-placeholder.png'),
                //   backgroundColor: Colors.white,
                //   loaderColor: Colors.red,
                // );
              }
            } else {
              return Scaffold();
            }
          }),
    );
  }
}
