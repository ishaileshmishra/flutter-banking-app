import 'dart:async';
import 'dart:convert';
import 'package:alok/src/models/LoginModel.dart';
import 'package:http/http.dart' as http;

// Prod and Stag Endpoints
const prodEndpoint = "https://api.contentstack.io/v3";
const stagEndpoint = "https://stag-app.contentstack.com/v3";

// Endpoint app is using currently
const endpoint = prodEndpoint;

// other urls
const loginUrl = "$endpoint/user-session";
const stackUrl = '$endpoint/stacks';
const contentTypeUrl = '$endpoint/content_types?include_count=true';

Future<LoginResponse> fetchLoginResponse(credentials) async {
  final body = json.encode(credentials);
  final response = await http.post(loginUrl,
      headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    Map userMap = json.decode(response.body);
    return LoginResponse.fromJson(userMap['user']);
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

// Future<List<ContentTypes>> getAllContentTypes(
//     String apiKey, String authToken) async {
//   var res = await http.get(Uri.encodeFull(contentTypeUrl), headers: {
//     "Content-Type": "application/json",
//     "api_key": apiKey,
//     "authtoken": authToken
//   });
//   if (res.statusCode == 200) {
//     var data = json.decode(res.body);
//     var rest = data["content_types"] as List;
//     return rest
//         .map<ContentTypes>((json) => ContentTypes.fromJson(json))
//         .toList();
//   }
//   return null;
// }

// Future<List<EntryModel>> getEntries(
//     String contentTypeUid, String apiKey, String authToken) async {
//   var url = "$endpoint/content_types/$contentTypeUid/entries";
//   print("request time for Entries: ${getCurrentTime().toString()}");
//   var res = await http.get(Uri.encodeFull(url), headers: {
//     "Content-Type": "application/json",
//     "api_key": apiKey,
//     "authtoken": authToken
//   });
//   if (res.statusCode == 200) {
//     print("response time for Entries: ${getCurrentTime().toString()}");
//     var data = json.decode(res.body);
//     var rest = data["entries"] as List;
//     return rest.map<EntryModel>((json) => EntryModel.fromJson(json)).toList();
//   }
//   return null;
// }

// Future<dynamic> getEntry(
//     String ctUid, String apiKey, String authToken, String uid) async {
//   var entry;
//   var url =
//       "$endpoint/content_types/$ctUid/entries/$uid?include_content_type=true";
//   print("request time for Entry Fields: ${getCurrentTime().toString()}");
//   var res = await http.get(Uri.encodeFull(url), headers: {
//     "Content-Type": "application/json",
//     "api_key": apiKey,
//     "authtoken": authToken
//   });
//   if (res.statusCode == 200) {
//     print("response time for Entry Fields: ${getCurrentTime().toString()}");
//     var data = json.decode(res.body);
//     entry = data["entry"];
//     entry['schema'] = data["content_type"]['schema'];
//   }
//   return entry;
// }

String getCurrentTime() {
  var now = new DateTime.now();
  //var currentInMilliSecodn = now.millisecondsSinceEpoch;
  //return now.toIso8601String();
  return now.millisecondsSinceEpoch.toString();
}
