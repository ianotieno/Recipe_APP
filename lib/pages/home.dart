import 'package:flutter/material.dart';
import 'package:recepies/models/recipe.dart';
import 'package:recepies/services/data_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Recipe Book')),
      body: SafeArea(child: _buildUI()),
    );
  }

  Widget _buildUI() {
    return Container(
      child: Column(children: [_recipeTypeButtons(), _recipesList()]),
    );
  }

  Widget _recipeTypeButtons() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.05,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FilledButton(
              onPressed: () {},
              child: const Text('🥕 Snacks'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FilledButton(
              onPressed: () {},
              child: const Text('🍳 Brdeakfast'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FilledButton(
              onPressed: () {},
              child: const Text('🥩 lunch'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FilledButton(
              onPressed: () {},
              child: const Text('🍗 Dinner'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipesList() {
    return Expanded(
      child: FutureBuilder(
        future: DataService().getRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No recipes found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Recipe recipe = snapshot.data![index];
              return ListTile(
                
                title: Text(recipe.name),);
            },
          );
        },
      ),
    );
  }
}
