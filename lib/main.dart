import 'package:alok/src/ui/login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final color = Color.fromRGBO(109, 115, 224, 1);
    return MaterialApp(
      title: 'Alok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: color,
        textTheme: GoogleFonts.sansitaTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: LoginPage(title: 'Alok'),
    );
  }
}
