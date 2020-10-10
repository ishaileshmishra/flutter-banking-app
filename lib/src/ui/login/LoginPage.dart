import 'dart:convert';
import 'package:alok/src/models/LoginModel.dart';
import 'package:alok/src/network/requests.dart';
import 'package:alok/src/ui/dashboard/Dashboard.dart';
import 'package:alok/src/ui/dashboard/dashboard_page.dart';
import 'package:alok/src/ui/login/Components.dart';
import 'package:alok/src/ui/registration/SignUpPage.dart';
import 'package:alok/src/utils/fade_animation.dart';
import 'package:alok/src/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  String errorTextEmail;
  String errorTextPassword;
  final TextEditingController passwordController = TextEditingController();

  void _validateCredentials(credentials) async {
    //var box = await Hive.openBox(constant.csHiveDB);
    String loginUrl = "https://api.contentstack.io/v3/user-session";
    var body = json.encode(credentials);
    var response = await http.post(loginUrl,
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      //var data = json.decode(response.body);
      //final authToken = data["user"]['authtoken'];
      //var username = data['user']["first_name"];

      // Store Data to Hive Database
      // box.put(constant.csIsLoggedIn, true);
      // box.put(constant.csLoginAuthToken, authToken);
      // box.put(constant.csLoginUsername, username);
      // Navigator.push(context, MaterialPageRoute(
      // builder: (context) => StackPage(authToken: authToken, userName: username)));
    } else {
      // box.put(constant.csIsLoggedIn, false);
      // var data = json.decode(response.body);
      // var errorMsg = data["error_message"];
      Toast.show('Failed To Login', context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.red);
    }
  }

  // Widget _logoContainer() {
  //   return Container(
  //       height: 450,
  //       width: double.infinity,
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //           color: getColorFromHex("#E7484A"),
  //           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 20),
  //         child: Image.asset('assets/images/light-1.png'),
  //       ));
  // }

  Widget _showLoginTextView() {
    return Text("Login",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        textAlign: TextAlign.left);
  }

  Widget _textFieldEmail() {
    return InkWell(
        child: TextField(
      controller: emailController,
      decoration: InputDecoration(
        border:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
        hintText: 'Mobile',
        labelText: 'Mobile Number',
        errorText: errorTextEmail,
        prefixIcon: const Icon(
          Icons.email,
          color: Colors.blueGrey,
        ),
      ),
    ));
  }

  Widget _textFieldPassword() {
    return InkWell(
        child: TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        border:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
        hintText: 'Password',
        errorText: errorTextPassword,
        labelText: 'password',
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.blueGrey,
        ),
      ),
    ));
  }

  Widget _loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
          child: Container(
            child: Text(
              'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Row(
          children: [
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color.fromRGBO(143, 148, 251, .6))),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _onBtnPressed();
              },
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              color: Color.fromRGBO(143, 148, 251, .6),
              textColor: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoardScreen()),
                      );
                    },
                    child: Container(
                      child: Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_forward_rounded)
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _onBtnPressed() async {
    if (emailController.text == null || emailController.text.isEmpty) {
      setState(() {
        errorTextEmail = "Please enter the email address";
      });
      return;
    }
    if (passwordController.text == null || passwordController.text.isEmpty) {
      setState(() {
        errorTextPassword = "Please enter the password";
      });
      return;
    }
    var data = {
      "user": {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      }
    };

    Future<LoginResponse> futureResponse = fetchLoginResponse(data);
    if (futureResponse == null) {
      showToast(context, 'Failed to login');
    }
    // futureResponse.then((response) {
    //   final username = '${response.firstName} ${response.lastName}';
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => StackPage(
    //               authToken: response.authToken, userName: username)));
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
          //appBar: AppBar(),
          backgroundColor: Colors.grey.shade200,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  buildAnimatedBackground('Welcome\nBack'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                            1.8,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  ///////////////////////
                                  ///  Mobile Number  ///
                                  //////////////////////
                                  ///
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[300]))),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Mobile number",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),

                                  ///////////////////////
                                  ///    Password    ///
                                  //////////////////////
                                  ///
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),

                                  ///////////////////////
                                  ///    Password    ///
                                  //////////////////////
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        _loginButton()
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   //final width = MediaQuery.of(context).size.width;
  //   //final height = MediaQuery.of(context).size.height;
  //   return GestureDetector(
  //     onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
  //     child: Scaffold(
  //         backgroundColor: Colors.white,
  //         body: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               buildAnimatedBackground('Welcome\nBack'),
  //               // background image container

  //               Container(
  //                 padding: EdgeInsets.all(20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     _showLoginTextView(),
  //                     verticalSpace(),
  //                     _textFieldEmail(),
  //                     verticalSpace(),
  //                     _textFieldPassword(),
  //                     verticalSpace(),
  //                     _loginButton(),
  //                     verticalSpace(),
  //                   ],
  //                 ),
  //               ),
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: Text(
  //                   'Forword Password?',
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )),
  //   );
  // }

}
