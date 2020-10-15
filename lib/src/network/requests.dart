import 'dart:async';
import 'dart:convert';
import 'package:alok/res.dart';
import 'package:alok/src/models/AccountType.dart';
import 'package:alok/src/models/LoginResponse.dart';
import 'package:alok/src/models/SignUpResponse.dart';
import 'package:http/http.dart' as http;

Future<LoginResponse> fetchLoginResponse(credentials) async {
  final body = json.encode(credentials);
  final response = await http.post(Res.loginAPI,
      headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    Map userMap = json.decode(response.body);
    print("Login response: $userMap");
    return LoginResponse.fromJson(userMap['user']);
  } else {
    return null;
  }
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
    print(data);
    var rest = data["data"] as List;
    return rest.map<AccountType>((json) => AccountType.fromJson(json)).toList();
  }
  return null;
}

Future uploadFileWithFields(data, multipartFileSign) async {
  var postUri = Uri.parse(Res.createAccount);
  var request = new http.MultipartRequest("POST", postUri);
  request.fields.addAll(data);
  print('KEYS ${request.fields.keys}\nValues ${request.fields.values}');
  request.files.add(multipartFileSign);
  print("Uploading in progress...");
  //await request.send();

  request.send().then((response) {
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        var data = json.decode(value);
        print('data: ${data['message']}');
        return data['message'];
      });
      return 'Account create successfully done';
    } else {
      response.stream.bytesToString().catchError((onError) {
        print(onError.toString());
        return onError.toString();
      });
      print("Failed to Upload!");
    }
  });
}

String getCurrentTime() {
  var now = new DateTime.now();
  return now.millisecondsSinceEpoch.toString();
}
