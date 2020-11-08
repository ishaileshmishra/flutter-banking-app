import 'package:alok/src/ui/account/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:alok/res.dart';
import 'package:alok/src/models/DashboardModel.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/network/service.dart';
import 'package:alok/src/ui/agent/kyc/kyc_request.dart';
import 'package:alok/src/ui/user/create/CreateAccountPage.dart';

class AccountMngntScreen extends StatelessWidget {
  AccountMngntScreen({Key key, this.user}) : super(key: key);

  final LoginResponse user;

  @override
  Widget build(BuildContext context) {
    final categories = Reposit.getCategories();
    final agentCategories = Reposit.getAgentCategories();
    final username = "${user.firstName} ${user.lastName}";
    final depositBalance = user.noOfDepositRequest.toDouble();
    final availBalance = user.availableBalance;
    print('availBalance: $availBalance');

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
            //fontWeight: FontWeight.bold,
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
            child: Icon(
              CupertinoIcons.person,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            renderActionbar(context, username),
            buildAccountStrip(context, availBalance, depositBalance),
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
      child: user.role == 'user'
          ? listView(user.role, categories)
          : listView(user.role, agentCategories),
    ));
  }

  Container buildAccountStrip(context, availBalance, depositBalance) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Res.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        child: user.role == 'user'
            ? buildUserColumn(context, depositBalance, availBalance)
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
            'KYC request : ${user.noOfDepositRequest}',
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

  Column buildUserColumn(context, depositBalance, availBalance) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        user.isAccountCreated == 0
            ? Text(
                'Available balance : $availBalance',
                style: TextStyle(
                  fontSize: 16,
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
        user.isAccountCreated == 0
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
            : Text('$availBalance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
      ],
    );
  }
}
