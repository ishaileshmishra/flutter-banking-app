import 'package:alok/src/network/service.dart';
import 'package:alok/src/ui/options/AdmnOne.dart';
import 'package:alok/src/ui/options/AdmnTwo.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    const color1 = Color.fromRGBO(143, 148, 251, 1);
    const colorWhite = Colors.white;
    final categories = Reposit.getCategories();

    return Scaffold(
      backgroundColor: color1,
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            // container appbar
            buildAppbar(),
            buildAccountStrip(),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: _listView(categories),
            ))
          ],
        ),
      ),
    );
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
                        MaterialPageRoute(builder: (context) => AdminOne()),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminTwo()),
                      )
              },
            },
            child: Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              child: ListTile(
                title: Text(
                  categories[index].title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                leading: categories[index].icon,
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your main balance',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            "45.500,12",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Details >',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                '4.5%',
                style: TextStyle(fontSize: 14, color: Colors.green.shade400),
              ),
            ],
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
                'Good Morning',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'David Kowaiski',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                child: Image.asset(
                  'assets/images/user.png',
                  fit: BoxFit.cover,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
