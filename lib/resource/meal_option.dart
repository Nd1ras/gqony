import 'package:flutter/material.dart';
import '../page/meal_time.dart';

class MealOption extends StatefulWidget {
  const MealOption({super.key});

  @override
  State<MealOption> createState() => _MealOptionState();
}

class _MealOptionState extends State<MealOption> {
  final List<String> mealOptions = [
    'breakfast',
    'lunch',
    'snack',
    'happy hour',
    'dinner'
  ];
  final List<String> selectedMealOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'menu',
              child: const Text(
                "What do you serve?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: mealOptions.map((mealOption) {
                final isSelected = selectedMealOptions.contains(mealOption);
                return ChoiceChip(
                  label: Text(mealOption),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedMealOptions.add(mealOption);
                      } else {
                        selectedMealOptions.remove(mealOption);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedMealOptions.map((mealOption) {
                return Chip(
                  label: Text(mealOption),
                  onDeleted: () {
                    setState(() {
                      selectedMealOptions.remove(mealOption);
                    });
                  },
                  deleteIcon: const Icon(Icons.cancel),
                  deleteIconColor: Colors.red,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Meals: ${selectedMealOptions.join(', ')}',
              style: const TextStyle(fontSize: 16),
            ),
            FloatingActionButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MealTime(
                        selectedMeals: selectedMealOptions,
                      ),
                    ),
                  );
                },
                child: Text('Next')),
          ],
        ),
      ),
    );
  }
}
