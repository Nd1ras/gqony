import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'add_ingredients.dart';
import 'add_dishes.dart';
import 'schedule.dart';
import 'registration.dart';
import 'menu.dart';
import '../consumer/ingredients.dart';
//import '../resource/nav.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final IngredientsApi ingredientsApi = IngredientsApi();
  FutureBuilder<List<Ingredient>> _buildIngredientFutureBuilder(
      BuildContext context) {
    return FutureBuilder<List<Ingredient>>(
      future: IngredientsApi.getIngredients(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Something went wrong: ${snapshot.error}'));
        } else {
          List<Ingredient> ingredients = snapshot.data!;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromARGB(255, 75, 75, 75), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildCarouselItem(ingredients),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orangeAccent),
              child: Text('Welcome'),
            ),
            ListTile(
              title: const Text('Ingredients'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddIngredients(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Dishes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddDishes(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Schedule'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SchedulePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Menu'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MenuPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: IconButton(
                  icon: const Icon(Ionicons.notifications),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: IconButton(
                  icon: const Icon(Ionicons.ellipsis_vertical),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Material(
            child: Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  // to kitchen mgmt screen
                },
                child: Container(
                  width: 50,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1556911220-bff31c812dba?q=80&w=1268&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Kitchen Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildIngredientFutureBuilder(context),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(List<Ingredient> ingredients) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ingredients.map((ingredient) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ingredient.name,
                style: const TextStyle(
                    fontSize: 12.0, fontWeight: FontWeight.w400),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
