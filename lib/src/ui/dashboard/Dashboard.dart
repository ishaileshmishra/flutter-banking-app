import 'package:alok/src/network/service.dart';
import 'package:alok/src/services/Service.dart';
import 'package:alok/src/ui/login/Components.dart';
import 'package:alok/src/ui/options/AdmnOne.dart';
import 'package:alok/src/ui/options/AdmnTwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// https://bitbucket.org/potondev/flutterhomescreen_01/src/master/
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final categories = Reposit.getCategories();
  @override
  Widget build(BuildContext context) {
    //final orientation = MediaQuery.of(context).orientation;
    //final iconURL = 'https://www.seekpng.com/png/detail/357-3576734_dashboard-icon-blue.png';
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            buildAnimatedBackground('Categories'),
            Expanded(
              child: _listView(), //_gridView(orientation, iconURL),
            ),
          ],
        ),
      ),
    );
  }

  ListView _listView() {
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
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: ListTile(
                title: Text(
                  categories[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: categories[index].icon,
              ),
            ),
          );
        });
  }
}
