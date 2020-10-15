import 'dart:io';

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
  String _fileName = '';
  var multipartFileDocument;
  List<AccountType> selectedAccountType = new List<AccountType>();
  var errorField = '';

  // TextEditingController
  String _errorIDCard;
  String _errorIDCardNumber;
  String _errorFirstName;
  String _errorLastName;
  String _errorAccountHolderName;
  String _errorMobileNumber;
  String _errorEmailAddress;
  String _errorCity;
  String _errorPIN;

  // TextEditingController
  final _identityCardController = TextEditingController();
  final _identityCardNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinController = TextEditingController();

  /// Initialised the state of the view
  @override
  void initState() {
    super.initState();
    // Make a get request for the dropdown
    getAccountTypeDropDown();
    setState(() {
      errorField = '';
    });
  }

  /// Makes GET resuest to get all the availabe Account Types for the drop down field
  void getAccountTypeDropDown() async {
    selectedAccountType = await getAllAccountType();
    print(selectedAccountType);
  }

  /// This build makes draws the conatains the view of the Screen
  @override
  Widget build(BuildContext context) {
    //
    // TextInputField Decoration
    BoxDecoration _buildBoxDecoration() {
      return BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: CupertinoColors.inactiveGray,
        ),
        borderRadius: BorderRadius.circular(8.0),
      );
    }

    // _build padding for the textFields
    Padding _buildPadding() {
      return Padding(
        padding: EdgeInsets.all(6.0),
        //child: Icon(Icons.perm_identity_rounded, color: Res.primaryColor),
      );
    }

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
                        _identityCardController.text = _fileName;
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
      setState(() {
        errorField = '';
      });
      if (_identityCardController.text.isEmpty) {
        setState(() {
          errorField = 'Please Provide Identity Card Filename';
          print(_errorIDCard);
        });
        return;
      } else if (_identityCardNumberController.text.isEmpty) {
        setState(() {
          errorField = 'Provide ID card number';
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
      } else if (_mobileNoController.text.isEmpty) {
        setState(() {
          errorField = 'Please provide mobile number';
        });
        return;
      } else if (_emailAddressController.text.isEmpty) {
        setState(() {
          errorField = 'Please provide email address';
        });
        return;
      } else if (_cityController.text.isEmpty) {
        setState(() {
          errorField = 'Please provide city name';
        });
        return;
      } else if (_pinController.text.isEmpty) {
        setState(() {
          errorField = 'Please provide PIN';
        });
        return;
      }

      errorField = '';

      Map<String, String> data = {
        'accountTypeId': selectedAccountType.elementAt(0).id.toString(),
        'identityCardNumber': _identityCardController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'accountHolderName': _accountHolderNameController.text,
        'email': _emailAddressController.text,
        'mobileNumber': _mobileNoController.text,
        'city': _cityController.text,
        'pincode': _pinController.text
      };

      // POST The fields and multipartFile
      await uploadFileWithFields(data, multipartFileDocument);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
                        //Error and Text Success Field
                        Text(
                          '$errorField',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.systemRed),
                        ),
                        DropDown(
                          items: selectedAccountType,
                          isExpanded: true,
                          showUnderline: true,
                          dropDownType: DropDownType.Button,
                          hint: Text('Account Type'),
                          onChanged: (value) {
                            print(value);
                          },
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _identityCardController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: _buildPadding(),
                          padding: EdgeInsets.all(10),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              _fileName = value;
                            });
                          },
                          placeholder: "Identity card",
                          decoration: _buildBoxDecoration(),
                        ),
                        //====================================
                        SizedBox(height: 10),
                        Row(
                          children: [
                            FlatButton(
                                height: 30,
                                splashColor: Res.primaryColor,
                                child: Text(
                                  'Choose identity card',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                color: Res.accentColor,
                                onPressed: () => _pickFile()),
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
                        buildCupertinoTextField(
                            'ID card number', _identityCardNumberController),
                        //====================================
                        SizedBox(height: 10),
                        buildCupertinoTextField(
                            'First name', _firstNameController),
                        //====================================
                        SizedBox(height: 10),
                        buildCupertinoTextField(
                            'Last name', _lastNameController),
                        //====================================
                        SizedBox(height: 10),
                        buildCupertinoTextField('Account holder name',
                            _accountHolderNameController),
                        //====================================
                        SizedBox(height: 10),
                        buildCupertinoTextField(
                            'Mobile number', _mobileNoController),
                        //====================================
                        SizedBox(height: 10),
                        buildCupertinoTextField(
                            'Email address', _emailAddressController),
                        //====================================
                        SizedBox(height: 10),
                        buildCupertinoTextField('City name', _cityController),
                        //====================================
                        SizedBox(height: 10),
                        buildCupertinoTextField('PIN code', _pinController),
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

  CupertinoTextField buildCupertinoTextField(
      String _stringField, TextEditingController controller) {
    return CupertinoTextField(
      controller: controller,
      clearButtonMode: OverlayVisibilityMode.editing,
      padding: EdgeInsets.all(10),
      prefix: Padding(padding: EdgeInsets.all(6.0)),
      placeholder: _stringField,
      keyboardType: TextInputType.number,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: CupertinoColors.inactiveGray,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
