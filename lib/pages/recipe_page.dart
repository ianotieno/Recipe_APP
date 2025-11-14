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
    return Column(
      children: [
        _recipeImage(context),
        _recipeDetails(context),
        _recipeInstructions(context),
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
          Text(
            "Cuisine : ${recipe.cuisine}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          Text(
            recipe.name,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            " Prep Time: ${recipe.prepTimeMinutes} Min | Cook Time ${recipe.cookTimeMinutes} Min | ${recipe.rating.toString()} ⭐  ",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          Text(
            " Difficulty : ${recipe.difficulty} | ${recipe.reviewCount} Reviews ",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _recipeInstructions(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children:
            recipe.ingredients.map((i) {
              return Row(children: [
                const Icon(Icons.check_box, size: 16,),
                const SizedBox(width: 8,),
                Text(i, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),)
              ]);
            }).toList(),
      ),
    );
  }
}
