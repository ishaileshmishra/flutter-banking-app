import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/ui/user/Components.dart';
import 'package:alok/src/utils/global_widgets.dart';

class BeneficiaryDetailsPage extends StatefulWidget {
  BeneficiaryDetailsPage({Key key, this.tempId}) : super(key: key);

  final String tempId;

  @override
  _BeneficiaryDetailsPageState createState() => _BeneficiaryDetailsPageState();
}

class _BeneficiaryDetailsPageState extends State<BeneficiaryDetailsPage> {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool _validateMembershipNo = false;
  bool _validateName = false;
  bool _validateEmailId = false;
  bool _validateFullAddress = false;
  bool _validatePIN = false;
  bool _validateCity = false;
  bool _validateState = false;
  bool _validateAdharNo = false;
  bool _validateAdharName = false;
  bool _validatePanNo = false;
  bool _validatePanAttachement = false;

  // TextEditingController
  final _membershipNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullAddresssController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _adharNoController = TextEditingController();
  final _nameOnAdharController = TextEditingController();
  final _panNoController = TextEditingController();
  final _panFrontAttachmentController = TextEditingController();

  /// This build makes draws the conatains the view of the Screen
  @override
  Widget build(BuildContext context) {
    void _textFiledValidator() async {
      // Reset all the fields
      setState(() {
        _validateMembershipNo = false;
        _validateName = false;
        _validateEmailId = false;
        _validateFullAddress = false;
        _validatePIN = false;
        _validateCity = false;
        _validateState = false;
        _validateAdharNo = false;
        _validateAdharName = false;
        _validatePanNo = false;
        _validatePanAttachement = false;
      });

      RegExp regex = new RegExp(pattern);
      if (_membershipNumberController.text.isEmpty) {
        _validateMembershipNo = true;
        return;
      } else if (_nameController.text.isEmpty) {
        _validateName = true;
        return;
      } else if (_emailController.text.isNotEmpty &&
          !regex.hasMatch(_emailController.text)) {
        _validateEmailId = true;
        return;
      } else if (_fullAddresssController.text.isNotEmpty) {
        _validateFullAddress = true;
        return;
      } else if (_pincodeController.text.isNotEmpty) {
        _validatePIN = true;
        return;
      } else if (_cityController.text.isNotEmpty) {
        _validateCity = true;
        return;
      } else if (_stateController.text.isNotEmpty) {
        _validateState = true;
        return;
      } else if (_adharNoController.text.isNotEmpty &&
          _adharNoController.text.length != 12) {
        _validateAdharNo = true;
        return;
      } else if (_nameOnAdharController.text.isNotEmpty) {
        _validateAdharName = true;
        return;
      } else if (_panNoController.text.isNotEmpty &&
          _panNoController.text.length != 10) {
        _validatePanNo = true;
        return;
      } else if (_panFrontAttachmentController.text.isNotEmpty) {
        _validatePanAttachement = true;
        return;
      } else {
        Map<String, String> credentials = {
          'tempAccountNumber': '${widget.tempId}',
          'membershipNumber': _membershipNumberController.text.trim(),
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim().toString(),
          'fullAddress': _fullAddresssController.text.trim(),
          'pincode': _pincodeController.text.trim(),
          'city': _cityController.text.trim(),
          'state': _stateController.text.trim(),
          'adharCardNumber': _adharNoController.text.trim(),
          'adharcardName': _nameOnAdharController.text.trim(),
          'panNumber': _panNoController.text.trim(),
          'panCardName': _panNoController.text.trim(),
        };
        postCredential(credentials);
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  buildYellowContainer(),
                  Container(
                    margin: EdgeInsets.only(top: 100),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //========================
                        //Personal details block
                        //========================
                        buildAlignPersonalDetails(),
                        SizedBox(height: 10),
                        buildTextFieldMembershipNumber(),
                        SizedBox(height: 10),
                        buildTextFieldName(),
                        SizedBox(height: 10),
                        buildTextFieldEmail(),
                        SizedBox(height: 10),
                        buildTextFieldFullAddress(),
                        SizedBox(height: 10),
                        buildTextFieldPincode(),
                        SizedBox(height: 10),
                        buildTextFieldCity(),
                        SizedBox(height: 10),
                        buildTextFieldState(),

                        ///====================================
                        /// KYC Details
                        ///====================================
                        SizedBox(height: 40),
                        kycDetailsText(),
                        SizedBox(height: 10),
                        buildTextFieldAdharNumber(),
                        SizedBox(height: 10),
                        buildTextFieldAdharcardName(),
                        SizedBox(height: 10),
                        buildTextFieldPanNo(),
                        SizedBox(height: 10),
                        buildPanAttachmentTextField(),
                        SizedBox(height: 30),
                        buildBtnRow(_textFiledValidator),
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

  Container buildYellowContainer() {
    return Container(
      color: Res.accentColor,
      height: 130,
      child: Container(
        child: Image.asset('assets/images/dashboard.png'),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: Text(
        'Beneficiary Details',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Res.accentColor,
      elevation: 0,
      actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  Align buildAlignPersonalDetails() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Personal Details',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  TextField buildTextFieldMembershipNumber() {
    return TextField(
      controller: _membershipNumberController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        errorText:
            _validateMembershipNo ? "Please provide membership number" : null,
        contentPadding: EdgeInsets.all(0),
        filled: true,
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "Membership number",
        prefixIcon: const Icon(Icons.card_membership),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  TextField buildTextFieldName() {
    return TextField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        errorText: _validateName ? "Name can\'t Be Empty" : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "Name",
        prefixIcon: const Icon(CupertinoIcons.person_fill),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  TextField buildTextFieldEmail() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        errorText: _validateEmailId ? "Invalid EmailId" : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "Email Id",
        prefixIcon: const Icon(CupertinoIcons.mail),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  TextField buildTextFieldFullAddress() {
    return TextField(
      controller: _fullAddresssController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorText: _validateFullAddress ? "Address can\'t Be Empty" : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "Full address",
        prefixIcon: const Icon(CupertinoIcons.location),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  TextField buildTextFieldPincode() {
    return TextField(
      controller: _pincodeController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        errorText: _validatePIN ? "Pindcode can\'t Be Empty" : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "Pincode",
        prefixIcon: const Icon(Icons.fiber_pin),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  TextField buildTextFieldCity() {
    return TextField(
      controller: _cityController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        errorText: _validateCity ? "City can\'t Be Empty" : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "City",
        prefixIcon: const Icon(Icons.location_city),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  TextField buildTextFieldState() {
    return TextField(
      controller: _stateController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        errorText: _validateState ? "State can\'t Be Empty" : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "State",
        prefixIcon: const Icon(Icons.location_city_rounded),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  Align kycDetailsText() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'KYC Details',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  TextField buildTextFieldAdharNumber() {
    return TextField(
      controller: _adharNoController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      maxLength: 12,
      decoration: InputDecoration(
        border: InputBorder.none,
        errorText: _validateAdharNo ? "Invalid Adhar number" : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "Adhar number",
        prefixIcon: const Icon(Icons.subtitles),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  TextField buildTextFieldAdharcardName() {
    return TextField(
      controller: _nameOnAdharController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      maxLength: 12,
      decoration: InputDecoration(
        border: InputBorder.none,
        errorText: _validateAdharName ? "Name on adhar can't be empty" : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "Name ( which is on adharcard )",
        prefixIcon: const Icon(CupertinoIcons.person_alt),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  TextField buildTextFieldPanNo() {
    return TextField(
      controller: _panNoController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLength: 10,
      decoration: InputDecoration(
        errorText: _validatePanNo ? "Invalid Mobile" : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "PAN number",
        prefixIcon: const Icon(Icons.subtitles),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  TextField buildPanAttachmentTextField() {
    return TextField(
      controller: _panFrontAttachmentController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLength: 10,
      decoration: InputDecoration(
        errorText: _validatePanAttachement
            ? "Pls provide PAN front copy as attachment"
            : null,
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: "",
        focusedBorder: buildFocusedOutlineInputBorder(),
        enabledBorder: buildEnabledOutlineInputBorder(),
        labelText: "PAN card font copy",
        prefixIcon: const Icon(Icons.attach_file),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  Row buildBtnRow(void _textFiledValidator()) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
          onTap: () {
            // postCredential(credentials);
          },
          child: Text('Skip')),
      CupertinoButton(
        child: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        color: Res.accentColor,
        onPressed: () {
          _textFiledValidator();
        },
      ),
    ]);
  }

  void postCredential(Map<String, String> credentials) {
    print(credentials);
    http.post(Res.addBeneficiaryAPI, body: credentials).then((response) {
      if (response.statusCode == 200) {
        Map userMap = json.decode(response.body);
        print(userMap);
        if (userMap['success']) {
          showToast(context, userMap['message']);
          //showGiffyDialog(userMap['message']);
          showBottomDialog(userMap['message']);
        } else {
          showToastWithError(context, userMap['message']);
        }
      }
    }).catchError((error) {
      showToastWithError(context, 'FAILED ${error.toString()}');
    });
  }

  showBottomDialog(message) {
    showGeneralDialog(
      barrierLabel: "Successful",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 300,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.golf_course_rounded,
                  size: 100,
                  color: Colors.green.shade300,
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(fontSize: 14, color: Colors.green.shade600),
                ),
                SizedBox(height: 30),
                CupertinoButton(
                  child: Text('Done'),
                  color: Res.primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
