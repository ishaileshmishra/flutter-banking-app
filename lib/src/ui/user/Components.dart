import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoTextField buildCupertinoTextField(_stringField, controller) {
  return CupertinoTextField(
    controller: controller,
    clearButtonMode: OverlayVisibilityMode.editing,
    padding: EdgeInsets.all(10),
    prefix: Padding(padding: EdgeInsets.all(6.0)),
    placeholder: _stringField,
    keyboardType: TextInputType.number,
    decoration: BoxDecoration(
      border: Border.all(
        width: 1.0,
        color: CupertinoColors.inactiveGray,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}

Padding buildPadding() {
  return Padding(
    padding: EdgeInsets.all(6.0),
  );
}

BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    border: Border.all(
      width: 1.0,
      color: CupertinoColors.inactiveGray,
    ),
    borderRadius: BorderRadius.circular(8.0),
  );
}

OutlineInputBorder buildEnabledOutlineInputBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: CupertinoColors.inactiveGray,
      width: 1.0,
    ),
  );
}

OutlineInputBorder buildFocusedOutlineInputBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: CupertinoColors.inactiveGray,
      width: 1.0,
    ),
  );
}

bool isValidMail(emailAddress) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (emailAddress.isNotEmpty && !regex.hasMatch(emailAddress)) {
    return false;
  }
  return true;
}
