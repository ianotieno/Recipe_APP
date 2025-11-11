

import 'package:flutter/material.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  factory AuthService() {
    return _singleton;
  }
  AuthService._internal();

  Future<bool> login(String username, String password) async {
    print( 'Attempting login for user: $username');
    return false;
  }
}
