import 'package:alok/src/ui/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:alok/res.dart';
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
      home: ImageSplashScreen(),

      // FutureBuilder(
      //     future: Hive.openBox(constant.csHiveDB),
      //     builder: (BuildContext context, AsyncSnapshot snapshot) {
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         if (snapshot.hasError) {
      //           return Text(snapshot.error.toString());
      //         } else {
      //           return LoginPage();
      //         }
      //       } else {
      //         return Scaffold();
      //       }
      //     }),
      
    );
  }
}
