import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/UserAccountModel.dart';
import 'package:alok/src/ui/user/Components.dart';
import 'package:alok/src/utils/global_widgets.dart';

class DepositeAmountScreen extends StatefulWidget {
  @override
  _DepositeAmountScreenState createState() => _DepositeAmountScreenState();
}

class _DepositeAmountScreenState extends State<DepositeAmountScreen> {
  List<UserAccountModel> accoutList = new List<UserAccountModel>();
  var errorTextFields = '';
  String accountNumber;
  final _amountController = TextEditingController();
  String errorTextAmount;
  final _remarkController = TextEditingController();
  String errorTextRemark;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _validateDepositeFields() {
    setState(() {
      errorTextAmount = null;
      errorTextRemark = null;
    });
    if (_amountController.text == null ||
        _amountController.text.isEmpty ||
        _amountController.text.length < 2) {
      setState(() {
        errorTextAmount = "Pls provide amount";
      });
      return;
    }
    if (_remarkController.text == null || _remarkController.text.isEmpty) {
      setState(() {
        errorTextRemark = "Pls provide remark";
      });
      return;
    }
    var credentials = {
      "accountNumber": accountNumber,
      "amount": _amountController.text.trim().toString(),
      "remark": _remarkController.text.trim().toString(),
    };

    http.post(Res.createDepositAPI, body: credentials).then((response) async {
      Map userMap = json.decode(response.body);
      print(userMap);
      if (response.statusCode == 200) {
        showToast(context, userMap['message']);
        await new Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      } else {
        showToastWithError(context, userMap['message']);
      }
    }).catchError((error) {
      showToastWithError(context, 'Failed to submit ${error.toString()}');
    });
  }

  loadAccountList() async {
    var box = Hive.box(Res.aHiveDB);
    var userId = box.get(Res.aUserId);
    await http.get(Res.accountListAPI + '$userId').then((response) {
      if (response.statusCode == 200) {
        Map userMap = json.decode(response.body);
        if (userMap['success']) {
          //showToast(context, userMap['message']);
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
    Widget _textFieldAmount() {
      return Container(
        padding: EdgeInsets.all(8.0),
        decoration: textFieldDec(),
        child: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Amount",
              labelText: 'Amount',
              errorText: errorTextAmount,
              prefixIcon: const Icon(
                Icons.money,
                color: Res.accentColor,
              ),
              hintStyle: TextStyle(color: Colors.grey[400])),
        ),
      );
    }

    Widget _textFieldRemark() {
      return Container(
        padding: EdgeInsets.all(8.0),
        decoration: textFieldDec(),
        child: TextField(
          controller: _remarkController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Remark",
              labelText: 'Remark',
              errorText: errorTextRemark,
              prefixIcon: const Icon(
                Icons.text_fields,
                color: Res.accentColor,
              ),
              hintStyle: TextStyle(color: Colors.grey[400])),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        //
        // Applicationbar
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Deposit'),
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
                          Container(
                            decoration: buildBoxDecoration(),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: DropDown(
                              items: accoutList,
                              isExpanded: true,
                              showUnderline: false,
                              dropDownType: DropDownType.Button,
                              hint: Text('Accounts'),
                              onChanged: (value) {
                                print(value);
                                accountNumber =
                                    value.toString().split('(').first.trim();
                                print(accountNumber);
                                setState(() {
                                  accountNumber = accountNumber;
                                });

                              },
                            ),
                          ),
                          //====================================
                          SizedBox(height: 10),
                          _textFieldAmount(),
                          //====================================
                          SizedBox(height: 10),
                          _textFieldRemark(),
                          //====================================
                          SizedBox(height: 40),
                          CupertinoButton(
                            child: Text('Submit'),
                            color: Res.primaryColor,
                            onPressed: () async {
                              _validateDepositeFields();
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
