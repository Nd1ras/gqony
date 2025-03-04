import 'package:flutter/material.dart';
import 'package:gqony/consumer/ingredients.dart';
import '../consumer/category.dart';
import 'package:gqony/resource/modal.dart';

class AddIngredients extends StatefulWidget {
  const AddIngredients({super.key});

  @override
  _AddIngredientsState createState() => _AddIngredientsState();
}

class _AddIngredientsState extends State<AddIngredients> {
  late Future<List<Ingredient>> _ingredientFuture;
  late Future<List<Category>> _categoryFuture;
  List<Ingredient> ingredients = [];
  final IngredientsApi ingredientsApi = IngredientsApi();
  
  Category get category => String;

  @override
  void initState() {
    super.initState();
    _ingredientFuture = IngredientsApi.getIngredients();
    _categoryFuture = _loadCategories();
  }

  Future<List<Category>> _loadCategories() async {
    try {
      List<Category> categories = await CategoryApi.getCategory(category);
      return categories;
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredients'),
      ),
      body: FutureBuilder<List<Ingredient>>(
        future: _ingredientFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  'An error occurred while loading ingredients: ${snapshot.error}'),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final ingredients = snapshot.data!;
              return ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index];
                  return ListTile(
                    title: Text(ingredient.name),
                    subtitle: Text(ingredient.unit),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 30, 30, 30),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: EditIngredientModal(
                                  id: ingredient.id,
                                  name: ingredient.name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddIngredientsPage(),
            ),
          );

          if (result != null) {
            try {
              final ingredientMap = result as Map<String, dynamic>;
              final addedIngredient = await IngredientsApi.addIngredient(
                  Ingredient(
                      id: ingredientMap['id'] as int,
                      category: ingredientMap['category'] as int,
                      name: ingredientMap['name'] as String,
                      unit: ingredientMap['unit'] as String));
              setState(() {
                ingredients.add(addedIngredient);
                _ingredientFuture = IngredientsApi.getIngredients();
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to add ingredient'),
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

class AddIngredientsPage extends StatefulWidget {
  const AddIngredientsPage({super.key});

  @override
  _AddIngredientsPageState createState() => _AddIngredientsPageState();
}

class _AddIngredientsPageState extends State<AddIngredientsPage> {
  final _formKey = GlobalKey<FormState>();
  int? _category;
  String? _name;
  String? _unit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ingredient'),
      ),
      body: FutureBuilder<List<Category>>(
        future: _loadCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading categories: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final categories = snapshot.data!;
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      items: categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _category = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
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
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Unit'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a unit';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _unit = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final ingredient = Ingredient(
                              id: 0,
                              category: _category!,
                              name: _name!,
                              unit: _unit!);
                          /*final category = Category(
                        id: _category,
                        name: _name!,
                      );
                      */
                          try {
                            final addedIngredient =
                                await IngredientsApi.addIngredient(ingredient);
                            final int generatedId = addedIngredient.id;
                            final addedCategory =
                                await CategoryApi.addCategory(category);
                            Navigator.pop(context, {
                              'id': generatedId,
                              'category': _category,
                              'name': addedIngredient.name,
                              'unit': addedIngredient.unit,
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to add ingredient'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Add Ingredient'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No categories available'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
