// pages/add_recipe_page.dart
import 'package:flutter/material.dart';
import 'package:recepies/models/recipe.dart';
import 'package:recepies/services/auth_service.dart';
import 'package:recepies/services/data_service.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _dataService = DataService();

  // Controllers
  final _nameController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _imageController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _tagsController = TextEditingController();

  String _difficulty = 'Medium';
  final List<String> _selectedMealTypes = ['dinner'];
  final List<String> _availableMealTypes = ['breakfast', 'lunch', 'dinner', 'snack', 'dessert'];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cuisineController.dispose();
    _imageController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _caloriesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final currentUser = AuthService().getCurrentUser();
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to add a recipe')),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    final newRecipe = Recipe(
      id: 0, // will be assigned by backend
      name: _nameController.text.trim(),
      cuisine: _cuisineController.text.trim(),
      image: _imageController.text.trim().isEmpty ? "https://via.placeholder.com/300" : _imageController.text.trim(),
      difficulty: _difficulty,
      prepTimeMinutes: int.parse(_prepTimeController.text),
      cookTimeMinutes: int.parse(_cookTimeController.text),
      servings: int.parse(_servingsController.text),
      caloriesPerServing: int.tryParse(_caloriesController.text) ?? 0,
      ingredients: _ingredientsController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      instructions: _instructionsController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      tags: _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      mealType: _selectedMealTypes,
      userId: currentUser.id, // from logged-in user
      rating: 0.0,
      reviewCount: 0,
    );

    try {
      final addedRecipe = await _dataService.addRecipe(newRecipe);

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (addedRecipe != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // success
      } else {
        _showError('Failed to add recipe. Please try again.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Network error. Check your connection.');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Recipe'),
        backgroundColor: const Color(0xFF8F4C39),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Recipe Name *', border: OutlineInputBorder()),
                validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Cuisine
              TextFormField(
                controller: _cuisineController,
                decoration: const InputDecoration(labelText: 'Cuisine * (e.g. Italian, Mexican)', border: OutlineInputBorder()),
                validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Image URL
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'Leave empty for placeholder',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Meal Type (Multi-select chips)
              const Align(alignment: Alignment.centerLeft, child: Text('Meal Type *', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _availableMealTypes.map((type) {
                  final isSelected = _selectedMealTypes.contains(type);
                  return ChoiceChip(
                    label: Text(type[0].toUpperCase() + type.substring(1)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF8F4C39),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedMealTypes.add(type);
                        } else {
                          _selectedMealTypes.remove(type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              if (_selectedMealTypes.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Select at least one meal type', style: TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 16),

              // Difficulty
              DropdownButtonFormField<String>(
                value: _difficulty,
                decoration: const InputDecoration(labelText: 'Difficulty', border: OutlineInputBorder()),
                items: ['Easy', 'Medium', 'Hard']
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _difficulty = v!),
              ),
              const SizedBox(height: 16),

              // Time & Servings & Calories
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _prepTimeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Prep Time (mins) *', border: OutlineInputBorder()),
                      validator: (v) => v == null || int.tryParse(v) == null || int.parse(v) <= 0 ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cookTimeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Cook Time (mins) *', border: OutlineInputBorder()),
                      validator: (v) => v == null || int.tryParse(v) == null || int.parse(v) <= 0 ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _servingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Servings *', border: OutlineInputBorder()),
                      validator: (v) => v == null || int.tryParse(v) == null || int.parse(v) <= 0 ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Calories per serving', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Ingredients
              TextFormField(
                controller: _ingredientsController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Ingredients (one per line) *',
                  hintText: '2 cups all-purpose flour\n1 tsp salt\n4 eggs',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Instructions
              TextFormField(
                controller: _instructionsController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Instructions (one step per line) *',
                  hintText: '1. Preheat oven to 180°C\n2. Mix dry ingredients\n...',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Tags (comma separated)
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  hintText: 'vegetarian, spicy, quick',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F4C39),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading ? null : _submitRecipe,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Recipe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}