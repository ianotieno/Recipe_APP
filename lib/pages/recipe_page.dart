import 'package:flutter/material.dart';
import 'package:recepies/models/recipe.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  const RecipePage({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Recipe Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. FIXED IMAGE (does NOT scroll)
          _recipeImage(context),

          // 2. SCROLLABLE TEXT CONTENT
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _recipeDetails(context),
                  _recipeIngredients(context),
                  _recipeInstructions(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------
  // 1. Fixed Image (full width, fixed height)
  // -------------------------------------------------
  Widget _recipeImage(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.30,
      child: Image.network(
        recipe.image,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error, color: Colors.red));
        },
      ),
    );
  }

  // -------------------------------------------------
  // 2. Recipe Details
  // -------------------------------------------------
  Widget _recipeDetails(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cuisine : ${recipe.cuisine}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
          const SizedBox(height: 4),
          Text(recipe.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            "Prep Time: ${recipe.prepTimeMinutes} Min | "
            "Cook Time ${recipe.cookTimeMinutes} Min | "
            "${recipe.rating.toString()} ⭐",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 4),
          Text(
            "Difficulty : ${recipe.difficulty} | ${recipe.reviewCount} Reviews",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------
  // 3. Ingredients (Numbered)
  // -------------------------------------------------
  Widget _recipeIngredients(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ingredients",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...recipe.ingredients.asMap().entries.map((entry) {
            int idx = entry.key + 1;
            String item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 32,
                    child: Text("$idx.",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // -------------------------------------------------
  // 4. Instructions (Numbered)
  // -------------------------------------------------
  Widget _recipeInstructions(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Instructions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...recipe.instructions.asMap().entries.map((entry) {
            int idx = entry.key + 1;
            String step = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 32,
                    child: Text("$idx.",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(step,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5)),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}