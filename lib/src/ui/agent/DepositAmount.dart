import 'dart:convert';

import 'package:alok/res.dart';
import 'package:alok/src/models/DepositAmountRequestList.dart';
import 'package:alok/src/utils/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class DepositeAmount extends StatefulWidget {
  @override
  _DepositeAmountState createState() => _DepositeAmountState();
}

class _DepositeAmountState extends State<DepositeAmount> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DepositAmountRequestList> depositeList =
      new List<DepositAmountRequestList>();
  String transactionId;
  List accountsJsonList;
  final _amountController = TextEditingController();
  final _remarkController = TextEditingController();
  bool _validateFieldAmount = false;
  bool _validateFieldRemark = false;

  loadAccountList() async {
    await http.get(Res.depositAmountListAPI).then((response) {
      if (response.statusCode == 200) {
        Map userMap = json.decode(response.body);
        if (userMap['success']) {
          //showToast(context, userMap['message']);
          accountsJsonList = jsonDecode(response.body)['data'] as List;
          depositeList = accountsJsonList
              .map((tagJson) => DepositAmountRequestList.fromJson(tagJson))
              .toList();
          setState(() {
            depositeList = depositeList;
            print(depositeList.toString());
          });
        } else {
          showToastWithError(context, userMap['message']);
        }
      }
    }).catchError((error) {
      showToastWithError(context, error.toString());
    });
  }

  showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    loadAccountList();
  }

  void textFieldValidator() {
    setState(() {
      _validateFieldAmount = false;
      _validateFieldRemark = false;
    });
    if (transactionId == null || transactionId.isEmpty) {
      showSnackBar('Pls select transaction id');
    } else if (_amountController.text.trim().isEmpty ||
        _amountController.text.trim().length < 2) {
      setState(() {
        _validateFieldAmount = true;
        showSnackBar('Provide valid amount');
      });
      return;
    } else if (_remarkController.text.trim().isEmpty) {
      setState(() {
        _validateFieldRemark = true;
        showSnackBar('provide remark');
        return;
      });
    } else {
      var box = Hive.box(Res.aHiveDB);
      var userId = box.get(Res.aUserId);
      var dataToPost = {
        'agentId': userId.toString(),
        'transactionId': transactionId, //_amountController.text.trim(),
        'amount': _amountController.text.trim().toString(),
        'remark': _remarkController.text.trim().toString(),
      };

      print('post data: $dataToPost');
      http
          .post(
        Res.depositAmountAPI,
        body: dataToPost,
      )
          .then((response) {
        Map userMap = json.decode(response.body);
        print(userMap);
        if (response.statusCode == 200) {
          if (userMap['success']) {
            showToast(context, userMap['message']);
            new Future.delayed(const Duration(seconds: 2));
            Navigator.pop(context);
          } else {
            showToastWithError(context, userMap['message']);
          }
        }
      }).catchError((error) {
        showToastWithError(context, 'Failed: ${error.toString()}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Res.accentColor,
            elevation: 0,
            centerTitle: true,
            title: Text('Deposit'),
            actions: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.more_vert),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      color: Res.accentColor,
                      height: 200,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          //================================
                          //Dropdown Field
                          SizedBox(height: 10),
                          DropDown(
                            items: depositeList, //listAccountNames,
                            isExpanded: true,
                            showUnderline: true,
                            dropDownType: DropDownType.Button,
                            hint: Text('Transaction Id'),
                            onChanged: (value) {
                              transactionId =
                                  value.toString().split('(').first.trim();
                              var amount = findSelectedAmount(transactionId);
                              setState(() {
                                _amountController.text = amount.toString();
                              });
                            },
                          ),
                          //====================================
                          SizedBox(height: 10),
                          TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                //border: OutlineInputBorder(),
                                hintText: 'amount',
                                //helperText: 'Pls provide transaction id.',
                                labelText: 'amount',
                                alignLabelWithHint: true,
                                errorText: _validateFieldAmount
                                    ? 'Provide valid amount'
                                    : null,
                                prefixIcon: const Icon(
                                  Icons.attach_money,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                suffixStyle: const TextStyle(
                                    color: CupertinoColors.inactiveGray)),
                          ),

                          //====================================
                          SizedBox(height: 10),
                          TextField(
                            controller: _remarkController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                //border: OutlineInputBorder(),
                                hintText: 'Remark',
                                //helperText: 'Pls provide remark.',
                                labelText: 'Remark',
                                errorText: _validateFieldRemark
                                    ? 'Provide valid amount'
                                    : null,
                                prefixIcon: const Icon(
                                  Icons.text_format,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                suffixStyle: const TextStyle(
                                    color: CupertinoColors.inactiveGray)),
                          ),
                          //====================================
                          SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            child: CupertinoButton(
                              child: Text('Submit'),
                              color: Res.primaryColor,
                              onPressed: () async {
                                // Write your callback here
                                textFieldValidator();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  findSelectedAmount(String transactionId) {
    var idx = accountsJsonList.indexWhere(
        (element) => element['transactionId'].toString() == transactionId);
    var selected = accountsJsonList.elementAt(idx);
    print('Index: ${selected['amount']}');
    return selected['amount'];
  }
}
