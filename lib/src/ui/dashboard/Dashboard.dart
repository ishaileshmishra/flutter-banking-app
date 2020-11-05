import 'package:alok/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset('assets/images/dashboard.png'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              CupertinoIcons.share_up,
                              size: 60,
                            ),
                            Icon(
                              CupertinoIcons.money_rubl_circle,
                              size: 60,
                            ),
                            Icon(
                              CupertinoIcons.money_dollar_circle_fill,
                              size: 60,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              CupertinoIcons.padlock,
                              size: 60,
                            ),
                            Icon(
                              Icons.accessible_forward,
                              size: 60,
                            ),
                            Icon(
                              CupertinoIcons.rectangle_stack_fill,
                              size: 60,
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
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  CupertinoIcons.globe,
                                  size: 35,
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
                                  CupertinoIcons.phone,
                                  size: 35,
                                ),
                              ],
                            ),
                          ),
                        )

                        /// Show slid
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
