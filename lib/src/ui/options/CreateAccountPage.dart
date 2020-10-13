import 'package:alok/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateNewAccountPage extends StatefulWidget {
  @override
  _CreateNewAccountPageState createState() => _CreateNewAccountPageState();
}

class _CreateNewAccountPageState extends State<CreateNewAccountPage> {
  @override
  Widget build(BuildContext context) {
    // TextEditingController
    String _errorIDCard;
    String _errorFirstName;
    String _errorLastName;
    String _errorAccountHolderName;
    String _errorMobileNumber;
    String _errorEmailAddress;
    String _errorCity;
    String _errorPIN;

    // TextEditingController
    final TextEditingController _identityCardController =
        TextEditingController();
    final TextEditingController _firstNameController = TextEditingController();
    final TextEditingController _lastNameController = TextEditingController();
    final TextEditingController _accountHolderNameController =
        TextEditingController();
    final TextEditingController _mobileNoController = TextEditingController();
    final TextEditingController _emailAddressController =
        TextEditingController();
    final TextEditingController _cityController = TextEditingController();
    final TextEditingController _pinController = TextEditingController();

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
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          //====================================

                          CupertinoTextField(
                            controller: _identityCardController,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            prefix: _buildPadding(),
                            placeholder: "Identity card number",
                            decoration: _buildBoxDecoration(),
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                _errorIDCard = value;
                              });
                            },
                          ),

                          //====================================
                          SizedBox(
                            height: 10,
                          ),
                          CupertinoTextField(
                            controller: _firstNameController,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            prefix: _buildPadding(),
                            placeholder: "First name",
                            decoration: _buildBoxDecoration(),
                          ),

                          //====================================
                          SizedBox(
                            height: 10,
                          ),
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
                          SizedBox(
                            height: 10,
                          ),
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
                          SizedBox(
                            height: 10,
                          ),
                          CupertinoTextField(
                            controller: _pinController,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            keyboardType: TextInputType.number,
                            prefix: _buildPadding(),
                            placeholder: "PIN code",
                            decoration: _buildBoxDecoration(),
                          ),

                          //====================================
                          SizedBox(
                            height: 30,
                          ),
                          //====================================
                          //Button
                          CupertinoButton(
                            child: Text('Submit'),
                            color: Res.primaryColor,
                            onPressed: () {
                              // Write your callback here
                            },
                          ),
                          //====================================
                        ],
                      ),
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
}
