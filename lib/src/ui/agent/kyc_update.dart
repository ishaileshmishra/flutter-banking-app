import 'dart:convert';

import 'package:alok/src/ui/agent/compontents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/ui/user/Components.dart';
import 'package:alok/src/utils/global_widgets.dart';

class KYCUpdatePage extends StatefulWidget {
  KYCUpdatePage(
      {Key key,
      this.accountNumber,
      this.accountMode,
      this.adharCardNumber,
      this.amount})
      : super(key: key);

  final String accountNumber;
  final String accountMode;
  final String adharCardNumber;
  final String amount;

  @override
  _KYCUpdatePageState createState() => _KYCUpdatePageState();
}

class _KYCUpdatePageState extends State<KYCUpdatePage> {
  var _amountController = TextEditingController();
  var _remarkController = TextEditingController();

  bool _validateAmount = false;
  bool _validateRemark = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount;
  }

  void _validateTextFields() {
    setState(() {
      _validateAmount = false;
      _validateRemark = false;
    });
    if (_amountController.text.trim().isEmpty) {
      _validateAmount = true;
      return;
    } else if (_remarkController.text.trim().isEmpty) {
      _validateRemark = true;
      return;
    }
    loadAccounts();
  }

  loadAccounts() async {
    var box = Hive.box(Res.aHiveDB);
    var agentID = box.get(Res.aUserId);

    var credentials = {
      'agentId': agentID,
      'accountNumber': widget.accountNumber,
      'frontPhoto': 'file',
      'backPhoto': 'file',
      'Amount': _amountController.text.trim(),
      'Remark': _remarkController.text.trim(),
    };
    final response = await http.post(Res.updateKycAPI, body: credentials);
    if (response.statusCode == 200) {
      Map userMap = json.decode(response.body);
      if (userMap['success']) {
        showToast(context, userMap['message']);
      }
      showToastWithError(context, userMap['message']);
    } else {
      showToastWithError(context, 'Failed to create KYC');
    }
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
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              'Account Number: ${widget.accountNumber}',
              style: buildTextStyle(),
            ),

            SizedBox(height: 10),
            Text(
              '${widget.accountMode}',
              style: buildTextStyle(),
            ),

            SizedBox(height: 10),
            Text(
              '${widget.adharCardNumber}',
              style: buildTextStyle(),
            ),
            //=================================
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: _amountController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                focusedBorder: buildFocusedOutlineInputBorder(),
                enabledBorder: buildEnabledOutlineInputBorder(),
                labelText: "Amount",
                errorText: _validateAmount ? "Amount Cant be empty" : null,
                prefixIcon: const Icon(CupertinoIcons.money_dollar),
                hintStyle: TextStyle(color: Colors.grey[400]),
              ), //buildInputDecoration('ID card number'),
            ),
            //=================================
            SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              controller: _remarkController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                focusedBorder: buildFocusedOutlineInputBorder(),
                enabledBorder: buildEnabledOutlineInputBorder(),
                labelText: "Remark...",
                errorText: _validateRemark ? "Put some remark" : null,
                prefixIcon: const Icon(Icons.text_format),
                hintStyle: TextStyle(color: Colors.grey[400]),
              ), //buildInputDecoration('ID card number'),
            ),
            SizedBox(height: 45),
            Container(
              width: double.infinity,
              child: CupertinoButton(
                child: Text('SUBMIT'),
                color: Res.primaryColor,
                onPressed: () {
                  _validateTextFields();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
