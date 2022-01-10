import 'dart:convert';

import 'package:http/http.dart' as http;

String _baseUrl = "https://fisikamu.xyz";
getAPI(String _url) async {
  final response = await http.get(Uri.parse(_baseUrl + _url));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return [];
  }
}

getAPIbyParam(String _url, String _param) async {
  final response = await http.get(Uri.parse(_baseUrl + _url + _param));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return [];
  }
}

postAPI(String _url, Map<String, String> data) async {
  final response = await http.post(Uri.parse(_baseUrl + _url), body: data);
  // print('Response status: ${response.statusCode}');main
  // print('Response body: ${response.body}');main
  return response;
}

putAPI(String url, Map<String, String> data) async {
  final response = await http.put(Uri.parse(_baseUrl + url), body: data);
  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');
  return response;
}
