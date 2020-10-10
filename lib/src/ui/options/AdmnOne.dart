import 'package:alok/src/utils/FadeAnimation.dart';
import 'package:flutter/material.dart';

class AdminOne extends StatefulWidget {
  @override
  _AdminOneState createState() => _AdminOneState();
}

class _AdminOneState extends State<AdminOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Undefined")),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          // FocusScopeNode currentFocus = FocusScope.of(context);
          // if (!currentFocus.hasPrimaryFocus &&
          //     currentFocus.focusedChild != null) {
          //   currentFocus.focusedChild.unfocus();
          // }
        },
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //====================================
              //Dropdown

              //====================================
              // TextField
              TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter a search term'),
              ),
              //====================================
              // TextField
              TextField(
                decoration: InputDecoration(
                    labelText: 'Just demo, to check which is preferable'),
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
        ),
      ),
    );
  }
}
