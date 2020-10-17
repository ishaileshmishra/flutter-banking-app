import 'package:alok/res.dart';
import 'package:alok/src/models/DashboardModel.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/network/service.dart';
import 'package:alok/src/ui/agent/DepositAmount.dart';
import 'package:alok/src/ui/user/DepositeAmount.dart';
import 'package:alok/src/ui/user/CreateAccountPage.dart';
import 'package:alok/src/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key key, this.user}) : super(key: key);
  final LoginResponse user;
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = Reposit.getCategories();
    final agentCategories = Reposit.getAgentCategories();

    return Scaffold(
      backgroundColor: Res.primaryColor,
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            // container appbar
            buildAppbar(context),
            buildAccountStrip(),
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
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
      ),
      child: widget.user.role == 'user'
          ? _listView(categories)
          : _listView(agentCategories),
    ));
  }

  ListView _listView(categories) {
    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => {
              {
                (widget.user.role == 'agent' && index == 0)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepositeAmount()))
                    : index == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateNewAccountPage()),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DepositeAmountScreen()),
                          )
              },
            },
            child: Card(
              elevation: 4,
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    categories[index].title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  leading: categories[index].icon,
                ),
              ),
            ),
          );
        });
  }

  Container buildAccountStrip() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        child:
            widget.user.role == 'user' ? buildUserColumn() : buildAgentColumn(),
      ),
    );
  }

  Column buildAgentColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recieved request : ${widget.user.noOfDepositRequest}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DepositeAmount()));
            },
            child: btnViewRequest())
      ],
    );
  }

  Column buildUserColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.user.isAccountCreated == 0
            ? Text(
                'Available balance : ${widget.user.noOfDepositRequest.toDouble()}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            : Text(
                'Available balance : ${widget.user.noOfDepositRequest.toDouble()}',
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
                        builder: (context) =>
                            CreateNewAccountPage()), //CreateNewAccountPage()),
                  );
                },
                child: btnCreatAccount())
            : Text('${widget.user.availableBalance}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
      ],
    );
  }

  Card btnViewRequest() {
    return Card(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(10),
        //width: 160,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.supervised_user_circle_outlined,
              color: Res.accentColor,
            ),
            SizedBox(width: 6),
            Text(
              'View Request',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Card btnCreatAccount() {
    return Card(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(10),
        //width: 160,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.supervised_user_circle_outlined,
              color: Res.accentColor,
            ),
            SizedBox(width: 6),
            Text(
              'Create Account',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Container buildAppbar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${greeting()}',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade300,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '${widget.user.firstName} ${widget.user.lastName}',
                style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              myAppBarIcon(),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  bool logoutApp = _showAlertConfirmLogout();
                  print("logoutApp $logoutApp");
                  if (logoutApp) {
                    Navigator.pop(context);
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Res.accentColor,
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _showAlertConfirmLogout() async {
    // the response will store the .pop value (it can be any object you want)
    var response = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Logout'),
              content: Text('Do you want to logout?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancle')),
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Logout'))
              ],
            ));
    // do you want to do with the response.
    print('response flag $response');
    bool flag = response.toString().toLowerCase() == 'true';
    return flag;
  }
}
