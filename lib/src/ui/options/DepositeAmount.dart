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
                          //Dropdown
                          //====================================
                          DropdownButton(
                              isExpanded: true,
                              items: [
                                new DropdownMenuItem(child: new Text("Abc")),
                                new DropdownMenuItem(child: new Text("Xyz")),
                              ],
                              hint: new Text("Select Type"),
                              onChanged: null),
                          //====================================
                          //Spaces
                          SizedBox(height: 20),
                          // TextField Remarks
                          CupertinoTextField(
                            clearButtonMode: OverlayVisibilityMode.editing,
                            prefix: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.edit_rounded),
                            ),
                            placeholder: "Remark",
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: CupertinoColors.inactiveGray,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),

                          //====================================
                          // Spaces
                          SizedBox(height: 30),
                          //Submit Button
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
