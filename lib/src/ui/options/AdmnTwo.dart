import 'package:alok/src/ui/login/Components.dart';
import 'package:flutter/material.dart';

class AdminTwo extends StatefulWidget {
  @override
  _AdminTwoState createState() => _AdminTwoState();
}

class _AdminTwoState extends State<AdminTwo> {
  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(143, 148, 251, 1),
          Color.fromRGBO(143, 148, 251, .6),
        ]));

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            buildAnimatedBackground('Admin Two'),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  //====================================
                  // TextField
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a search term'),
                  ),
                  //====================================
                  // TextField
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Text field One'),
                  ),
                  //====================================
                  // TextField
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Text field Two'),
                  ),
                  //====================================
                  // TextField
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Text field Three'),
                  ),
                  //====================================
                  // TextField
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Text field Four'),
                  ),
                  //====================================
                  // TextField
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Text field Five'),
                  ),
                  //====================================
                  SizedBox(
                    height: 30,
                  ),
                  //====================================
                  //Button
                  Container(
                    height: 50,
                    decoration: boxDecoration,
                    child: Center(
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  //====================================
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
