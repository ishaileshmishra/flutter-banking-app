import 'package:alok/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepositeAmountScreen extends StatefulWidget {
  @override
  _DepositeAmountScreenState createState() => _DepositeAmountScreenState();
}

class _DepositeAmountScreenState extends State<DepositeAmountScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        //
        // Applicationbar
        appBar: AppBar(
          centerTitle: true,
          title: Text('Deposite'),
          backgroundColor: Res.primaryColor,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.more_vert),
            )
          ],
        ),

        // Singel Chiled ScrollView
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: Res.primaryColor,
                    height: 200,
                  ),

                  //field container
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          //====================================
                          CupertinoTextField(
                            clearButtonMode: OverlayVisibilityMode.editing,
                            prefix: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                CupertinoIcons.search,
                              ),
                            ),
                            placeholder: "Enter Email",
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: CupertinoColors.inactiveGray,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CupertinoTextField(
                            clearButtonMode: OverlayVisibilityMode.editing,
                            //controller: _myPhoneField, // Add this
                            prefix: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                CupertinoIcons.search,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            maxLines: 1,
                            maxLengthEnforced: true,
                            placeholder: 'Enter Phone',
                            onChanged: (v) {
                              print(v);
                            },
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: CupertinoColors.inactiveGray,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),

                          //====================================
                          SizedBox(
                            height: 30,
                          ),
                          //====================================
                          //Button
                          CupertinoButton(
                            child: Text('Submit'),
                            color: Res.primaryColor,
                            onPressed: () {
                              // Write your callback here
                            },
                          ),
                          //====================================
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
