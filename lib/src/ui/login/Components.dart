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
        //_positionedLight1(),
        //_positionedLight2(),
        //_positionedClock(),
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
          //margin: EdgeInsets.only(top: 40),
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

// Positioned _positionedClock() {
//   return Positioned(
//     right: 40,
//     top: 40,
//     width: 80,
//     height: 150,
//     child: FadeAnimation(
//         1.5,
//         Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage('assets/images/clock.png'))),
//         )),
//   );
// }

// Positioned _positionedLight2() {
//   return Positioned(
//     left: 140,
//     width: 80,
//     height: 150,
//     child: FadeAnimation(
//         1.3,
//         Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage('assets/images/light-2.png'))),
//         )),
//   );
// }

// Positioned _positionedLight1() {
//   return Positioned(
//     left: 30,
//     width: 80,
//     height: 200,
//     child: FadeAnimation(
//         1,
//         Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage('assets/images/light-1.png'))),
//         )),
//   );
// }
