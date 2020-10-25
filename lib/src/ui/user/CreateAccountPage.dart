import 'dart:convert';

import 'package:alok/src/ui/user/beneficiary_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/AccountType.dart';
import 'package:alok/src/models/account_model.dart';
import 'package:alok/src/network/requests.dart';
import 'package:alok/src/ui/user/Components.dart';
import 'package:alok/src/utils/global_widgets.dart';

class CreateNewAccountPage extends StatefulWidget {
  @override
  _CreateNewAccountPageState createState() => _CreateNewAccountPageState();
}

class _CreateNewAccountPageState extends State<CreateNewAccountPage> {
  var putOpacity = new Opacity(opacity: 0.0, child: Container());
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var multipartFileDocument;
  List<AccountType> selectedAccountType = new List<AccountType>();
  var mapAccounts = Map<String, int>();
  List<String> listAccountNames = new List<String>();

  int selectedAccountTypeInteger;
  bool _validateAmount = false;
  bool _validateAccountHolderName = false;
  bool _validateDateOfBirth = false;
  bool _validateAccountHolderAdharCardNumber = false;
  bool _validateMobile = false;
  bool _validateEmailId = false;
  bool _validateAddress = false;
  bool _validateCityName = false;
  bool _validatePINCode = false;

  // TextEditingController
  final _amountController = TextEditingController();
  final _dobController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _accountHolderAdharCardNumberController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _pinNumberController = TextEditingController();

  List<AccountModel> listAccountFor = new List<AccountModel>();
  List<String> listAccountForNames = new List<String>();
  var selectedAccountForNameValue;

  List<AccountModel> listAccountModels = new List<AccountModel>();
  List<String> listAccounts = new List<String>();
  var selectedListAccountValue;

  /// Initialised the state of the view
  @override
  void initState() {
    super.initState();
    getAccountTypeDropDown();
    accountForListItems(Res.accountForAPI);
    accountListItems(Res.accountModeAPI);
  }

  void accountForListItems(url) async {
    var response = await fetchAccountFor(url);
    if (response == null) {
      showToast(context, 'Failed to load account for Items');
    }
    listAccountFor = response;
    listAccountFor.forEach((element) {
      listAccountForNames.add('${element.getName}');
    });
    setState(() {
      listAccountForNames = listAccountForNames;
      print('listAccountForNames: $listAccountForNames');
    });
  }

  void accountListItems(url) async {
    var response = await fetchAccountFor(url);
    if (response == null) {
      showToast(context, 'Failed to load account list Items');
    }
    listAccountModels = response;
    listAccountModels.forEach((element) {
      listAccounts.add(element.getName);
    });

    setState(() {
      listAccounts = listAccounts;
      print('listAccounts: $listAccounts');
    });
  }

  void getAccountTypeDropDown() async {
    selectedAccountType = await getAllAccountType();
    selectedAccountType.toList().forEach((element) {
      setState(() {
        mapAccounts[element.name] = element.id;
        listAccountNames.add(element.name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _textFiledValidator() async {
      ///
      RegExp regex = new RegExp(pattern);
      setState(() {
        _validateAmount = false;
        _validateAccountHolderName = false;
        _validateDateOfBirth = false;
        _validateAccountHolderAdharCardNumber = false;
        _validateMobile = false;
        _validateEmailId = false;
        _validateAddress = false;
        _validateCityName = false;
        _validatePINCode = false;
      });

      if (_accountHolderNameController.text.isEmpty) {
        _validateAccountHolderName = true;
        return;
      } else if (selectedListAccountValue != 'Gullak' &&
          _amountController.text.isEmpty) {
        _validateAmount = true;
        return;
      } else if (_accountHolderAdharCardNumberController.text.isEmpty ||
          _accountHolderAdharCardNumberController.text.length < 12) {
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
        _validateCityName = true;
        return;
      } else if (_pinNumberController.text.isEmpty ||
          _pinNumberController.text.length < 6) {
        _validatePINCode = true;
        return;
      } else {
        // clear all fields
        var box = Hive.box(Res.aHiveDB);
        var userId = box.get(Res.aUserId);

        Map<String, String> credentials = {
          'accountTypeId': selectedAccountTypeInteger.toString(),
          'accountMode': selectedListAccountValue,
          'amount': _amountController.text.trim().toString(),
          'accountFor': selectedAccountForNameValue,
          'accountHolderName': _accountHolderNameController.text.trim(),
          'dateOfBirth': _dobController.text.trim(),
          'identityCardNumber':
              _accountHolderAdharCardNumberController.text.trim().toString(),
          'mobileNumber': _mobileController.text.trim(),
          'email': _emailAddressController.text.trim(),
          'address': _addressController.text.trim(),
          'city': _cityNameController.text.trim(),
          'pincode': _pinNumberController.text.trim(),
          'userId': '$userId'
        };

        //print(credentials);
        http.post(Res.createAccount, body: credentials).then((response) {
          if (response.statusCode == 200) {
            print(response.body);
            Map userMap = json.decode(response.body);
            if (userMap['success']) {
              showToast(context, userMap['message']);
              var tempAccountNumber = userMap['data']['tempAccountNumber'];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BeneficiaryDetailsPage(
                          tempId: tempAccountNumber.toString())));
            } else {
              showToastWithError(context, userMap['message']);
            }
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
                              selectedAccountTypeInteger = mapAccounts[value];
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
                            items: listAccounts,
                            isExpanded: true,
                            showUnderline: false,
                            dropDownType: DropDownType.Button,
                            hint: Text('Account mode'),
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                selectedListAccountValue = value;
                              });
                            },
                          ),
                        ),

                        Visibility(
                          visible: selectedListAccountValue == 'Gullak'
                              ? false
                              : true,
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: _amountController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorText:
                                    _validateAmount ? 'Provide Amount' : null,
                                contentPadding: EdgeInsets.all(0),
                                focusedBorder: buildFocusedOutlineInputBorder(),
                                enabledBorder: buildEnabledOutlineInputBorder(),
                                labelText: "Amount",
                                prefixIcon: Icon(CupertinoIcons.money_dollar),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ),
                        ),

                        //====================================
                        // Dropdown
                        SizedBox(height: 10),
                        Container(
                          decoration: buildBoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropDown(
                            items: listAccountForNames,
                            isExpanded: true,
                            showUnderline: false,
                            dropDownType: DropDownType.Button,
                            hint: Text('Account for'),
                            onChanged: (value) {
                              print(value);
                              selectedAccountForNameValue = value;
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
                          onTap: () async {
                            DateTime date = DateTime(1900);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            var formattedDate =
                                "${date.day}/${date.month}/${date.year}";

                            print(formattedDate);
                            _dobController.text = formattedDate;
                            // Show Date Picker Here
                          },
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
                          maxLength: 12,
                          decoration: InputDecoration(
                            errorText: _validateAccountHolderAdharCardNumber
                                ? "Invalid account holder name"
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
                            prefixIcon: const Icon(Icons.location_on_sharp),
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
                            errorText: _validateCityName
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
                            errorText: _validatePINCode ? "Invalid PIN" : null,
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
                              _textFiledValidator();
                            },
                          ),
                        ),
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
