import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:developer' as dev;

import 'package:shared_preferences/shared_preferences.dart';

class UserAgentClient extends http.BaseClient {
  final http.Client _httpClient = http.Client();
  SharedPreferences prefs;

  UserAgentClient({required this.prefs});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'App-Version': '1.0.0',
      'Authorization': 'token ${prefs.getString('token')}',
    };
    request.headers.addAll(requestHeaders);
    dev.log("Request: $request");
    return _httpClient.send(request);
  }

  Future<http.StreamedResponse> multipart(
      Uri endPoint, Map<String, String> fields, File file) {
    var request = http.MultipartRequest('POST', endPoint);
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'Accept': 'application/json',
      'App-Version': '1.0.0',
      'Authorization': 'token ${prefs.getString('token')}'
    };
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    request.files.add(
      http.MultipartFile(
        'image',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: "${generateRandomString(15)}.jpg",
        contentType: MediaType('image', 'jpg'),
      ),
    );
    dev.log(request.files.toString());
    return _httpClient.send(request);
  }
}

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
