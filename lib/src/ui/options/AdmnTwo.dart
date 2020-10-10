import 'package:alok/src/ui/login/Components.dart';
import 'package:alok/src/utils/fade_animation.dart';
import 'package:flutter/material.dart';

class AdminTwo extends StatefulWidget {
  @override
  _AdminTwoState createState() => _AdminTwoState();
}

class _AdminTwoState extends State<AdminTwo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                buildAnimatedBackground('Undefined-2'),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      //====================================
                      // TextField
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Text field One'),
                      ),
                      //====================================
                      // TextField
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Text field Two'),
                      ),
                      //====================================
                      // TextField
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Text field Three'),
                      ),
                      //====================================
                      // TextField
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Text field Four'),
                      ),
                      //====================================
                      // TextField
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Text field Five'),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
