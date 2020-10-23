import 'dart:async';
import 'dart:convert';
import 'package:alok/res.dart';
import 'package:alok/src/models/AccountType.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/models/SignUpResponse.dart';
import 'package:alok/src/models/account_model.dart';
import 'package:alok/src/ui/dashboard/dashboard_page.dart';
import 'package:alok/src/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

fetchLoginResponse(context, credentials) async {
  await http.post(Res.loginAPI, body: credentials).then((response) {
    Map userMap = json.decode(response.body);
    print(userMap);
    if (response.statusCode == 200) {
      showToast(context, userMap['message']);
      if (userMap['success']) {
        LoginResponse loginDetails = LoginResponse.fromJson(userMap['data']);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashBoardScreen(
                      user: loginDetails,
                    )));
      }
    } else {
      showToast(context, userMap['message']);
    }
  }).catchError((onError) {
    showToast(context, 'Failed to login');
  });
}

Future<SignUpResponse> fetchSignUpResponse(data) async {
  //
  String body = json.encode(data);
  final response = await http.post(Res.registerAPI, body: body);
  if (response.statusCode == 200) {
    Map userMap = json.decode(response.body);
    return SignUpResponse.fromJson(userMap['data']);
  } else {
    return null;
  }
}

Future<List<AccountType>> getAllAccountType() async {
  var res = await http.get(
    Uri.encodeFull(Res.accountType),
  );
  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var rest = data["data"] as List;
    return rest.map<AccountType>((json) => AccountType.fromJson(json)).toList();
  }
  return null;
}

Future uploadFileWithFields(_scaffoldKey, data, multipartFileSign) async {
  var postUri = Uri.parse(Res.createAccount);
  var request = new http.MultipartRequest("POST", postUri);
  request.fields.addAll(data);
  print('KEYS ${request.fields.keys}\nValues ${request.fields.values}');
  request.files.add(multipartFileSign);
  print("Uploading in progress...");
  request.send().then((response) {
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        var data = json.decode(value);
        print('data: ${data['message']}');
      });
    } else {
      response.stream.bytesToString().catchError((onError) {
        print(onError.toString());
        return onError.toString();
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Failed to Upload..!!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 5),
      ));
    }
  });
}

Future fetchAccountFor(url) async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Map userMap = json.decode(response.body);
    var rest = userMap["data"] as List;
    return userMap['success']
        ? rest.map<AccountModel>((json) => AccountModel.fromJson(json)).toList()
        : null;
  } else {
    return null;
  }
}
