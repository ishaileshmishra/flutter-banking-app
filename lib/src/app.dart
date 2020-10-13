import 'package:alok/src/ui/login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:alok/src/utils/constants.dart' as constant;

class AlokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Hive.openBox(constant.csHiveDB);
    return MaterialApp(
      title: 'Alok',
      //debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Hive.openBox(constant.csHiveDB),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return LoginPage(title: 'Login');
              }
            } else {
              return Scaffold();
            }
          }),
    );
  }
}
