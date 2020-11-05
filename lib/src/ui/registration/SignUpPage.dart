import 'dart:convert';

import 'package:alok/src/ui/account/AccountPage.dart';
import 'package:alok/src/ui/login/Components.dart';
import 'package:alok/src/ui/user/Components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:alok/res.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/utils/global_widgets.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String errorIdProof;
  String errorFirstname;
  String errorLastname;
  String errorMobileNumber;
  String errorPassword;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _textFieldFirstName() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: firstNameController,
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          counterText: "",
          errorText: errorFirstname,
          contentPadding: EdgeInsets.all(0),
          focusedBorder: buildFocusedOutlineInputBorder(),
          enabledBorder: buildEnabledOutlineInputBorder(),
          labelText: "First name",
          hintText: "First name",
          prefixIcon: const Icon(
            CupertinoIcons.person,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: lastNameController,
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          errorText: errorLastname,
          contentPadding: EdgeInsets.all(0),
          focusedBorder: buildFocusedOutlineInputBorder(),
          enabledBorder: buildEnabledOutlineInputBorder(),
          labelText: "Last name",
          hintText: "Last name",
          prefixIcon: const Icon(
            CupertinoIcons.person,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _textFieldMobileNumber() {
    return Container(
      padding: EdgeInsets.all(8.0),
      //decoration: textFieldDec(),
      child: TextField(
        controller: mobileNumberController,
        maxLength: 10,
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          counterText: "",
          errorText: errorMobileNumber,
          contentPadding: EdgeInsets.all(0),
          focusedBorder: buildFocusedOutlineInputBorder(),
          enabledBorder: buildEnabledOutlineInputBorder(),
          labelText: "Mobile number",
          hintText: "Mobile number",
          prefixIcon: const Icon(
            CupertinoIcons.phone,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          counterText: "",
          errorText: errorPassword,
          contentPadding: EdgeInsets.all(0),
          focusedBorder: buildFocusedOutlineInputBorder(),
          enabledBorder: buildEnabledOutlineInputBorder(),
          labelText: "Password",
          hintText: "Password",
          prefixIcon: const Icon(
            CupertinoIcons.lock,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_gestureDetectorSignup(context), _btnSignUp(context)],
    );
  }

  Future<void> _onBtnPressed() async {
    setState(() {
      errorFirstname = null;
      errorLastname = null;
      errorMobileNumber = null;
      errorPassword = null;
    });

    if (firstNameController.text == null || firstNameController.text.isEmpty) {
      setState(() {
        errorFirstname = "First name required";
      });
      return;
    }

    if (lastNameController.text == null || lastNameController.text.isEmpty) {
      setState(() {
        errorLastname = "Last name required";
      });
      return;
    }

    if (mobileNumberController.text.isEmpty ||
        mobileNumberController.text.length < 10) {
      setState(() {
        errorMobileNumber = "Mobile number required";
      });
      return;
    }

    if (passwordController.text == null || passwordController.text.isEmpty) {
      setState(() {
        errorPassword = "Password required";
      });
      return;
    }

    var credentials = {
      "firstName": firstNameController.text.trim(),
      "email": '',
      "lastName": lastNameController.text.trim(),
      "mobileNumber": mobileNumberController.text.trim(),
      "password": passwordController.text.trim(),
    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    fetchSignupResponse(context, credentials);
  }

  fetchSignupResponse(context, credentials) async {
    await http.post(Res.registerAPI, body: credentials).then((response) {
      Map userMap = json.decode(response.body);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        if (userMap['success']) {
          showToast(context, userMap['message']);
          LoginResponse loginDetails = LoginResponse.fromJson(userMap['data']);
          var box = Hive.box(Res.aHiveDB);
          box.put(Res.loggedInStatus, true);
          box.put(Res.aUserId, loginDetails.userId);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AccountMngntScreen(
                        user: loginDetails,
                      )));
        } else {
          showToastWithError(context, userMap['message']);
        }
      }
    }).catchError((onError) {
      showToastWithError(context, 'Failed to login');
    });
  }

  GestureDetector _gestureDetectorSignup(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Text(
          'Back',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Row _btnSignUp(context) {
    return Row(
      children: [
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Res.accentColor)),
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _onBtnPressed();
          },
          color: Res.accentColor,
          textColor: Colors.black,
          child: Row(
            children: [
              Container(
                child: Text(
                  'Create',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset('assets/images/trending.png'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Res.accentColor,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Center(
              child: showWelcomeText(),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  Text("Sign Up",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left),

                  SizedBox(height: 20),
                  //mobile textField
                  //_textFieldIDProof(),
                  //_textFieldIDProofNumber(),
                  _textFieldFirstName(),
                  _textFieldLastName(),
                  _textFieldMobileNumber(),
                  _textFieldPassword(),
                  //space
                  SizedBox(height: 30),
                  //login button
                  _loginButton()
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
