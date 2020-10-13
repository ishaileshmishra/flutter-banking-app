import 'dart:async';
import 'dart:convert';
import 'package:alok/res.dart';
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
  //headers: {"Content-Type": "application/json"};
  String body = json.encode(data);
  final response = await http.post(Res.registerAPI, body: body);
  if (response.statusCode == 200) {
    Map userMap = json.decode(response.body);
    return SignUpResponse.fromJson(userMap['data']);
  } else {
    return null;
  }
}

// Future<List<StackModel>> getAllStacks(String authToken) async {
//   var res = await http.get(Uri.encodeFull(stackUrl),
//       headers: {"Content-Type": "application/json", "authtoken": authToken});
//   if (res.statusCode == 200) {
//     var data = json.decode(res.body);
//     var rest = data["stacks"] as List;
//     return rest.map<StackModel>((json) => StackModel.fromJson(json)).toList();
//   }
//   //else {
//   //var data = json.decode(res.body);
//   //var rest = data["error_message"];
//   //}
//   return null;
// }

String getCurrentTime() {
  var now = new DateTime.now();
  //var currentInMilliSecodn = now.millisecondsSinceEpoch;
  //return now.toIso8601String();
  return now.millisecondsSinceEpoch.toString();
}
