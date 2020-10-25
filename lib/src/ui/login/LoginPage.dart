import 'dart:convert';

import 'package:alok/src/ui/user/Components.dart';
import 'package:alok/src/utils/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/ui/dashboard/dashboard_page.dart';
import 'package:alok/src/ui/login/Components.dart';

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
  bool _validateMobile = false;
  var _validatePassword = false;

  // EmailController
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _textFieldMobile() {
    return TextField(
      controller: mobileController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLength: 10,
      decoration: InputDecoration(
        errorText: _validateMobile ? "Please check mobile number" : null,
        contentPadding: EdgeInsets.all(0),
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "Mobile number",
        prefixIcon: const Icon(CupertinoIcons.phone),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ), //buildInputDecoration('ID card number'),
    );
  }

  Widget _textFieldPassword() {
    return TextField(
      controller: passwordController,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        errorText: _validatePassword ? "Provide password" : null,
        contentPadding: EdgeInsets.all(0),
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "Password",
        prefixIcon: const Icon(CupertinoIcons.lock),
        hintStyle: TextStyle(color: Colors.grey[400]),
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
      _validateMobile = false;
      _validatePassword = false;
    });
    if (mobileController.text.isEmpty || mobileController.text.length < 10) {
      setState(() {
        _validateMobile = true;
      });
      return;
    }
    if (passwordController.text == null || passwordController.text.isEmpty) {
      setState(() {
        _validatePassword = true;
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
      print("Json decoded: $userMap");
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
          print(userMap);
          showToastWithError(context, userMap['message']);
        }
      }
    }).catchError((onError) {
      print('error: $onError');
      showToastWithError(context, 'Failed ${onError.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text("Sign In",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left),

                          //=======================
                          SizedBox(height: 30),
                          _textFieldMobile(),
                          //=======================
                          SizedBox(height: 10),
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
              ),
            ],
          )),
    );
  }
}
