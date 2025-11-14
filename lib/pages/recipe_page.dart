import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, 
      title: const Text('Recipe Details')),
      body: SafeArea(
        child: _buildUI(),
      ),
    );
   
  }
   Widget _buildUI() {
      return  Column(
        children: const [
          
        ],
      );
    }
}