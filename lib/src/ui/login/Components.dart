import 'package:alok/src/utils/fade_animation.dart';
import 'package:flutter/material.dart';

Container buildAnimatedBackground(String textBold) {
  return Container(
    height: 350,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/background.png'), fit: BoxFit.fill),
    ),
    child: Stack(
      children: <Widget>[
        _positionedLoginText(textBold),
      ],
    ),
  );
}

Positioned _positionedLoginText(String boldText) {
  return Positioned(
    child: FadeAnimation(
        1.6,
        Container(
          child: Center(
            child: Text(
              boldText,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )),
  );
}

showSnackbarError(scaffoldKey, message) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.red.shade600,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 5),
  ));
}

showSnackbarSuccess(scaffoldKey, message) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 5),
  ));
}
