import 'package:alok/src/ui/login/Components.dart';
import 'package:alok/src/ui/options/AdmnOne.dart';
import 'package:alok/src/ui/options/AdmnTwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final iconURL =
        'https://www.seekpng.com/png/detail/357-3576734_dashboard-icon-blue.png';
    return Scaffold(
      body: Container(
        //padding: EdgeInsets.only(left: 8, right: 8, top: 40),
        child: Column(
          children: [
            buildAnimatedBackground('Dashboard'),
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 2 : 3),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                        index == 0
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminOne()),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminTwo()),
                              )
                      },
                      child: Card(
                        elevation: 5,
                        child: GridTile(
                          footer: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Option $index",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          child: Image.network(
                            iconURL,
                            fit: BoxFit.cover,
                          ), //just for testing, will fill with image later
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
