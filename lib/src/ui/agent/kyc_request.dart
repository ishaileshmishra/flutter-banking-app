import 'dart:convert';

import 'package:alok/src/models/KYCModel.dart';
import 'package:alok/src/ui/agent/compontents.dart';
import 'package:alok/src/ui/agent/kyc_update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:alok/res.dart';
import 'package:alok/src/ui/user/Components.dart';

class KYCRequestPage extends StatefulWidget {
  @override
  _KYCRequestPageState createState() => _KYCRequestPageState();
}

class _KYCRequestPageState extends State<KYCRequestPage> {
  List<KYCModel> kycObjList = new List<KYCModel>();
  List listAccounts = new List();

  /// TextFields
  var accountNumber;
  var accountMode;
  var name;
  var amount;
  var phoneNo;
  var idCardNo;
  var address;
  var city;
  var pin;

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  loadAccounts() async {
    var box = Hive.box(Res.aHiveDB);
    var agentID = box.get(Res.aUserId);
    final kycAPI = Res.requestKycAPI + '' + agentID.toString();
    final response = await http.get(kycAPI);
    if (response.statusCode == 200) {
      Map userMap = json.decode(response.body);
      if (userMap['success']) {
        var elements = userMap["data"] as List;
        kycObjList =
            elements.map((tagJson) => KYCModel.fromJson(tagJson)).toList();
        setState(() {
          elements.forEach((element) {
            listAccounts.add(element['accountNumber']);
          });
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Res.accentColor,
        centerTitle: true,
        title: Text('KYC Request'),
      ),
      body: ListView(
        children: [
          //==================================
          Container(
            decoration: buildBoxDecoration(),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropDown(
              items: listAccounts,
              isExpanded: true,
              showUnderline: false,
              dropDownType: DropDownType.Button,
              hint: Text('Account number'),
              onChanged: (accountNo) {
                kycObjList.forEach((element) {
                  if (element.accountNumber == accountNo) {
                    setState(() {
                      accountNumber = element.accountNumber;
                      accountMode = 'Account Mode: ' + element.accountMode;
                      name = 'Name: ' + element.accountHolderName;
                      amount = element.amount.toString();
                      phoneNo =
                          'Phone Number: ' + element.accountHolderPhoneNumber;
                      idCardNo =
                          'Identity Card Number: ' + element.identityCardNumber;
                      address = 'Address: ' + element.address;
                      city = 'City: ' + element.city;
                      pin = 'Pincode: ' + element.pincode;
                    });
                  }
                });

                // kycObjList = kycObjList.where(
                //     (element) => element.accountNumber.toString() == accountNo);
                // print('kycModel: $kycObjList');
              },
            ),
          ),
          //==================================

          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  accountNumber != null
                      ? Text(
                          'Account Number: $accountNumber',
                          style: buildTextStyle(),
                        )
                      : Container(),
                  accountMode != null
                      ? Text(
                          '$accountMode',
                          style: buildTextStyle(),
                        )
                      : Container(),
                  name != null
                      ? Text(
                          '$name',
                          style: buildTextStyle(),
                        )
                      : Container(),
                  amount != null
                      ? Text(
                          'Amount: $amount',
                          style: buildTextStyle(),
                        )
                      : Container(),
                  phoneNo != null
                      ? Text(
                          '$phoneNo',
                          style: buildTextStyle(),
                        )
                      : Container(),
                  idCardNo != null
                      ? Text(
                          '$idCardNo',
                          style: buildTextStyle(),
                        )
                      : Container(),
                  address != null
                      ? Text(
                          '$address',
                          style: buildTextStyle(),
                        )
                      : Container(),
                  city != null
                      ? Text(
                          '$city',
                          style: buildTextStyle(),
                        )
                      : Container(),
                  pin != null
                      ? Text(
                          '$pin',
                          style: buildTextStyle(),
                        )
                      : Container(),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.all(20),
            child: CupertinoButton(
              child: Text('Process'),
              color: Res.primaryColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KYCUpdatePage(
                              accountNumber: accountNumber.toString(),
                              accountMode: accountMode,
                              adharCardNumber: idCardNo,
                              amount: amount,
                            )));
              },
            ),
          ),
        ],
      ),
    );
  }
}
