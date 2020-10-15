import 'package:flutter/material.dart';

// For Assets, Colors, Fonts Etc..
class Res {
  // UI Resources
  static const String logo = "assets/images/logo.png";
  static const Color accentColor = Color.fromRGBO(167, 96, 222, 1);
  static const Color primaryColor = Color.fromRGBO(148, 94, 217, 1);
  static const gradient = LinearGradient(colors: [accentColor, primaryColor]);
  static const Color white54 = Color(0x8AFFFFFF);

  //API Constants
  static const String baseURL = 'http://asralokkalyan.in/user/';
  static const String loginAPI = baseURL + 'login';
  static const String registerAPI = baseURL + 'signup';
  static const String createAccount = baseURL + 'createAccount';
  static const String accountType = baseURL + 'accountTypeList';
  static const String createDepositAPI = baseURL + 'createDepositRequest';
  static const String depositAmountListAPI =
      baseURL + 'depositAmountRequestList';
  static const String depositAmountAPI = baseURL + 'depositAmount';
}
