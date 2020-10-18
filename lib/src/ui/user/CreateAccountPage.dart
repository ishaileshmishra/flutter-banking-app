import 'dart:convert';
import 'dart:io';

import 'package:alok/src/ui/user/Components.dart';
import 'package:alok/src/utils/global_widgets.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:alok/res.dart';
import 'package:alok/src/models/AccountType.dart';
import 'package:alok/src/network/requests.dart';

class CreateNewAccountPage extends StatefulWidget {
  @override
  _CreateNewAccountPageState createState() => _CreateNewAccountPageState();
}

class _CreateNewAccountPageState extends State<CreateNewAccountPage> {
  //
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _fileName = '';
  var multipartFileDocument;
  List<AccountType> selectedAccountType = new List<AccountType>();
  var mapAccounts = Map<String, int>();
  List<String> listAccountNames = new List<String>();
  int selectedAccountTypeInteger;

  bool _validateIdNumber = false;
  bool _validateName = false;
  bool _validateLastname = false;
  bool _validateAccountHolderName = false;
  bool _validateMobile = false;
  bool _validateEmailId = false;
  bool _validateCity = false;
  bool _validatePIN = false;

  // TextEditingController
  final _idNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _pinNumberController = TextEditingController();

  /// Initialised the state of the view
  @override
  void initState() {
    super.initState();
    getAccountTypeDropDown();
  }

  /// Makes GET resuest to get all the availabe
  /// Account Types for the drop down field
  void getAccountTypeDropDown() async {
    selectedAccountType = await getAllAccountType();
    var listAccount = selectedAccountType.toList();
    print('listAccount: $listAccount');
    selectedAccountType.toList().forEach((element) {
      setState(() {
        mapAccounts[element.name] = element.id;
        listAccountNames.add(element.name);
      });
    });
  }

