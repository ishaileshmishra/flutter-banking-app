import 'package:alok/src/ui/login/Components.dart';
import 'package:alok/src/utils/fade_animation.dart';
import 'package:flutter/material.dart';

class AdminOne extends StatefulWidget {
  @override
  _AdminOneState createState() => _AdminOneState();
}

class _AdminOneState extends State<AdminOne> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        //appBar: AppBar(title: Text("Undefined")),
        body: SingleChildScrollView(
          child: Container(
            //padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildAnimatedBackground('Undefined-1'),
                //====================================
                //Dropdown

                //====================================
                // TextField

                Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      ///////////////////////
                      ///  Mobile Number  ///
                      //////////////////////
                      ///
                      TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter a search term'),
                      ),

                      ///////////////////////
                      ///  Mobile Number  ///
                      //////////////////////
                      ///
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[300]))),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Mobile number",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
