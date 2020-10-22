import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/AccountType.dart';
import 'package:alok/src/network/requests.dart';
import 'package:alok/src/ui/user/Components.dart';
import 'package:alok/src/ui/user/beneficiary_detail_page.dart';
import 'package:alok/src/utils/global_widgets.dart';

class CreateNewAccountPage extends StatefulWidget {
  @override
  _CreateNewAccountPageState createState() => _CreateNewAccountPageState();
}

class _CreateNewAccountPageState extends State<CreateNewAccountPage> {
  //
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var multipartFileDocument;
  List<AccountType> selectedAccountType = new List<AccountType>();
  var mapAccounts = Map<String, int>();
  List<String> listAccountNames = new List<String>();
  int selectedAccountTypeInteger;

  bool _validateIdAmount = false;
  bool _validateDateOfBirth = false;
  bool _validateAddress = false;
  bool _validateAccountHolderName = false;
  bool _validateAccountHolderAdharCardNumber = false;
  bool _validateMobile = false;
  bool _validateEmailId = false;
  bool _validateCity = false;
  bool _validatePIN = false;

  // TextEditingController
  final _idNumberController = TextEditingController();
  final _dobController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _accountHolderAdharCardNumberController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _addressController = TextEditingController();
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
    void _textFiledValidator() async {
      ///
      ///
      ///
      setState(() {
        _validateIdAmount = false;
        _validateAddress = false;
        _validateAccountHolderName = false;
        _validateAccountHolderAdharCardNumber = false;
        _validateMobile = false;
        _validateAddress = false;
        _validateEmailId = false;
        _validateCity = false;
        _validatePIN = false;
      });
      RegExp regex = new RegExp(pattern);
      if (_idNumberController.text.length == 0) {
        _validateIdAmount = true;
        return;
      } else if (_accountHolderNameController.text.isEmpty) {
        _validateAccountHolderName = true;
        return;
      } else if (_accountHolderAdharCardNumberController.text.isEmpty) {
        _validateAccountHolderAdharCardNumber = true;
        return;
      } else if (_mobileController.text.isEmpty ||
          _mobileController.text.length < 10) {
        _validateMobile = true;
        return;
      } else if (_emailAddressController.text.isNotEmpty &&
          !regex.hasMatch(_emailAddressController.text)) {
        _validateEmailId = true;
        return;
      } else if (_addressController.text.isEmpty) {
        _validateAddress = true;
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
          'accountMode': '',
          'amount': '',
          'accountFor': '',
          'dateOfBirth': '',
          'address': '',
          'identityCardNumber': _idNumberController.text.toString().trim(),
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
                  // Colored container
                  Container(
                    color: Res.primaryColor,
                    height: 200,
                  ),
                  //Curved Field container
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //====================================
                        //Dropdown Field Account type
                        SizedBox(height: 20),
                        Container(
                          decoration: buildBoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropDown(
                            items: listAccountNames,
                            isExpanded: true,
                            showUnderline: false,
                            dropDownType: DropDownType.Button,
                            hint: Text('Account type'),
                            onChanged: (value) {
                              print(value);
                              selectedAccountTypeInteger = mapAccounts[value];
                              print(selectedAccountTypeInteger);
                            },
                          ),
                        ),

                        //====================================
                        //Dropdown Field Account Mode
                        SizedBox(height: 10),
                        Container(
                          decoration: buildBoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropDown(
                            items: ['Gullak', 'Daily', 'Monthly'],
                            isExpanded: true,
                            showUnderline: false,
                            dropDownType: DropDownType.Button,
                            hint: Text('Account mode'),
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _idNumberController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText:
                                _validateIdAmount ? 'Provide Amount' : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Amount",
                            prefixIcon: Icon(CupertinoIcons.number_circle),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        // Dropdown
                        SizedBox(height: 10),
                        Container(
                          decoration: buildBoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropDown(
                            items: [
                              'self',
                              'son',
                              'daughter',
                              'brother',
                              'sister',
                              'wife',
                              'father',
                              'mother'
                            ],
                            isExpanded: true,
                            showUnderline: false,
                            dropDownType: DropDownType.Button,
                            hint: Text('Account for'),
                            onChanged: (value) {
                              print(value);
                            },
                          ),
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
                            prefixIcon: const Icon(CupertinoIcons.person_2_alt),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        // Textfield Date of birth
                        SizedBox(height: 10),
                        TextField(
                          controller: _dobController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.datetime,
                          onTap: () => print('open a calender dialog'),

                          decoration: InputDecoration(
                            errorText:
                                _validateDateOfBirth ? 'Date of birth' : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Date of birth",
                            prefixIcon: Icon(CupertinoIcons.calendar_today),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _accountHolderAdharCardNumberController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validateAccountHolderAdharCardNumber
                                ? "Account holder name Can\'t Be Empty"
                                : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Account holder adhar card number",
                            prefixIcon: const Icon(CupertinoIcons
                                .person_crop_circle_badge_checkmark),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          decoration: InputDecoration(
                            errorText:
                                _validateMobile ? "Invalid Mobile" : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Mobile number",
                            prefixIcon: const Icon(CupertinoIcons.phone),
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
                            prefixIcon: const Icon(CupertinoIcons.mail),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _addressController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText:
                                _validateAddress ? "Invalid Address" : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Address",
                            prefixIcon: const Icon(Icons.add_to_drive),
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
                            prefixIcon: const Icon(Icons.location_city),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _pinNumberController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          maxLength: 6,
                          decoration: InputDecoration(
                            errorText: _validatePIN ? "Invalid PIN" : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Pincode",
                            prefixIcon: const Icon(Icons.confirmation_number),
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
                              //_textFiledValidator();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BeneficiaryDetailsPage()));
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
