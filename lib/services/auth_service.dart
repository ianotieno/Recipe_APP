import 'package:flutter/material.dart';
import 'package:recepies/models/user.dart';
import 'package:recepies/services/http_service.dart';


class AuthService {
  static User? _currentUser;
  
  Future<bool> login(String username, String password) async {
    try {
      // Your existing login logic
      final response = await HTTPService().post('/auth/login', {
        'username': username,
        'password': password,
      });

      if (response?.statusCode == 200) {
        // Parse user data from response
        _currentUser = User.fromJson(response!.data);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  Future<void> logout() async {
    _currentUser = null;
  }
}