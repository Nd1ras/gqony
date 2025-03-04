import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
//import 'category.dart';

class Ingredient {
  final int? id;
  final int category;
  final String name;
  final String unit;

  Ingredient(
      {required this.id,
      required this.category,
      required this.name,
      required this.unit});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        id: json['id'] as int?,
        category: json['category'] as int,
        name: json['name'],
        unit: json['unit']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'unit': unit,
    };
  }
}

class IngredientsApi {
  static const String baseUrl = 'https://keychen.adanianlabs.io/consumer';

  static Future<List<Ingredient>> getIngredients() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}/ingredients/'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        return jsonList.map((json) => Ingredient.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load ingredients. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load ingredients: $e');
    }
  }

  static Future<Ingredient> addIngredient(Ingredient ingredient) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}/ingredients/'),
        body: jsonEncode(ingredient.toJson()),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 201) {
        final jsonMap = json.decode(response.body);
        return Ingredient.fromJson(jsonMap);
      } else {
        throw Exception('Failed to add the ingredient');
      }
    } catch (e) {
      throw Exception('Error adding ingredient: $e');
    }
  }

  static Future<Ingredient> editIngredient(Ingredient ingredient) async {
    try {
      final response = await http.put(
        Uri.parse('${baseUrl}/ingredients/${ingredient.id}'),
        body: jsonEncode(ingredient.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        return Ingredient.fromJson(jsonMap);
      } else {
        throw Exception('Error updating item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error editing ingredient: $e');
    }
  }

  static Future<void> deleteIngredient(int id) async {
    try {
      var response = await http.delete(
        Uri.parse('${baseUrl}/ingredients/${id}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception('Error deleting item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting ingredient: $e');
    }
  }

  static void handleError(Exception e) {
    if (kDebugMode) {
      print('Error: $e');
    }
  }

  static Map<String, dynamic> toJson(Ingredient ingredient) {
    return {
      'name': ingredient.name,
      'unit': ingredient.unit,
    };
  }
}
