import 'package:flutter/material.dart';
import 'package:recepies/pages/login_page.dart';

void main() {
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange,
      ),
       useMaterial3: true,
       appBarTheme:const AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.white,
          backgroundColor: Colors.deepOrange,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
       )
      
    ),
    home: LoginPage(),
    );
  }
  
}