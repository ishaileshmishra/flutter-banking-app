import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/ui/account/AccountPage.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key key, this.user, this.userId}) : super(key: key);

  final LoginResponse user;
  final String userId;

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  List<String> bannerImages = [
    "https://images.pexels.com/photos/3258580/pexels-photo-3258580.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    "https://images.pexels.com/photos/3258582/pexels-photo-3258582.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    "https://images.pexels.com/photos/3259726/pexels-photo-3259726.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500"
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    loadDashboared();
    super.initState();
  }

  Future<void> loadDashboared() async {
    await http
        .get(
            "http://asralokkalyan.in/user/dashboard?userId=${widget.userId.toString()}")
        .then((response) {
      Map dashboard = json.decode(response.body);
      if (dashboard['success']) {
        setState(() {
          //bannerImages = dashboard['bannerImages'];
          //print("bannerImages: $bannerImages");
        });
      }
    }).catchError((onError) {
      print('Failed to get dashboard: ${onError.toString()}');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          backgroundColor: Res.accentColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: height / 2,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset('assets/images/dashboard.png'),
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AccountMngntScreen(
                                              user: widget.user,
                                            )));
                              },
                              child: Image.asset(
                                'assets/icons/1.png',
                                height: 60,
                                width: 60,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/2.png',
                              height: 60,
                              width: 60,
                            ),
                            Image.asset(
                              'assets/icons/3.png',
                              height: 60,
                              width: 60,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/icons/4.png',
                              height: 60,
                              width: 60,
                            ),
                            Image.asset(
                              'assets/icons/5.png',
                              height: 60,
                              width: 60,
                            ),
                            Image.asset(
                              'assets/icons/6.png',
                              height: 60,
                              width: 60,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/icons/7.png',
                              height: 60,
                              width: 60,
                            ),
                            Image.asset(
                              'assets/icons/8.png',
                              height: 60,
                              width: 60,
                            ),
                            Image.asset(
                              'assets/icons/9.png',
                              height: 60,
                              width: 60,
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: double.infinity,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.grey.shade100,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  CupertinoIcons.globe,
                                  size: 35,
                                  color: Colors.green,
                                ),
                                Icon(
                                  Icons.search,
                                  size: 35,
                                ),
                                Icon(
                                  CupertinoIcons.location,
                                  size: 35,
                                ),
                                Icon(
                                  CupertinoIcons.profile_circled,
                                  size: 35,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: ImagesSlider(
                              items:
                                  map<Widget>(bannerImages, (index, position) {
                                return Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(position),
                                          fit: BoxFit.cover)),
                                );
                              }),
                              autoPlay: true,
                              viewportFraction: 1.0,
                              aspectRatio: 2.0,
                              distortion: false,
                              align: IndicatorAlign.bottom,
                              indicatorWidth: 2,
                              updateCallback: (index) {
                                // setState(() {
                                //   _current = index;
                                // });
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
