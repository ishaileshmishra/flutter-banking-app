import 'dart:convert';
import 'package:alok/res.dart';
import 'package:alok/src/ui/dashboard/dashboard_page.dart';
import 'package:alok/src/ui/registration/SignUpPage.dart';
import 'package:alok/src/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

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

  void _validateCredentials(credentials) async {
    //var box = await Hive.openBox(constant.csHiveDB);
    var body = json.encode(credentials);
    print('Sending body $body');
    http.Response response = await http.post(Res.loginAPI, body: credentials);
    if (response.statusCode == 200) {
      var resp = json.decode(response.body);
      print(
          'isLoggedIn: ${resp["success"]} \nmessage ${resp['message']} \ndata ${resp['data']}');

      if (resp["success"]) {
        // Store Data to Hive Database
        // box.put(constant.csIsLoggedIn, true);
        // box.put(constant.csLoginAuthToken, authToken);
        // box.put(constant.csLoginUsername, username);
        Map userData = resp['data'];
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashBoardScreen(
                      user: userData,
                    )));
      } else {
        // box.put(constant.csIsLoggedIn, false);
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //     resp["success"],
        //     textAlign: TextAlign.center,
        //     style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        //   ),
        //   duration: Duration(seconds: 2),
        //   backgroundColor: Colors.red,
        // ));
        showToast(context, resp["message"]);
      }
    } else {
      // box.put(constant.csIsLoggedIn, false);
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Sorry ! We have recieved invalid response")));
    }
  }

  Widget _showWelcomeText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text("Welcome\nBack",
            style: TextStyle(fontSize: 30, color: Colors.white),
            textAlign: TextAlign.left),
      ),
    );
  }

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
      children: [_gestureDetectorSignup(), _btnSignIn()],
    );
  }

  Future<void> _onBtnPressed() async {
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
    var data = {
      "mobileNumber": mobileController.text.trim(),
      "password": passwordController.text.trim(),
    };

    // Future<LoginResponse> futureResponse = fetchLoginResponse(data);
    // futureResponse.then((response) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
    // }).catchError((onError) {
    //   showToast(context, 'Invalid response recieved');
    // });
    _validateCredentials(data);
  }

  // _waitToCheckLogin() async {
  //   var box = await Hive.openBox(constant.csHiveDB);
  //   bool loggedIn = box.get(constant.csIsLoggedIn, defaultValue: false);
  //   print('loggedIn: $loggedIn');
  //   print('username: ${box.get(constant.csLoginUsername)}');
  //   print('authtoken: ${box.get(constant.csLoginAuthToken)}');
  //   if (loggedIn) {
  //     box.get(constant.csIsLoggedIn);
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => StackPage(
  //                 authToken: box.get(constant.csLoginAuthToken),
  //                 userName: box.get(constant.csLoginUsername))));
  //   }
  // }

  @override
  void initState() {
    //_waitToCheckLogin();
    super.initState();
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
                  child: _showWelcomeText(),
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
                        //mobile textField
                        _textFieldMobile(),

                        //password textField
                        _textFieldPassword(),

                        //space
                        SizedBox(height: 30),

                        //login button
                        _loginButton()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Row _btnSignIn() {
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

  GestureDetector _gestureDetectorSignup() {
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
            //fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
