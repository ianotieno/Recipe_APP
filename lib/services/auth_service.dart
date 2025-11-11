

import 'package:flutter/material.dart';
import 'package:recepies/services/http_service.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();

  final _httpService = HTTPService();

  factory AuthService() {
    return _singleton;
  }
  AuthService._internal();

  Future<bool> login(String username, String password) async {
    try{
 var response = await _httpService.post('auth/login', {
      "username": username,
      "password": password,
    });
    print(response?.statusCode);
    }catch(e){
      print(e);
    }
    return false;
  }
}
