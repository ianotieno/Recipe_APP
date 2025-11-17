import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recepies/consts.dart';

// Update your HTTPService to include bearer token
class HTTPService {
  static final HTTPService _singleton = HTTPService._internal();
  final _dio = Dio();
  String? _bearerToken;

  factory HTTPService() {
    return _singleton;
  }

  HTTPService._internal() {
    setup();
  }

  Future<void> setup({String? bearerToken}) async {
    _bearerToken = bearerToken;
    
    final headers = {
      "Content-Type": "application/json",
      if (bearerToken != null) "Authorization": "Bearer $bearerToken",
    };

    final options = BaseOptions(
      headers: headers,
      baseUrl: API_BASE_URL,
      validateStatus: (status) {
        if (status == null) return false;
        return status < 500;
      },
    );
    _dio.options = options;
  }

  void setToken(String token) {
    _bearerToken = token;
    setup(bearerToken: token);
  }

  Future<Response?> post(String path, Map data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}