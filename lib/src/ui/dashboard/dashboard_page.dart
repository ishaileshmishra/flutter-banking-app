import 'package:alok/res.dart';
import 'package:alok/src/models/DashboardModel.dart';
import 'package:alok/src/network/service.dart';
import 'package:alok/src/ui/options/DepositeAmount.dart';
import 'package:alok/src/ui/options/CreateAccountPage.dart';
import 'package:alok/src/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key key, this.user}) : super(key: key);

  final Map user;

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = Reposit.getCategories();

    return Scaffold(
      backgroundColor: Res.primaryColor,
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            // container appbar
            buildAppbar(),
            buildAccountStrip(),
            SizedBox(height: 30),
            buildExpanded(categories)
          ],
        ),
      ),
    );
  }

  Expanded buildExpanded(List<CatModel> categories) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
      ),
      child: _listView(categories),
    ));
  }

  ListView _listView(categories) {
    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => {
              {
                index == 0
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
              elevation: 1,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your main balance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            widget.user['isAccountCreated'] == 0
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateNewAccountPage()),
                      );
                    },
                    child: btnCreatAccount())
                : Text("45.500,12",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
          ],
        ),
      ),
    );
  }

  Container btnCreatAccount() {
    return Container(
      padding: EdgeInsets.all(4),
      width: 150,
      decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.inactiveGray)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.add_circled),
          SizedBox(width: 6),
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Container buildAppbar() {
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
                '${widget.user['firstName']} ${widget.user['lastName']}',
                style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),

          // CircleAvatar(
          //   child: Image.asset(
          //     'assets/images/clock.png',
          //     fit: BoxFit.cover,
          //     width: 40,
          //     height: 40,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              myAppBarIcon(),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                child: Image.asset(
                  'assets/images/clock.png',
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
