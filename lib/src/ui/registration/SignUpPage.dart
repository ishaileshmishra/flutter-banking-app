import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/ui/dashboard/dashboard_page.dart';
import 'package:alok/src/utils/widgets.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //
  // Error fields
  String errorIdProof;
  String errorFirstname;
  String errorLastname;
  String errorMobileNumber;
  String errorPassword;

  //emailController
  final TextEditingController idProofController = TextEditingController();
  final TextEditingController idProodNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // void _validateCredentials(credentials) async {
  //   //var box = await Hive.openBox(constant.csHiveDB);
  //   //var body = json.encode(credentials);
  //   var response = await http.post(Res.registerAPI, body: credentials);
  //   if (response.statusCode == 200) {
  //     var resp = json.decode(response.body);
  //     if (resp["success"]) {
  //       // Store Data to Hive Database
  //       // box.put(constant.csIsLoggedIn, true);
  //       // box.put(constant.csLoginAuthToken, authToken);
  //       // box.put(constant.csLoginUsername, username);
  //       Map userData = resp['data'];
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => DashBoardScreen(
  //                   //user: userData,
  //                   )));
  //     } else {
  //       showToast(context, resp["message"]);
  //     }
  //   } else {
  //     // box.put(constant.csIsLoggedIn, false);
  //     // var data = json.decode(response.body);
  //     // var errorMsg = data["error_message"];
  //     Toast.show('Failed To Login', context,
  //         duration: Toast.LENGTH_LONG,
  //         gravity: Toast.BOTTOM,
  //         backgroundColor: Colors.red);
  //   }
  // }

  Widget _showWelcomeText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text("Create\nAccount",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left),
      ),
    );
  }

  Widget _textFieldIDProof() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: textFieldDec(),
      child: TextField(
        controller: idProofController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "ID Proof",
            labelText: 'ID Proof',
            errorText: errorIdProof,
            prefixIcon: const Icon(
              Icons.perm_identity_outlined,
              color: Res.accentColor,
            ),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _textFieldIDProofNumber() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: textFieldDec(),
      child: TextField(
        controller: idProodNumberController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "ID proof number",
            labelText: 'ID proof number',
            prefixIcon: const Icon(
              Icons.email,
              color: Res.accentColor,
            ),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _textFieldFirstName() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: textFieldDec(),
      child: TextField(
        controller: firstNameController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "First name",
            labelText: 'First name',
            errorText: errorFirstname,
            prefixIcon: const Icon(
              Icons.email,
              color: Res.accentColor,
            ),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: textFieldDec(),
      child: TextField(
        controller: lastNameController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Last name",
            labelText: 'Last name',
            errorText: errorLastname,
            prefixIcon: const Icon(
              Icons.email,
              color: Res.accentColor,
            ),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _textFieldMobileNumber() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: textFieldDec(),
      child: TextField(
        controller: mobileNumberController,
        maxLength: 10,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Mobile number",
            labelText: 'Mobile number',
            errorText: errorMobileNumber,
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
            errorText: errorPassword,
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
      children: [_gestureDetectorSignup(), _btnSignUp()],
    );
  }

  Future<void> _onBtnPressed() async {
    //
    // Validator
    //

    /// clear app the fields
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
      "idProofNumber": idProodNumberController.text.trim(),
      "firstName": firstNameController.text.trim(),
      "email": '',
      "lastName": lastNameController.text.trim(),
      "mobileNumber": mobileNumberController.text.trim(),
      "password": passwordController.text.trim(),
    };

    fetchLoginResponse(context, credentials);
  }

  fetchLoginResponse(context, credentials) async {
    await http.post(Res.registerAPI, body: credentials).then((response) {
      Map userMap = json.decode(response.body);
      print(userMap);
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
                  builder: (context) => DashBoardScreen(
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          backgroundColor: Res.accentColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                // Welcome test with background
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Center(
                    child: _showWelcomeText(),
                  ),
                ),

                //
                // Flexible listview
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Sign Up
                        Text("Sign Up",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left),

                        SizedBox(height: 20),
                        //mobile textField
                        _textFieldIDProof(),
                        _textFieldIDProofNumber(),
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
              ],
            ),
          )),
    );
  }

  Row _btnSignUp() {
    return Row(
      children: [
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Res.accentColor)),
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _onBtnPressed();
          },
          color: Res.accentColor,
          textColor: Colors.white,
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
              Icon(CupertinoIcons.chevron_forward)
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector _gestureDetectorSignup() {
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
            color: Res.accentColor,
            //fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
