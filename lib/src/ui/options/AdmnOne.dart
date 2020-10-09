import 'package:alok/src/ui/login/Components.dart';
import 'package:flutter/material.dart';

class AdminOne extends StatefulWidget {
  @override
  _AdminOneState createState() => _AdminOneState();
}

class _AdminOneState extends State<AdminOne> {
  @override
  Widget build(BuildContext context) {
    final String screenTitle = 'Admin';

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
            buildAnimatedBackground(screenTitle),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  //====================================
                  //Dropdown
                  Container(
                    width: double.infinity,
                    child: DropdownButton<String>(
                      icon: Icon(Icons.search),
                      items: <String>['Item 1', 'Item 2', 'Item 3', 'Item 4']
                          .map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
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
            )
          ],
        ),
      ),
    );
  }
}
