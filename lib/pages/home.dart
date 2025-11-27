import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:recepies/models/recipe.dart';
import 'package:recepies/pages/addRecipePage.dart';
import 'package:recepies/pages/favoritesPage.dart';
import 'package:recepies/pages/recipe_page.dart';
import 'package:recepies/pages/settings.dart';
import 'package:recepies/services/data_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _mealTypeFilter = "";
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomeContent(), // We'll extract the home content to a separate widget
    const FavoritesPage(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), 
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: const Key('curved_nav'),
        backgroundColor: Colors.transparent,
        color: const Color(0xFF8F4C39),
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF8F4C39),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddRecipePage()),
                );

                // ← If a recipe was successfully added → refresh the list
                
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Recipe added!"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              
          ): null, // Hide FAB on other tabs (optional but cleaner)
    );
    
  }

  AppBar _buildAppBar() {
    String title;
    switch (_currentIndex) {
      case 0:
        title = 'Recipe Book';
        break;
      case 1:
        title = 'Favorites';
        break;
      case 2:
        title = 'Settings';
        break;
      default:
        title = 'Recipe Book';
    }

    return AppBar(
      centerTitle: true,
      title: Text(title),
      titleTextStyle: TextStyle(
        color: const Color(0xFF8F4C39),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Extract home content to a separate widget
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _mealTypeFilter = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _recipeTypeButtons(),
            _recipesList(),
          ],
        ),
      ),
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
              onPressed: () {
                setState(() {
                  _mealTypeFilter = "";
                });
              },
              child: const Text('🍱 All'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FilledButton(
              onPressed: () {
                setState(() {
                  _mealTypeFilter = "snack";
                });
              },
              child: const Text('🥕 Snacks'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FilledButton(
              onPressed: () {
                setState(() {
                  _mealTypeFilter = "breakfast";
                });
              },
              child: const Text('🍳 Breakfast'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FilledButton(
              onPressed: () {
                setState(() {
                  _mealTypeFilter = "lunch";
                });
              },
              child: const Text('🥩 Lunch'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FilledButton(
              onPressed: () {
                setState(() {
                  _mealTypeFilter = "dinner";
                });
              },
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
        future: DataService().getRecipes(_mealTypeFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No recipes found'));
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: Colors.grey,
            ),
            itemBuilder: (context, index) {
              Recipe recipe = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipePage(recipe: recipe),
                    ),
                  );
                },
                isThreeLine: true,
                subtitle: Text(
                  '${recipe.cuisine}  | Difficulty: ${recipe.difficulty}\n'
                  'Prep Time: ${recipe.prepTimeMinutes} mins | Servings: ${recipe.servings}',
                ),
                trailing: Text(
                  "${recipe.rating.toString()} ⭐",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                leading: Image.network(
                  recipe.image!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image);
                  },
                ),
                title: Text(
                  recipe.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}