import 'dart:convert';

import 'package:alok/src/ui/agent/compontents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/KYCModel.dart';
import 'package:alok/src/ui/agent/kyc_update.dart';
import 'package:alok/src/ui/user/Components.dart';

class KYCRequestPage extends StatefulWidget {
  @override
  _KYCRequestPageState createState() => _KYCRequestPageState();
}

class _KYCRequestPageState extends State<KYCRequestPage> {
  List<KYCModel> kycObjList = new List<KYCModel>();
  List listAccounts = new List();
  var renderDetail = [];

  /// TextFields
  var accountNumber;
  var accountMode;
  var idCardNo;
  var amount;
  bool isDropDownSelected = false;

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
      print(userMap);
      if (userMap['success']) {
        var elements = userMap["data"] as List;
        kycObjList =
            elements.map((tagJson) => KYCModel.fromJson(tagJson)).toList();
        setState(() {
          elements.forEach((element) {
            listAccounts.add(element['accountNumber']);
          });
          print('listAccounts: $listAccounts');
        });
      }
    }
  }

  setKYVDetail(element) {
    accountNumber = element.accountNumber;
    accountMode = 'Account Mode: ' + element.accountMode;
    var name = 'Name: ' + element.accountHolderName;
    amount = element.amount.toString();
    var phoneNo = 'Phone Number: ' + element.accountHolderPhoneNumber;
    idCardNo = 'Identity Card Number: ' + element.identityCardNumber;
    var address = 'Address: ' + element.address;
    var city = 'City: ' + element.city;
    var pin = 'Pincode: ' + element.pincode;
    renderDetail = [
      'AccountNumber: $accountNumber',
      accountMode,
      name,
      'Amount: $amount',
      idCardNo,
      address,
      phoneNo,
      city,
      pin
    ].toList();
    return renderDetail;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildAppBar('KYC Request'),
        body: Stack(
          children: [
            /// primary color background
            buildColoredContainer(),

            /// Place for widget
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 50,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Widget DropDown
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
                              renderDetail = setKYVDetail(element);
                              isDropDownSelected = true;
                              print(renderDetail);
                            });
                          }
                        });
                      },
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: renderDetail.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 40,
                            color: Colors.grey.shade200,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              '${renderDetail[index]}',
                              style: buildTextStyle(),
                            ),
                          );
                        }),
                  ),

                  Visibility(
                    visible: isDropDownSelected ? true : false,
                    child: Container(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
