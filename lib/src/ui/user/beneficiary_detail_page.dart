import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
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

  bool _validateBeneficiaryName = false;
  bool _validateDOB = false;
  bool _validateIdNumber = false;
  bool _validateMobile = false;
  bool _validateEmailId = false;

  // TextEditingController
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _idCardController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  /// Initialised the state of the view
  @override
  void initState() {
    super.initState();
  }

  /// This build makes draws the conatains the view of the Screen
  @override
  Widget build(BuildContext context) {
    void _textFiledValidator() async {
      setState(() {
        _validateBeneficiaryName = false;
        _validateDOB = false;
        _validateMobile = false;
        _validateEmailId = false;
      });

      RegExp regex = new RegExp(pattern);
      if (_nameController.text.isEmpty) {
        _validateBeneficiaryName = true;
        return;
      } else if (_dobController.text.isEmpty) {
        _validateDOB = true;
        return;
      } else if (_idCardController.text.isEmpty) {
        _validateIdNumber = true;
        return;
      } else if (_mobileController.text.isEmpty ||
          _mobileController.text.length < 10) {
        _validateMobile = true;
        return;
      } else if (_emailController.text.isNotEmpty &&
          !regex.hasMatch(_emailController.text)) {
        _validateEmailId = true;
        return;
      } else {
        Map<String, String> credentials = {
          'tempAccountNumber': '${widget.tempId}',
          'beneficiaryName': _nameController.text.trim(),
          'dateOfBirth': _dobController.text.trim(),
          'identityCardNumber': _idCardController.text.trim(),
          'mobileNumber': _mobileController.text.trim(),
          'email': _emailController.text.trim().toString(),
        };
        postCredential(credentials);
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Beneficiary Details'),
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
                        ///
                        /// ================================
                        /// Baneficiary name
                        /// ================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validateBeneficiaryName
                                ? "Beneficiary name can\'t Be Empty"
                                : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Beneficiary name",
                            prefixIcon: const Icon(CupertinoIcons.person_fill),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        ///====================================
                        /// beneficiary date of birth
                        ///====================================
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
                            errorText: _validateDOB ? 'Date of birth' : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Beneficiary date of birth",
                            prefixIcon: Icon(CupertinoIcons.calendar_today),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ), //buildInputDecoration('ID card number'),
                        ),

                        ///====================================
                        ///Account holder account holder adhar card number
                        ///====================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _idCardController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          maxLength: 12,
                          decoration: InputDecoration(
                            errorText: _validateIdNumber
                                ? "Invalid Adhar number"
                                : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Account holder adhar card number",
                            prefixIcon: const Icon(CupertinoIcons.phone),
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
                          controller: _emailController,
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
                        SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Map<String, String> credentials = {
                                      'tempAccountNumber': '${widget.tempId}',
                                      'beneficiaryName':
                                          _nameController.text.trim(),
                                      'dateOfBirth': _dobController.text.trim(),
                                      'identityCardNumber':
                                          _idCardController.text.trim(),
                                      'mobileNumber':
                                          _mobileController.text.trim(),
                                      'email': _emailController.text
                                          .trim()
                                          .toString(),
                                    };
                                    postCredential(credentials);
                                  },
                                  child: Text('Skip')),
                              CupertinoButton(
                                child: Text('Create Account'),
                                color: Res.primaryColor,
                                onPressed: () {
                                  _textFiledValidator();
                                },
                              ),
                            ]),
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

  void postCredential(Map<String, String> credentials) {
    print(credentials);
    http.post(Res.addBenefciaryAPI, body: credentials).then((response) {
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

  // showGiffyDialog(message) {
  //   showDialog(
  //       context: context,
  //       builder: (_) => NetworkGiffyDialog(
  //             image: Image.network(
  //               "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
  //               fit: BoxFit.cover,
  //             ),
  //             entryAnimation: EntryAnimation.BOTTOM,
  //             title: Text(
  //               'Successful',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
  //             ),
  //             description: Text(message),
  //             onOkButtonPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ));
  // }

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
