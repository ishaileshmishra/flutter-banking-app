import 'package:alok/res.dart';
import 'package:alok/src/app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // find the path for the storage directory
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  //await Hive.initFlutter();
  //await Hive.openBox(constant.csHiveDB);
  //runApp(ContentstackApp());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Res.primaryColor,
        accentColor: Res.accentColor,
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.ptSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: AlokApp(),
    );
  }
}
