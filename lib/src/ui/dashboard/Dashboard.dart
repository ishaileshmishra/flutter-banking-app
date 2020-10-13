import 'package:alok/res.dart';
import 'package:alok/src/network/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// https://bitbucket.org/potondev/flutterhomescreen_01/src/master/
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final categories = Reposit.getCategories();

  Widget _showWelcomeText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text("Welcome\nBack",
            style: TextStyle(fontSize: 30, color: Colors.white),
            textAlign: TextAlign.left),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final orientation = MediaQuery.of(context).orientation;
    //final iconURL = 'https://www.seekpng.com/png/detail/357-3576734_dashboard-icon-blue.png';
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          backgroundColor: Res.accentColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Center(
                  child: _showWelcomeText(),
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

//     Scaffold(
//       body: Container(
//         child: Column(
//           children: [
//             buildAnimatedBackground('Categories'),
//             Expanded(
//               child: _listView(), //_gridView(orientation, iconURL),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ListView _listView() {
//     return ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () => {
//               {
//                 index == 0
//                     ? Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => AdminOne()),
//                       )
//                     : Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => AdminTwo()),
//                       )
//               },
//             },
//             child: Card(
//               margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//               child: ListTile(
//                 title: Text(
//                   categories[index].title,
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//                 leading: categories[index].icon,
//               ),
//             ),
//           );
//         });
//   }
// }
