import 'package:alok/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BeneficiaryDetailsPage extends StatefulWidget {
  @override
  _BeneficiaryDetailsPageState createState() => _BeneficiaryDetailsPageState();
}

class _BeneficiaryDetailsPageState extends State<BeneficiaryDetailsPage> {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool _validateAdharCardNumber = false;
  bool _validateDOB = false;
  bool _validateMobile = false;
  bool _validateEmailId = false;

  // TextEditingController
  final _accountHolderAdharCardNumberController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailAddressController = TextEditingController();

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
        _validateAdharCardNumber = false;
        _validateDOB = false;
        _validateMobile = false;
        _validateEmailId = false;
      });
      RegExp regex = new RegExp(pattern);

      if (_accountHolderAdharCardNumberController.text.isEmpty) {
        _validateAdharCardNumber = true;
        return;
      } else if (_dobController.text.isEmpty) {
        _validateDOB = true;
        return;
      } else if (_mobileController.text.isEmpty ||
          _mobileController.text.length < 10) {
        _validateMobile = true;
        return;
      } else if (_emailAddressController.text.isNotEmpty &&
          !regex.hasMatch(_emailAddressController.text)) {
        _validateEmailId = true;
        return;
      } else {
        // clear all fields
        var box = Hive.box(Res.aHiveDB);
        var userId = box.get(Res.aUserId);
        print('userId $userId');
        Map<String, String> credentials = {
          'accountHolderName':
              _accountHolderAdharCardNumberController.text.trim(),
          'email': _emailAddressController.text.trim(),
          'mobileNumber': _mobileController.text.trim(),
          'userId': '$userId'
        };
        // POST The fields and multipartFile
        // await uploadFileWithFields(_scaffoldKey, credentials, multipartFileDocument);

        print(credentials);
        // request.send().then((response) {
        //   if (response.statusCode == 200) {
        //     response.stream.transform(utf8.decoder).listen((value) {
        //       Map userMap = json.decode(value);
        //       if (userMap['success']) {
        //         showToast(context, userMap['message']);
        //         new Future.delayed(const Duration(seconds: 2));
        //         Navigator.pop(context);
        //       } else {
        //         showToastWithError(context, userMap['message']);
        //       }
        //     });
        //   }
        // }).catchError((error) {
        //   showToastWithError(context, 'FAILED ${error.toString()}');
        // });
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baneficiary name
                        // ================================
                        SizedBox(height: 10),
                        TextField(
                          controller: _accountHolderAdharCardNumberController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validateAdharCardNumber
                                ? "Adhar card number can\'t Be Empty"
                                : null,
                            contentPadding: EdgeInsets.all(0),
                            focusedBorder: buildFocusedOutlineInputBorder(),
                            enabledBorder: buildEnabledOutlineInputBorder(),
                            labelText: "Account holder adhar card number",
                            prefixIcon: const Icon(CupertinoIcons.person_fill),
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
                                "${date.day}-${date.month}-${date.year}";

                            print(formattedDate);
                            _dobController.text = formattedDate;
                            // Show Date Picker Here
                          },
                          decoration: InputDecoration(
                            errorText: _validateDOB ? 'Date of birth' : null,
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
                        SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Skip'),
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
}
