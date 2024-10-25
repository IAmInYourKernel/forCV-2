import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RequestAssistant {
  static Future<Map<String, dynamic>> getRequest(String url) async {
    final response = await get(Uri.parse(url));
    debugPrint(response.statusCode.toString());
    Map<String, dynamic> result = json.decode(response.body);
    debugPrint("GET RESPONSE BODY :: $result");
    return result;
  }

  static Future<Map<String, dynamic>> postRequest(String url, Map data) async {
    Response response = await post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    debugPrint(response.statusCode.toString());
    Map<String, dynamic> result = json.decode(response.body);
    debugPrint("POST RESPONSE BODY :: $result");
    return result;
  }
}
