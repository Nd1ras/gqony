import 'package:flutter/material.dart';
import '../consumer/dishes.dart';

class MealTime extends StatefulWidget {
  final List<String> selectedMeals;

  const MealTime({Key? key, required this.selectedMeals}) : super(key: key);

  @override
  State<MealTime> createState() => _MealTimeState();
}

class _MealTimeState extends State<MealTime> {
  late Future<List<DishModel>> _dishesData;
  List<DishModel> dishes = [];
  final DishesApi dishesApi = DishesApi();

  @override
  void initState() {
    super.initState();
    _dishesData = dishesApi.getDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: FutureBuilder<List<DishModel>>(
          future: _dishesData,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                  itemCount: widget.selectedMeals.length,
                  itemBuilder: (context, index) {
                    final dish = dishes[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedMeals[index],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _dishesData = dishesApi.getDishes();
                            });
                          },
                          title: Text(dish.name),
                          subtitle: Text('.......................'),
                          trailing: Text('Ksh${dish.price}'),
                        ),
                      ],
                    );
                  }),
            );
          }),
    );
  }
}
