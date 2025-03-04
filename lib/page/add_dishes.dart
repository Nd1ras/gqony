import 'package:flutter/material.dart';
//import 'dart:developer';
import 'package:gqony/consumer/dishes.dart';

class AddDishes extends StatefulWidget {
  const AddDishes({super.key});

  @override
  _AddDishesState createState() => _AddDishesState();
}

class _AddDishesState extends State<AddDishes> {
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
        title: const Text('Dishes'),
      ),
      body: FutureBuilder<List<DishModel>>(
        future: _dishesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('An error occurred: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dishesData = dishesApi.getDishes();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final dishes = snapshot.data!;
            return ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes[index];
                return ListTile(
                  leading: dish.image != null
                      ? Image.network(dish.image!)
                      : const SizedBox(),
                  title: Text(dish.name),
                  subtitle: dish.description != null
                      ? Text(dish.description!)
                      : const SizedBox(),
                  trailing: Text('Ksh${dish.price}'),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDishesPage(),
            ),
          );

          if (result != null) {
            try {
              final newDish = result as Map<String, dynamic>;
              final addedDish = await dishesApi.addDish(DishModel(
                name: newDish['name'],
                description: newDish['description'],
                price: newDish['price'],
                // image: '',
              ));

              setState(() {
                dishes.add(addedDish);
                _dishesData = dishesApi.getDishes();
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to add dish'),
                ),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddDishesPage extends StatefulWidget {
  const AddDishesPage({super.key});

  @override
  _AddDishesPageState createState() => _AddDishesPageState();
}

class _AddDishesPageState extends State<AddDishesPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _description;
  double? _price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Dish'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Name'),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Description'),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Describe the dish';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Price'),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.tryParse(value!);
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final dish = DishModel(
                          name: _name!,
                          description: _description!,
                          price: _price!);
                      try {
                        final addedDish = await DishesApi().addDish(dish);
                        Navigator.pop(context, {
                          'name': addedDish.name,
                          'description': addedDish.description,
                          'price': addedDish.price,
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to add dish'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Add Dish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
