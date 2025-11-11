import 'dart:math' as console;

import 'package:flutter/material.dart';
import 'package:recepies/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  String? _username, _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Login Page')),
      body: SafeArea(child: _buildUI()),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_title(), _loginForm()],
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Welcome to Recipe App',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _loginForm() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.90,

      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: 'emilys',
              onSaved: (newValue) {
                setState(() {
                  _username = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              initialValue: 'emilyspass',
              onSaved: (newValue) {
                setState(() {
                  _password = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.length < 3) {
                  return 'Please valid password';
                }
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _loginButton(),
            const SizedBox(height: 20),
            _forgotPasswordButton(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.60,
      child: ElevatedButton(
        onPressed: () async{
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
             bool result = await AuthService().login(_username!, _password!);

            }
        },
        child: const Text('Login'),
      ),
    );
  }

  Widget _forgotPasswordButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.60,
      child: TextButton(
        onPressed: () {
          // Handle forgot password logic here
        },
        child: const Text('Forgot Password?'),
      ),
    );
  }
}
