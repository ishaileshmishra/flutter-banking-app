import 'package:alok/res.dart';
import 'package:alok/src/ui/registration/SignUpPage.dart';
import 'package:alok/src/utils/anims.dart';
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

Widget showWelcomeText() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Text("Welcome\nBack",
          style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left),
    ),
  );
}

GestureDetector btnRegistration(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    },
    child: Container(
      padding: EdgeInsets.all(8),
      child: Text(
        'Sign Up',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
          color: Res.accentColor,
        ),
      ),
    ),
  );
}
