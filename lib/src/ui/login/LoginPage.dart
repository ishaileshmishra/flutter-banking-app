import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/ui/dashboard/dashboard_page.dart';
import 'package:alok/src/ui/login/Components.dart';
import 'package:alok/src/utils/widgets.dart';

class LoginPage extends StatefulWidget {
  //
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //
  // Error Fields
  bool isLoading = false;
  String errorTextMobile;
  String errorTextPassword;

  // EmailController
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _textFieldMobile() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: textFieldDec(),
      child: TextField(
        controller: mobileController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Mobile number",
            labelText: 'Mobile Number',
            errorText: errorTextMobile,
            prefixIcon: const Icon(
              Icons.email,
              color: Res.accentColor,
            ),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: textFieldDec(),
      child: TextField(
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Password',
            hintText: 'Password',
            errorText: errorTextPassword,
            prefixIcon: const Icon(
              Icons.lock,
              color: Res.accentColor,
            ),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [btnRegistration(context), loginBtn()],
    );
  }

  Row loginBtn() {
    return Row(
      children: [
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Res.accentColor)),
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            verifiyCredentials();
          },
          color: Res.accentColor,
          textColor: Colors.white,
          child: Row(
            children: [
              Container(
                child: Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(CupertinoIcons.chevron_forward)
            ],
          ),
        ),
      ],
    );
  }

  verifiyCredentials() async {
    //Validation
    setState(() {
      errorTextMobile = null;
      errorTextPassword = null;
    });
    if (mobileController.text == null || mobileController.text.isEmpty) {
      setState(() {
        errorTextMobile = "Mobile number required";
      });
      return;
    }
    if (passwordController.text == null || passwordController.text.isEmpty) {
      setState(() {
        errorTextPassword = "Provide password";
      });
      return;
    }
    var credentials = {
      "mobileNumber": mobileController.text.trim(),
      "password": passwordController.text.trim(),
    };

    fetchLoginResponse(context, credentials);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  fetchLoginResponse(context, credentials) async {
    await http.post(Res.loginAPI, body: credentials).then((response) {
      Map userMap = json.decode(response.body);
      setState(() {
        isLoading = true;
      });
      if (response.statusCode == 200) {
        if (userMap['success']) {
          showToast(context, userMap['message']);
          LoginResponse loginDetails = LoginResponse.fromJson(userMap['data']);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DashBoardScreen(
                        user: loginDetails,
                      )));
        } else {
          showToastWithError(context, userMap['message']);
        }
      }
    }).catchError((onError) {
      showToastWithError(context, 'Failed to login');
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Res.accentColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Center(
                  child: showWelcomeText(),
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //=======================
                        _textFieldMobile(),
                        //=======================
                        _textFieldPassword(),
                        //=======================
                        SizedBox(height: 30),
                        _loginButton()
                        //=======================
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
