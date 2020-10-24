import 'dart:convert';
import 'dart:io';

import 'package:alok/src/utils/global_widgets.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:alok/res.dart';
import 'package:alok/src/ui/agent/compontents.dart';
import 'package:alok/src/ui/user/Components.dart';

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
  var multipartFileFrontDocument;
  var multipartFileBackDocument;
  String fileNameFront = '';
  String fileNameBack = '';
  bool _validateAmount = false;
  bool _validateRemark = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount;
  }

  _validateTextFields(context) {
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
    } else if (multipartFileFrontDocument == null) {
      showToastWithError(context, 'Please select Adhar card front photo');
      return;
    }
    loadAccounts(context);
  }

  loadAccounts(context) async {
    var box = Hive.box(Res.aHiveDB);
    var agentID = box.get(Res.aUserId);
    var credentials = {
      'agentId': agentID,
      'accountNumber': widget.accountNumber,
      'frontPhoto': multipartFileFrontDocument,
      'backPhoto': 'file',
      'Amount': _amountController.text.trim(),
      'Remark': _remarkController.text.trim(),
    };

    // final response = await http.post(Res.updateKycAPI, body: credentials);
    // if (response.statusCode == 200) {
    //   Map userMap = json.decode(response.body);
    //   if (userMap['success']) {
    //     showToast(context, userMap['message']);
    //   }
    //   showToastWithError(context, userMap['message']);
    // } else {
    //   showToastWithError(context, 'Failed to create KYC');
    // }

    var postUri = Uri.parse(Res.updateKycAPI);
    var request = new http.MultipartRequest("POST", postUri);
    request.fields.addAll(credentials);
    request.files.add(multipartFileFrontDocument);
    request.send().then((response) {
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          Map userMap = json.decode(value);
          if (userMap['success']) {
            showToast(context, userMap['message']);
            new Future.delayed(const Duration(seconds: 2));
            Navigator.pop(context);
          } else {
            showToastWithError(context, userMap['message']);
          }
        });
      }
    }).catchError((error) {
      showToastWithError(context, 'FAILED ${error.toString()}');
    });
  }

  Future<void> _pickFrontFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File imageFile = File(result.files.single.path);
      if (imageFile.existsSync()) {
        var stream =
            // ignore: deprecated_member_use
            http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();
        setState(() {
          imageFile
              .exists()
              .then((_) => {
                    setState(() {
                      multipartFileFrontDocument = new http.MultipartFile(
                          'frontPhoto', stream, length,
                          filename: basename(imageFile.path));
                      fileNameFront = basename(imageFile.path);
                    })
                  })
              .catchError((onError) {
            print('Error while loading file: $onError');
          });
        });
      }
    }
  }

  Future<void> _pickBackFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File imageFile = File(result.files.single.path);
      if (imageFile.existsSync()) {
        var stream =
            // ignore: deprecated_member_use
            http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();
        setState(() {
          imageFile
              .exists()
              .then((_) => {
                    setState(() {
                      multipartFileBackDocument = new http.MultipartFile(
                          'backPhoto', stream, length,
                          filename: basename(imageFile.path));
                      fileNameBack = basename(imageFile.path);
                    })
                  })
              .catchError((onError) {
            print('Error while loading file: $onError');
          });
        });
      }
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
        title: Text('KYC Update'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Text(
              'Account Number: ${widget.accountNumber}',
              style: buildTextStyle(),
            ),

            SizedBox(height: 20),
            Text(
              '${widget.accountMode}',
              style: buildTextStyle(),
            ),

            SizedBox(height: 20),
            Text(
              '${widget.adharCardNumber}',
              style: buildTextStyle(),
            ),
            //=================================
            SizedBox(height: 20),
            RaisedButton.icon(
              onPressed: () {
                print('Button Clicked.');
                _pickFrontFile();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              label: Text(
                'Adhar card front photo',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.backup,
                color: Colors.white,
              ),
              textColor: Colors.white,
              splashColor: Colors.red,
              color: Colors.lightBlue,
            ),

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
                  _validateTextFields(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
