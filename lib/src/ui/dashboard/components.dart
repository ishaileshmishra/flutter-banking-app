// dashboard components
import 'package:alok/res.dart';
import 'package:alok/src/ui/agent/DepositAmount.dart';
import 'package:alok/src/ui/user/CreateAccountPage.dart';
import 'package:alok/src/ui/user/DepositAmount.dart';
import 'package:alok/src/utils/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///show logout dialog when user icon tapped
///
showAlertConfirmLogout(context) async {}

get greeting {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  }
  if (hour < 17) {
    return 'Good Afternoon';
  }
  return 'Good Evening';
}

var textStyleGreeting = TextStyle(
  fontSize: 14,
  color: Colors.grey.shade300,
  fontWeight: FontWeight.bold,
);

var textStyleUser = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

Container renderActionbar(context, username) {
  return Container(
    padding: EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [abColumn(username), abRow()],
    ),
  );
}

Column abColumn(username) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(greeting, style: textStyleGreeting),
      SizedBox(height: 2),
      Text(username, style: textStyleUser)
    ],
  );
}

Row abRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [myAppBarIcon(), SizedBox(width: 10), UserIcon()],
  );
}

class UserIcon extends StatelessWidget {
  const UserIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Res.accentColor,
      child: Icon(
        CupertinoIcons.person,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}

ListView listView(role, categories) {
  return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _decideToViewScreen(context, role, index),
          child: Card(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 3,
            ),
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

_decideToViewScreen(context, role, int index) {
  if (role == 'agent') {
    viewAgentDepositScreen(context);
  } else {
    index == 0
        ? viewUserCreateAccountScreen(context)
        : viewUserDepositScreen(context);
  }
}

viewAgentDepositScreen(context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepositeAmount(),
      ));
}

viewUserDepositScreen(context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepositeAmountScreen(),
      ));
}

viewUserCreateAccountScreen(context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNewAccountPage(),
      ));
}

Card btnCardView({titleTitle: String}) {
  return Card(
    elevation: 0,
    child: Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.supervised_user_circle_outlined,
            color: Res.accentColor,
          ),
          SizedBox(width: 6),
          Text(
            titleTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
