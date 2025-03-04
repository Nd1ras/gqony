import 'package:flutter/material.dart';
import '../consumer/ingredients.dart';

class EditIngredientModal extends StatefulWidget {
  final int? id;
  final String name;

  const EditIngredientModal({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  _EditIngredientModalState createState() => _EditIngredientModalState();
}

class _EditIngredientModalState extends State<EditIngredientModal> {
  late TextEditingController _textEditingController;
  late List<Ingredient> _ingredients;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.name);
    _ingredients = [];
    _loadIngredients();
  }

  void _loadIngredients() async {
    try {
      final ingredients = await IngredientsApi.getIngredients();
      setState(() {
        _ingredients = ingredients;
      });
    } catch (e) {
      throw Exception('Error loading ingredients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Edit Entry',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final updatedIngredient = await IngredientsApi.editIngredient(
                    Ingredient(
                      id: widget.id,
                      category: int.parse(_textEditingController.text),
                      name: _textEditingController.text,
                      unit: '',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ingredient updated successfully'),
                    ),
                  );

                  setState(() {
                    _ingredients = _ingredients.map((ingredient) {
                      if (ingredient.id == updatedIngredient.id) {
                        return updatedIngredient;
                      } else {
                        return ingredient;
                      }
                    }).toList();
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error editing ingredient: $e'),
                    ),
                  );
                }
              },
              child: Text('Edit'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  await IngredientsApi.deleteIngredient(widget.id as int);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ingredient deleted successfully'),
                    ),
                  );

                  setState(() {
                    _ingredients.removeWhere(
                        (ingredient) => ingredient.id == widget.id);
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting ingredient: $e'),
                    ),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
