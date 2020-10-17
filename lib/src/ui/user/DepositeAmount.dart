import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/UserAccountModel.dart';
import 'package:alok/src/ui/user/Components.dart';
import 'package:alok/src/utils/widgets.dart';

class DepositeAmountScreen extends StatefulWidget {
  @override
  _DepositeAmountScreenState createState() => _DepositeAmountScreenState();
}

class _DepositeAmountScreenState extends State<DepositeAmountScreen> {
  List<UserAccountModel> accoutList = new List<UserAccountModel>();
  var errorTextFields = '';
  Map<String, String> dataToPost;
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _remarkController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _validateDepositeFields() {
    errorTextFields = '';
    if (_accountController.text.isEmpty || _accountController.text.length < 6) {
      setState(() {
        errorTextFields = 'Pls provide valid account number';
      });
      return;
    } else if (_amountController.text.isEmpty ||
        _amountController.text.length < 2) {
      setState(() {
        errorTextFields = 'Pls provide a valid amount';
      });
      return;
    } else if (_remarkController.text.isEmpty) {
      setState(() {
        errorTextFields =
            'Pls Provide Remark, So you can remmenber your spendings!!';
      });
      return;
    }
    setState(() {
      errorTextFields = '';
    });
    // dataToPost = new Map<String, String>();
    dataToPost = {
      'accountNumber': _accountController.text.trim(),
      'amount': _amountController.text.trim(),
      'remark': _remarkController.text.trim(),
    };
  }

  loadAccountList() async {
    await http.get(Res.accountListAPI).then((response) {
      if (response.statusCode == 200) {
        Map userMap = json.decode(response.body);
        if (userMap['success']) {
          showToast(context, userMap['message']);
          var accountsJson = jsonDecode(response.body)['data'] as List;
          accoutList = accountsJson
              .map((tagJson) => UserAccountModel.fromJson(tagJson))
              .toList();
          setState(() {
            accoutList = accoutList;
            print(accoutList.toString());
          });
        } else {
          showToastWithError(context, userMap['message']);
        }
      }
    }).catchError((error) {
      showToastWithError(context, error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    errorTextFields = '';
    loadAccountList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        //
        // Applicationbar
        key: _scaffoldKey,
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
                          SizedBox(height: 20),
                          Text(
                            '$errorTextFields',
                            style: TextStyle(color: Colors.red),
                          ),
                          //====================================
                          Container(
                            decoration: buildBoxDecoration(),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: DropDown(
                              items: accoutList,
                              isExpanded: true,
                              showUnderline: true,
                              dropDownType: DropDownType.Button,
                              hint: Text('Accounts'),
                              onChanged: (value) {
                                print(value);
                                //selectedAccountTypeInteger = mapAccounts[value];
                                //print(selectedAccountTypeInteger);
                              },
                            ),
                          ),
                          //====================================
                          SizedBox(height: 10),
                          CupertinoTextField(
                            controller: _amountController,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            prefix: buildPadding(),
                            padding: EdgeInsets.all(10),
                            keyboardType: TextInputType.number,
                            placeholder: "Amount",
                            decoration: buildBoxDecoration(),
                          ),
                          //====================================
                          SizedBox(height: 10),
                          CupertinoTextField(
                            controller: _remarkController,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            prefix: buildPadding(),
                            padding: EdgeInsets.all(10),
                            keyboardType: TextInputType.name,
                            placeholder: "Remark",
                            decoration: buildBoxDecoration(),
                          ),
                          //====================================
                          SizedBox(height: 40),
                          //Submit Button
                          CupertinoButton(
                            child: Text('Submit'),
                            color: Res.primaryColor,
                            onPressed: () async {
                              _validateDepositeFields();
                              // Senfing dataToPost
                              print(dataToPost);
                              final response = await http
                                  .post(Res.createDepositAPI, body: dataToPost);
                              if (response.statusCode == 200) {
                                Map userMap = json.decode(response.body);
                                print(userMap);

                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(userMap['message']),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 5),
                                ));
                              } else {
                                print('Failed to deposite amount');
                              }
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
