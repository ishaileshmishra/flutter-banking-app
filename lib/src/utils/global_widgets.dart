import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

Widget loginText() {
  return Text("Login to your account",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[500]),
      textAlign: TextAlign.left);
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

var lastModifiedStyle = TextStyle(
    fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.bold);

var titleStyle =
    TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold);

Widget circularPB() {
  return Center(
      child: CircularProgressIndicator(
    strokeWidth: 2,
  ));
}

var boldHeadline =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);

Widget verticalSpace() {
  return SizedBox(height: 20);
}

String convertToDate(var tempDate) {
  //2020-01-29T22:26:01.157Z
  if (tempDate.contains('T')) {
    tempDate = tempDate.split('T');
  }
  return tempDate[0];
}

Widget lastModified(var tempDate) {
  return Center(
    child: Text(
      "Last modified: ${convertToDate(tempDate)}" ?? "Not available",
      style: lastModifiedStyle,
    ),
  );
}

Widget showGridCard(String title, String lastModified) {
  return Card(
    elevation: 3.0,
    child: Padding(
      padding: EdgeInsets.all(18),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              maxLines: 3,
              style: titleStyle,
            ),
            //_verticalSpace(),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                convertToDate(lastModified),
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget logoContainer() {
  return Container(
      height: 450,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: getColorFromHex("#E7484A"),
          borderRadius: BorderRadius.only(
              //bottomLeft: Radius.circular(80),
              )),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Image.asset('assets/images/logo.png'),
      ));
}

void showToast(BuildContext context, messageShow) {
  Toast.show(messageShow, context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: Colors.green);
}

void showToastWithError(BuildContext context, messageShow) {
  Toast.show(messageShow, context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: Colors.red);
}

Widget myAppBarIcon() {
  return Container(
    width: 30,
    height: 30,
    child: Stack(
      children: [
        Icon(
          Icons.notifications,
          color: Colors.white,
          size: 30,
        ),
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(top: 5),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffc32c37),
                border: Border.all(color: Colors.white, width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: Text(
                  '2',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

BoxDecoration textFieldDec() {
  return BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey[300])));
}
