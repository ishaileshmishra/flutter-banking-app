import 'dart:io';

import 'package:alok/src/ui/user/Components.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
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
  var errorField = '';
  int selectedAccountTypeInteger;

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
    setState(() {
      errorField = '';
    });
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
    //
    // TextInputField Decoration

    // Browes file from the gallery
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
      //validate the blank field
      RegExp regex = new RegExp(pattern);
      setState(() {
        errorField = '';
      });
      if (selectedAccountTypeInteger == null) {
        setState(() {
          errorField = 'Select Account Type';
        });
        return;
      } else if (_idNumberController.text.isEmpty) {
        setState(() {
          errorField = 'Provide card number';
        });
        return;
      } else if (_firstNameController.text.isEmpty) {
        setState(() {
          errorField = 'Please provide first name';
        });
        return;
      } else if (_lastNameController.text.isEmpty) {
        setState(() {
          errorField = 'Please provide last name';
        });
        return;
      } else if (_accountHolderNameController.text.isEmpty) {
        setState(() {
          errorField = 'Please provide Account holder name';
        });
        return;
      } else if (_mobileController.text.isEmpty ||
          _mobileController.text.length < 10) {
        setState(() {
          errorField = 'Please provide valid mobile number';
        });
        return;
      } else if (_emailAddressController.text.isEmpty ||
          !regex.hasMatch(_emailAddressController.text)) {
        setState(() {
          errorField = 'Provide valid email address';
        });
        return;
      } else if (_cityNameController.text.isEmpty) {
        setState(() {
          errorField = 'Please provide city name';
        });
        return;
      } else if (_pinNumberController.text.isEmpty ||
          _pinNumberController.text.length < 6) {
        setState(() {
          errorField = 'Please provide valid PIN';
        });
        return;
      }

      // clear all fields
      errorField = '';
      Map<String, String> data = {
        'accountTypeId': selectedAccountTypeInteger.toString(),
        'identityCardNumber': _fileName,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'accountHolderName': _accountHolderNameController.text,
        'email': _emailAddressController.text,
        'mobileNumber': _mobileController.text,
        'city': _cityNameController.text,
        'pincode': _pinNumberController.text
      };

      // POST The fields and multipartFile
      await uploadFileWithFields(_scaffoldKey, data, multipartFileDocument);
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //====================================
                        //Error and Text Success Field
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '$errorField',
                            style: TextStyle(
                                fontSize: 18, color: CupertinoColors.systemRed),
                          ),
                        ),

                        //====================================
                        //Dropdown Field
                        SizedBox(height: 10),
                        Container(
                          decoration: buildBoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropDown(
                            items: listAccountNames,
                            isExpanded: true,
                            showUnderline: true,
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
                            showUnderline: true,
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
                        CupertinoTextField(
                          controller: _idNumberController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          padding: EdgeInsets.all(10),
                          prefix: buildPadding(),
                          placeholder: "ID card number",
                          keyboardType: TextInputType.name,
                          decoration: buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _firstNameController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          padding: EdgeInsets.all(10),
                          prefix: buildPadding(),
                          placeholder: "First name",
                          keyboardType: TextInputType.name,
                          decoration: buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _lastNameController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          padding: EdgeInsets.all(10),
                          prefix: buildPadding(),
                          placeholder: "Last name",
                          keyboardType: TextInputType.name,
                          decoration: buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _accountHolderNameController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          padding: EdgeInsets.all(10),
                          prefix: buildPadding(),
                          placeholder: "Account holder name",
                          keyboardType: TextInputType.name,
                          decoration: buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _mobileController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          padding: EdgeInsets.all(10),
                          prefix: buildPadding(),
                          placeholder: "Mobile number",
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _emailAddressController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          padding: EdgeInsets.all(10),
                          prefix: buildPadding(),
                          placeholder: "Email Id",
                          keyboardType: TextInputType.emailAddress,
                          decoration: buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _cityNameController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          padding: EdgeInsets.all(10),
                          prefix: buildPadding(),
                          placeholder: "City",
                          keyboardType: TextInputType.name,
                          decoration: buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _pinNumberController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          padding: EdgeInsets.all(10),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          cursorColor: Res.accentColor,
                          maxLengthEnforced: true,
                          prefix: buildPadding(),
                          placeholder: "PIN code",
                          decoration: buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: CupertinoButton(
                            child: Text('Submit'),
                            color: Res.primaryColor,
                            onPressed: () {
                              // Write your callback here
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
}
