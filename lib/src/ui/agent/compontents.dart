import 'package:alok/res.dart';
import 'package:flutter/material.dart';

TextStyle buildTextStyle() => TextStyle(fontSize: 16, wordSpacing: 5);

AppBar buildAppBar(title) {
  return AppBar(
    centerTitle: true,
    title: Text(title),
    backgroundColor: Res.primaryColor,
    elevation: 0,
    actions: [
      Padding(
        padding: EdgeInsets.all(10),
        child: Icon(Icons.more_vert),
      )
    ],
  );
}

Container buildColoredContainer() {
  return Container(
    color: Res.primaryColor,
    height: 200,
  );
}
