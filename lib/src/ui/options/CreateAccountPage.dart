import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter/services.dart';
import 'package:alok/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CreateNewAccountPage extends StatefulWidget {
  @override
  _CreateNewAccountPageState createState() => _CreateNewAccountPageState();
}

class _CreateNewAccountPageState extends State<CreateNewAccountPage> {
  //
  String _fileName;
  Item selectedUser;
  List<Item> users = <Item>[
    const Item(
        'Aadhar Card',
        Icon(
          Icons.android,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'PAN card',
        Icon(
          Icons.flag,
          color: const Color(0xFF167F67),
        )),
  ];

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
  String _filename = 'No file selected';
  var multipartFileSign;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration _buildBoxDecoration() {
      return BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: CupertinoColors.inactiveGray,
        ),
        borderRadius: BorderRadius.circular(10.0),
      );
    }

    Padding _buildPadding() {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.perm_identity_rounded, color: Res.primaryColor),
      );
    }

    Future<void> _pickFile() async {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File imageFile = File(result.files.single.path);
        var stream =
            // ignore: deprecated_member_use
            new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();

        imageFile
            .exists()
            .then((value) => {
                  setState(() {
                    multipartFileSign = new http.MultipartFile(
                        'identityCardFile', stream, length,
                        filename: basename(imageFile.path));
                    print('filename path: $imageFile.path');
                  })
                })
            .catchError((onError) {
          print('error: $onError');
        });
      }
    }

    uploadFile(data) async {
      var postUri = Uri.parse(Res.createAccount);
      var request = new http.MultipartRequest("POST", postUri);

      //fields
      request.fields['accountTypeId'] = '1';
      request.fields['identityCardNumber'] = data['identityCardNumber'];
      request.fields['firstName'] = data['firstName'];
      request.fields['lastName'] = data['lastName'];
      request.fields['accountHolderName'] = data['accountHolderName'];
      request.fields['email'] = data['email'];
      request.fields['mobileNumber'] = data['mobileNumber'];
      request.fields['city'] = data['city'];
      request.fields['pincode'] = data['pincode'];
      // image/file

      print('sending fields KEYS ${request.fields.keys}');
      print('sending fields Values ${request.fields.values}');
      print('multipart file: $multipartFileSign');

      request.files.add(multipartFileSign);

      request.send().then((response) {
        print("Uploading in progress...");
        if (response.statusCode == 200) {
          //var resp = json.decode();

          response.stream.transform(utf8.decoder).listen((value) {
            print(value);
          });
          print("Uploaded!");
        } else {
          response.stream.bytesToString().catchError((onError) {
            print(onError);
          });
          print("Failed to Upload!");
        }
      });
    }

    void _validator() async {
      //validate the blank field
      if (_identityCardController.text.isEmpty) {
        setState(() {
          _errorIDCard = 'Please write filename';
          print(_errorIDCard);
        });
        return;
      } else if (_identityCardController.text.isEmpty) {
        setState(() {
          _errorIDCard = 'Please choose the file';
        });
        return;
      } else if (_identityCardNumberController.text.isEmpty) {
        setState(() {
          _errorIDCardNumber = 'Provide card number';
        });
        return;
      } else if (_firstNameController.text.isEmpty) {
        setState(() {
          _errorFirstName = 'Please provide first name';
        });
        return;
      } else if (_lastNameController.text.isEmpty) {
        setState(() {
          _errorLastName = 'Please provide last name';
        });
        return;
      } else if (_accountHolderNameController.text.isEmpty) {
        setState(() {
          _errorAccountHolderName = 'Please provide Account holder name';
        });
        return;
      } else if (_mobileNoController.text.isEmpty) {
        setState(() {
          _errorMobileNumber = 'Please provide mobile number';
        });
        return;
      } else if (_emailAddressController.text.isEmpty) {
        setState(() {
          _errorEmailAddress = 'Please provide email address';
        });
        return;
      } else if (_cityController.text.isEmpty) {
        setState(() {
          _errorCity = 'Please provide city name';
        });
        return;
      } else if (_pinController.text.isEmpty) {
        setState(() {
          _errorPIN = 'Please provide PIN';
        });
        return;
      }

      Map data = {
        'accountTypeId': selectedUser,
        //'identityCardFile': '',
        'identityCardNumber': _identityCardController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'accountHolderName': _accountHolderNameController.text,
        'email': _emailAddressController.text,
        'mobileNumber': _mobileNoController.text,
        'city': _cityController.text,
        'pincode': _pinController.text
      };

      //_postCreateAccount(data);
      uploadFile(data);
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
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropDown(
                          items: ["Male", "Female", "Other"],
                          isExpanded: true,
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                        SizedBox(height: 10),

                        //====================================
                        CupertinoTextField(
                          controller: _identityCardController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: _buildPadding(),
                          onChanged: (value) {
                            setState(() {
                              _filename = value;
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
                                  'Choose file'.toLowerCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                color: Res.accentColor,
                                onPressed: () => _pickFile()),
                            SizedBox(width: 20),
                            Flexible(
                              child: Text(
                                _filename,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        //====================================
                        CupertinoTextField(
                          controller: _identityCardNumberController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: _buildPadding(),
                          placeholder: "Identity card number",
                          decoration: _buildBoxDecoration(),
                        ),
                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _firstNameController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: _buildPadding(),
                          placeholder: "First name",
                          decoration: _buildBoxDecoration(),
                        ),
                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _lastNameController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: _buildPadding(),
                          placeholder: "Last name",
                          decoration: _buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _accountHolderNameController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: _buildPadding(),
                          placeholder: "Account holder name",
                          decoration: _buildBoxDecoration(),
                        ),
                        SizedBox(height: 10),
                        //====================================
                        CupertinoTextField(
                          controller: _mobileNoController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: _buildPadding(),
                          placeholder: "Mobile number",
                          decoration: _buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _emailAddressController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: _buildPadding(),
                          placeholder: "E-Mail Id",
                          decoration: _buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _cityController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: _buildPadding(),
                          placeholder: "City",
                          decoration: _buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _pinController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          keyboardType: TextInputType.number,
                          prefix: _buildPadding(),
                          placeholder: "PIN code",
                          decoration: _buildBoxDecoration(),
                        ),

                        //====================================
                        SizedBox(height: 30),
                        //====================================
                        //Button
                        Container(
                          width: double.infinity,
                          child: CupertinoButton(
                            child: Text('Submit'),
                            color: Res.primaryColor,
                            onPressed: () {
                              // Write your callback here
                              _validator();
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

  DropdownButton<Item> buildDropdownButton() {
    return DropdownButton<Item>(
      hint: Text("Select Account Type"),
      value: selectedUser,
      onChanged: (Item item) {
        setState(() {
          selectedUser = item;
        });
      },
      items: users.map((Item user) {
        return DropdownMenuItem<Item>(
          value: user,
          child: Row(
            children: <Widget>[
              user.icon,
              SizedBox(
                width: 10,
              ),
              Text(
                user.name,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}
