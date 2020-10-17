import 'package:alok/res.dart';
import 'package:alok/src/models/DepositAmountRequestList.dart';
import 'package:alok/src/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:http/http.dart' as http;

class DepositeAmount extends StatefulWidget {
  @override
  _DepositeAmountState createState() => _DepositeAmountState();
}

class _DepositeAmountState extends State<DepositeAmount> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DepositAmountRequestList> depositeList = getRequestList();
  List<int> transactionIds;
  String accountHolderName;
  final _amountController = TextEditingController();
  final _remarkController = TextEditingController();
  bool _validateFieldAmount = false;
  bool _validateFieldRemark = false;

  getAllRequestList() {
    depositeList.forEach((element) {
      transactionIds.add(element.transactionId);
    });
    return transactionIds;
  }

  showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    transactionIds = new List();
    accountHolderName = '';
    transactionIds = getAllRequestList();
  }

  void textFieldValidator() {
    setState(() {
      _validateFieldAmount = false;
      _validateFieldRemark = false;
    });
    if (accountHolderName == null || accountHolderName.isEmpty) {
      showSnackBar('Pls select transaction id');
    } else if (_amountController.text.trim().isEmpty ||
        _amountController.text.trim().length < 2) {
      setState(() {
        _validateFieldAmount = true;
        showSnackBar('Provide valid amount');
      });
      return;
    } else if (_remarkController.text.trim().isEmpty) {
      setState(() {
        _validateFieldRemark = true;
        showSnackBar('provide remark');
        return;
      });
    } else {
      // make api request
      postCall().then((value) {
        if (value.statusCode == 200) {
          print('onSuccess: $value');
          showToast(context, ('Successfully created done'));
          Navigator.pop(context);
        } else {
          showToastWithError(context, 'Something went wrong, please try again');
        }
      }).catchError((onFailed) {
        showToastWithError(context, 'Something went wrong, please try again');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Res.accentColor,
            elevation: 0,
            centerTitle: true,
            title: Text('Deposite'),
            actions: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.more_vert),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      color: Res.accentColor,
                      height: 200,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          //================================
                          //Dropdown Field
                          SizedBox(height: 10),
                          DropDown(
                            items: transactionIds, //listAccountNames,
                            isExpanded: true,
                            showUnderline: true,
                            dropDownType: DropDownType.Button,
                            hint: Text('Transaction Id'),
                            onChanged: (value) {
                              var idx = depositeList.indexWhere(
                                  (DepositAmountRequestList documentSnapshot) =>
                                      documentSnapshot.transactionId == value);
                              var selected = depositeList.elementAt(idx);
                              setState(() {
                                accountHolderName = selected.accountHolderName;
                              });
                            },
                          ),
                          //====================================
                          SizedBox(height: 10),
                          TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                //border: OutlineInputBorder(),
                                hintText: 'amount',
                                //helperText: 'Pls provide transaction id.',
                                labelText: 'amount',
                                alignLabelWithHint: true,
                                errorText: _validateFieldAmount
                                    ? 'Provide valid amount'
                                    : null,
                                prefixIcon: const Icon(
                                  Icons.attach_money,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                suffixStyle: const TextStyle(
                                    color: CupertinoColors.inactiveGray)),
                          ),

                          //====================================
                          SizedBox(height: 10),
                          TextField(
                            controller: _remarkController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                //border: OutlineInputBorder(),
                                hintText: 'Remark',
                                //helperText: 'Pls provide remark.',
                                labelText: 'Remark',
                                errorText: _validateFieldRemark
                                    ? 'Provide valid amount'
                                    : null,
                                prefixIcon: const Icon(
                                  Icons.text_format,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                suffixStyle: const TextStyle(
                                    color: CupertinoColors.inactiveGray)),
                          ),
                          //====================================
                          SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            child: CupertinoButton(
                              child: Text('Submit'),
                              color: Res.primaryColor,
                              onPressed: () async {
                                // Write your callback here
                                textFieldValidator();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  Future postCall() async {
    var dataToPost = {
      'agentId': '6',
      'transactionId': _amountController.text.trim(),
      'amount': _amountController.text.trim(),
      'remark': _remarkController.text.trim(),
    };
    await http.post(
      Res.depositAmountAPI,
      body: dataToPost,
    );
  }
}
