import 'package:flutter/material.dart';
import 'package:recepies/models/recipe.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  RecipePage({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, 
      title: const Text('Recipe Details')),
      body: SafeArea(
        child: _buildUI(context),
      ),
    );
   
  }
   Widget _buildUI(BuildContext context) {
      return  Column(
        children: [
          _recipeImage( context),
        ],
      );
    }
    _recipeImage(BuildContext context) {
      return Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.40,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(recipe.image),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
}