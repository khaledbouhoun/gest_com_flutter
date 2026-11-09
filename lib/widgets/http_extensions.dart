// http_extensions.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

extension AuthWebRequest on String {
  Future<bool> testserver(AuthViewModel auth) async {
    var server = await http.get(Uri.parse('${auth.baseUrl}/version'));
    return server.statusCode == 200 ? true : false;
  }

  Future<http.Response> authPost(BuildContext context, dynamic body) async {
    AuthViewModel auth = Provider.of<AuthViewModel>(context, listen: false);
    var webRequest = await http
        .post(
          Uri.parse('${auth.baseUrl}$this'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(Duration(seconds: 5));

    print('[Post]Request URL: ${auth.baseUrl}$this');
    print('[Post]Request Body: ${jsonEncode(body)}');
    print('[Post]Response Status Code: ${webRequest.statusCode}');
    print('[Post]Response Body: ${webRequest.body}');

    return webRequest;
  }
}
