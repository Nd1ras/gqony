import 'package:flutter/material.dart';
import 'package:gqony/resource/meal_option.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: FloatingActionButton.extended(
                heroTag: 'menu',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MealOption()));
                  },
                  label: Text('Create Menu')),
            )));
  }
}
