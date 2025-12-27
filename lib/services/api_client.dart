import 'dart:convert';
import 'dart:developer';
import 'package:expenso/controllers/auth_controller.dart';
import 'package:expenso/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final storage = GetStorage();

  Map<String, String> get _headers {
    // final token = AuthController.instance.token.value;
    // log("header in api_client: $token");
    final token = storage.read("ExpensoAuthToken");
    log("header in api_client: $token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<dynamic> get(String url) async {
    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  Future<dynamic> post(String url, Map body) async {
    final res = await http.post(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  Future<dynamic> delete(String url) async {
    final res = await http.delete(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  dynamic _handleResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      log(res.body);

      return jsonDecode(res.body);
    } else {
      Get.snackbar(
        "Error",
        jsonDecode(res.body)["message"],
        backgroundColor: Colors.red,
      );
      throw Exception(jsonDecode(res.body)["message"]);
    }
  }
}
