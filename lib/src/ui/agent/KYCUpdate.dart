import 'dart:convert';

import 'package:alok/src/models/KYCModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:alok/res.dart';
import 'package:alok/src/ui/user/Components.dart';

class KYCUpdatePage extends StatefulWidget {
  @override
  _KYCUpdatePageState createState() => _KYCUpdatePageState();
}

class _KYCUpdatePageState extends State<KYCUpdatePage> {
  List listOfAccounts = new List();
  KYCModel kycModel = new KYCModel();

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  loadAccounts() async {
    var box = Hive.box(Res.aHiveDB);
    var agentID = box.get(Res.aUserId);
    final kycAPI = Res.kycRequestAPI + '' + agentID;
    print(kycAPI);
    final response = await http.get(kycAPI);
    if (response.statusCode == 200) {
      Map userMap = json.decode(response.body);
      if (userMap['success']) {
        setState(() {
          listOfAccounts = userMap["data"] as List;
        });

        listOfAccounts
            .map<KYCModel>((json) => KYCModel.fromJson(json))
            .toList();
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
        title: Text('KYC Update'),
      ),
      body: ListView(
        children: [
          //==================================
          Container(
            decoration: buildBoxDecoration(),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropDown(
              items: ["A", "B", "C"],
              isExpanded: true,
              showUnderline: false,
              dropDownType: DropDownType.Button,
              hint: Text('Account number'),
              onChanged: (accountNo) {
                setState(() {
                  kycModel = listOfAccounts.firstWhere(
                      (element) => element['accountNumber'] == accountNo);
                });
              },
            ),
          ),
          //==================================

          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            child: Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AccountNumber: ' + kycModel.accountNumber.toString()),
                Text('Name: ' + kycModel.accountHolderName),
                Text('Account Mode: ' + kycModel.accountMode),
                Text('Amount: ' + kycModel.amount.toString()),
                Text('Phone Number: ' + kycModel.accountHolderPhoneNumber),
                Text('Identity Card Number: ' + kycModel.identityCardNumber),
                Text('Address: ' + kycModel.address),
                Text('City: ' + kycModel.city),
                Text('Pin: ' + kycModel.pincode),
              ],
            )),
          )
        ],
      ),
    );
  }
}
