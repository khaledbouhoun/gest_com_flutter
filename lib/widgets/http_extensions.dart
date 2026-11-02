// http_extensions.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';

extension AuthWebRequest on String {
  Future<http.Response> authPost(BuildContext context, dynamic body) async {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    var webRequest = await http
        .post(
          Uri.parse('${auth.baseUrl}$this'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(Duration(minutes: 2));

    print('[Post]Request URL: ${auth.baseUrl}$this');
    print('[Post]Request Body: ${jsonEncode(body)}');
    print('[Post]Response Status Code: ${webRequest.statusCode}');
    print('[Post]Response Body: ${webRequest.body}');

    return webRequest;
  }
}
