import 'package:flutter/material.dart';
import 'package:recepies/models/recipe.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  RecipePage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(centerTitle: true, title: const Text('Recipe Details')),
      body: SafeArea(child: _buildUI(context)),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Column(children: [_recipeImage(context), _recipeDetails(context)]);
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

  _recipeDetails(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(16.0),

      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: [
            Text("${recipe.cuisine}, ${recipe.difficulty}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ) 
            ),
            Text(recipe.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ) 
            ),
       ],
      ),
    );
  }
}
