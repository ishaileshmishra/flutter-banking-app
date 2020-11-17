import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:alok/res.dart';
import 'package:alok/src/models/DashboardModel.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/models/UserAccountModel.dart';
import 'package:alok/src/network/service.dart';
import 'package:alok/src/ui/account/components.dart';
import 'package:alok/src/ui/agent/kyc/kyc_request.dart';
import 'package:alok/src/ui/profile/profile_screen.dart';
import 'package:alok/src/ui/user/create/CreateAccountPage.dart';

class AccountMngntScreen extends StatefulWidget {
  AccountMngntScreen({Key key, this.user}) : super(key: key);

  final LoginResponse user;

  @override
  _AccountMngntScreenState createState() => _AccountMngntScreenState();
}

class _AccountMngntScreenState extends State<AccountMngntScreen> {
  String selectedAccount;
  String accountNumber;
  String availableBalance;
  String lastTransactionAmount;
  String lastTransactionDate;

  Future<void> _loadAccountLists() async {
    await http
        .get(
            "http://asralokkalyan.in/user/accountList?userId=${widget.user.userId}")
        .then((response) {
      Map dashboard = json.decode(response.body);
      if (dashboard["success"]) {
        var accountList = (dashboard['data'] as List)
            .map((i) => UserAccountModel.fromJson(i))
            .toList();
        if (accountList.length == 1) {
          setState(() {
            selectedAccount = accountList[0].toString();
            _loadAccountDetails();
          });
        } else {
          _showModal(accountList);
        }
      }
      print('dashboard: $dashboard');
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> _loadAccountDetails() async {
    await http
        .get(
            "http://asralokkalyan.in/user/dashboard?accountNumber=$selectedAccount")
        .then((response) {
      Map dashboard = json.decode(response.body);
      if (dashboard["success"]) {
        var data = dashboard['data'];
        print(data);
        setState(() {
          accountNumber = data['accountNumber'];
          availableBalance = data['availableBalance'];
          lastTransactionAmount = data['lastTransactionAmount'];
          lastTransactionDate = data['lastTransactionDate'];
        });
      }
      print('dashboard: $dashboard');
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  void initState() {
    _loadAccountLists();
    super.initState();
  }

  void _showModal(List accounts) {
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 260.0,
            child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateNewAccountPage())),
                    child: Card(
                      elevation: 0.0,
                      color: Colors.yellow,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text("${accounts[index]}"),
                      ),
                    ),
                  );
                }));
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    print('modal closed');
  }

  @override
  Widget build(BuildContext context) {
    final categories = Reposit.getCategories();
    final agentCategories = Reposit.getAgentCategories();
    final username = "${widget.user.firstName} ${widget.user.lastName}";
    final depositBalance = widget.user.noOfDepositRequest.toDouble();

    return Scaffold(
      backgroundColor: Res.accentColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Res.accentColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Accounts',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              CupertinoIcons.bell,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile())),
              child: Icon(
                CupertinoIcons.person,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            renderActionbar(context, username),
            buildAccountStrip(context, depositBalance),
            SizedBox(height: 30),
            buildExpanded(categories, agentCategories)
          ],
        ),
      ),
    );
  }

  Expanded buildExpanded(
      List<CatModel> categories, List<CatModel> agentCategories) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      child: widget.user.role == 'user'
          ? listView(widget.user.role, categories)
          : listView(widget.user.role, agentCategories),
    ));
  }

  Container buildAccountStrip(context, depositBalance) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Res.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        child: widget.user.role == 'user'
            ? buildUserColumn(context, depositBalance)
            : buildAgentColumn(context),
      ),
    );
  }

  Column buildAgentColumn(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => KYCRequestPage())),
          child: Text(
            'KYC request : ${widget.user.noOfDepositRequest}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => KYCRequestPage()));
          },
          child: Text(
            'View Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  Column buildUserColumn(context, depositBalance) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.user.isAccountCreated == 0
            ? Text(
                'Available Balance : ${availableBalance ?? 'n/a'} \nAccount Number: ${accountNumber ?? "n/a"} \nLast TransactionAmount: ${lastTransactionAmount ?? 'n/a'} \nLast TransactionDate: ${lastTransactionDate ?? 'n/a'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            : Text(
                'Available balance : $depositBalance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
        SizedBox(height: 20),
        widget.user.isAccountCreated == 0
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNewAccountPage(),
                    ),
                  );
                },
                child: btnCardView(titleTitle: "Create Account"))
            : Text('$availableBalance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
      ],
    );
  }
}
