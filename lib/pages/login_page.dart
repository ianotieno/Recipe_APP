import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Login Page')),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
     children: [
      _title(),
      _loginForm(),
    ],
  );
  }
  Widget _title(){
    return const Text(
      'Welcome to Recipe App',
      style: TextStyle(
        fontSize: 24,

        fontWeight: FontWeight.bold,
      ),
    );
  }
  Widget _loginForm(){
    return  SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.30,
      child: Form(child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            
          ),
          const SizedBox(height: 20),
          TextFormField(
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
      )),
    );

  }

  Widget _loginButton(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.60,
      child:ElevatedButton(
      onPressed: () {
        // Handle login logic here
      },
      child: const Text('Login'),
    ));
  }
  Widget _forgotPasswordButton(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.60,
      child: TextButton(
      onPressed: () {
        // Handle forgot password logic here
      },
      child: const Text('Forgot Password?'),
    ));
  }
}
