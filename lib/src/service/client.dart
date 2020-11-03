import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient extends http.BaseClient {
  final http.Client _client;
  final Map<String, String> headers;

  factory HttpClient(Map<String, String> headers) {
    final client = http.Client();
    return HttpClient._internal(client, headers);
  }

  HttpClient._internal(this._client, this.headers);

  @override
  void close() => _client.close();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }

  Future<T> sendRequest<T, K>(Uri uri) async {
    headers['Content-Type'] = 'application/json';
    headers['X-User-Agent'] = 'contentstack-dart/0.1.1';
    final response = await http.get(uri, headers: headers);
    Object bodyJson;
    try {
      bodyJson = jsonDecode(response.body);
    } on FormatException {
      final contentType = response.headers['content-type'];
      if (contentType != null && !contentType.contains('application/json')) {
        throw Exception(
            "Returned value was not JSON. Did the uri end with '.json'?");
      }
      rethrow;
    }
    if (response.statusCode == 200) {
      final Map bodyJson = jsonDecode(response.body);
      if (bodyJson['success'] && bodyJson.containsKey('data')) {
        return fromJson<T, K>(bodyJson['data']);
      } else {
        return fromJson<T, K>(bodyJson);
      }
    } else {
      return bodyJson;
    }
  }

  /// generic objects as well as List of generic objects
  /// (from a JSON list response).
  /// First, you need to have a function that checks the type  of the
  /// generic object and returns the result of the corresponding fromJson call
  /// code taken from:
  /// https://stackoverflow.com/questions/56271651/how-to-pass-a-generic-type-as-a-parameter-to-a-future-in-flutter
  static T fromJson<T, K>(dynamic json) {
    if (json is Iterable) {
      return _fromJsonList<K>(json) as T;
      // } else if (T == ErrorResponse) {
      //   return AssetModel.fromJson(json) as T;
      // } else if (T == EntryModel) {
      //   return EntryModel.fromJson(json) as T;
      // } else if (T == SyncResult) {
      //   return SyncResult.fromJson(json) as T;
      // }
    } else {
      return json;
    }
  }

  static List<K> _fromJsonList<K>(List jsonList) {
    if (jsonList == null) {
      return null;
    }

    final output = <K>[];
    for (Map<String, dynamic> json in jsonList) {
      output.add(fromJson(json));
    }
    return output;
  }
}