  /// This build makes draws the conatains the view of the Screen
  @override
  Widget build(BuildContext context) {
    Future<void> _pickFile() async {
      // Pick File from the Gallery
      FilePickerResult result = await FilePicker.platform.pickFiles();
      // Check if file available
      if (result != null) {
        File imageFile = File(result.files.single.path);
        // Make sure about the file's existance
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
                        multipartFileDocument = new http.MultipartFile(
                            'identityCardFile', stream, length,
                            filename: basename(imageFile.path));
                        _fileName = basename(imageFile.path);
                        print('filename: ${basename(imageFile.path)}');
                      })
                    })
                .catchError((onError) {
              print('error while loading file: $onError');
            });
          });
        }
      }
    }

    void _textFiledValidator() async {
      ///
      ///
      ///
      setState(() {
        _validateIdNumber = false;
        _validateName = false;
        _validateLastname = false;
        _validateAccountHolderName = false;
        _validateMobile = false;
        _validateEmailId = false;
        _validateCity = false;
        _validatePIN = false;
      });
      RegExp regex = new RegExp(pattern);
      if (_idNumberController.text.length == 0) {
        _validateIdNumber = true;
        return;
      } else if (_firstNameController.text.isEmpty) {
        _validateName = true;
        return;
      } else if (_lastNameController.text.isEmpty) {
        _validateLastname = true;
        return;
      } else if (_accountHolderNameController.text.isEmpty) {
        _validateAccountHolderName = true;
        return;
      } else if (_mobileController.text.isEmpty ||
          _mobileController.text.length < 10) {
        _validateMobile = true;
        return;
      } else if (_emailAddressController.text.isEmpty ||
          !regex.hasMatch(_emailAddressController.text)) {
        _validateEmailId = true;
        return;
      } else if (_cityNameController.text.isEmpty) {
        _validateCity = true;
        return;
      } else if (_pinNumberController.text.isEmpty ||
          _pinNumberController.text.length < 6) {
        _validatePIN = true;
        return;
      } else {
        // clear all fields
        var box = Hive.box(Res.aHiveDB);
        var userId = box.get(Res.aUserId);
        print('userId $userId');
        Map<String, String> credentials = {
          'accountTypeId': selectedAccountTypeInteger.toString().trim(),
          'typeOfIdentity': 'Adhar Card',
          'identityCardNumber': _idNumberController.text.toString().trim(),
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'accountHolderName': _accountHolderNameController.text.trim(),
          'email': _emailAddressController.text.trim(),
          'mobileNumber': _mobileController.text.trim(),
          'city': _cityNameController.text.trim(),
          'pincode': _pinNumberController.text.trim(),
          'userId': '$userId'
        };
        // POST The fields and multipartFile
        // await uploadFileWithFields(_scaffoldKey, credentials, multipartFileDocument);

        print(credentials);
        var postUri = Uri.parse(Res.createAccount);
        var request = new http.MultipartRequest("POST", postUri);
        request.fields.addAll(credentials);
        request.files.add(multipartFileDocument);
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
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create Account'),
          backgroundColor: Res.primaryColor,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.more_vert),
            )
          ],
        ),
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
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //====================================
                        //Error and Text Success Field
                        // Padding(
                        //     padding: EdgeInsets.all(8),
                        //     child: Text(
                        //       '$errorField',
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         color: CupertinoColors.systemRed,
                        //       ),
                        //     )),

                        //====================================
                        //Dropdown Field
                        SizedBox(height: 20),
                        Container(
                          decoration: buildBoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropDown(
                            items: listAccountNames,
                            isExpanded: true,
                            showUnderline: false,
                            dropDownType: DropDownType.Button,
                            hint: Text('Account Type'),
                            onChanged: (value) {
                              print(value);
                              selectedAccountTypeInteger = mapAccounts[value];
                              print(selectedAccountTypeInteger);
                            },
                          ),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        Container(
                          decoration: buildBoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropDown(
                            items: ['Adhar Card'],
                            isExpanded: true,
                            showUnderline: false,
                            dropDownType: DropDownType.Button,
                            hint: Text('Adhar Card'),
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        Row(
                          children: [
                            new OutlineButton(
                                child: new Text("Choose identity card"),
                                splashColor: Res.accentColor,
                                onPressed: () => _pickFile(),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0))),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                '$_fileName',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),

                        //====================================
                        SizedBox(height: 10),

                        TextField(
                          controller: _idNumberController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText: _validateIdNumber
                                ? 'Provide Identity Number'
                                : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "ID card number",
                            prefixIcon: Icon(CupertinoIcons.number_circle),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),

                        TextField(
                          controller: _firstNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validateName
                                ? "First name Can\'t Be Empty"
                                : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "First name",
                            prefixIcon:
                                const Icon(CupertinoIcons.number_circle),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),

                        TextField(
                          controller: _lastNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validateLastname
                                ? "Last name Can\'t Be Empty"
                                : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Last name",
                            prefixIcon:
                                const Icon(CupertinoIcons.number_circle),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _accountHolderNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validateAccountHolderName
                                ? "Account holder name Can\'t Be Empty"
                                : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Account holder name",
                            prefixIcon:
                                const Icon(CupertinoIcons.number_circle),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText:
                                _validateMobile ? "Invalid Mobile" : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Mobile number",
                            prefixIcon:
                                const Icon(CupertinoIcons.number_circle),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),

                        TextField(
                          controller: _emailAddressController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText:
                                _validateEmailId ? "Invalid EmailId" : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Email Id",
                            prefixIcon:
                                const Icon(CupertinoIcons.number_circle),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _cityNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validateCity
                                ? "City name Can\'t Be Empty"
                                : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "City name",
                            prefixIcon:
                                const Icon(CupertinoIcons.number_circle),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _pinNumberController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            errorText: _validatePIN ? "Invalid PIN" : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "PIN",
                            prefixIcon:
                                const Icon(CupertinoIcons.number_circle),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: CupertinoButton(
                            child: Text('Submit'),
                            color: Res.primaryColor,
                            onPressed: () {
                              _textFiledValidator();
                            },
                          ),
                        ),
                        //====================================
                      ],
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

  OutlineInputBorder buildEnabledOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: CupertinoColors.inactiveGray,
        width: 1.0,
      ),
    );
  }

  OutlineInputBorder buildFocusedOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: CupertinoColors.inactiveGray,
        width: 1.0,
      ),
    );
  }
}
