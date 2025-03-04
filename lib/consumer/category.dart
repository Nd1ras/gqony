import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Category {
  final int? id;
  final String? name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] as int?, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class CategoryApi {
  static const String baseUrl = 'https://keychen.adanianlabs.io/consumer';

  static Future<List<Category>> getCategory(Category category) async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}/ingredients-categories/'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        return jsonList.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }

  static Future<Category> addCategory(Category category) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}/ingredients-categories/'),
        body: jsonEncode(category.toJson()),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 201) {
        final jsonMap = json.decode(response.body);
        return Category.fromJson(jsonMap);
      } else {
        throw Exception('Failed to add the category');
      }
    } catch (e) {
      throw Exception('Error adding category: $e');
    }
  }

  static Future<Category> editCategory(Category category) async {
    try {
      final response = await http.put(
        Uri.parse('${baseUrl}/ingredients-categories/${category.id}'),
        body: jsonEncode(category.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        return Category.fromJson(jsonMap);
      } else {
        throw Exception('Error updating item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error editing category: $e');
    }
  }

  static Future<void> deleteCategory(int id) async {
    try {
      var response = await http.delete(
        Uri.parse('${baseUrl}/ingredients-categories/${id}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception('Error deleting item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }



  static void handleError(Exception e) {
    if (kDebugMode) {
      print('Error: $e');
    }
  }

  static Map<String, dynamic> toList(Category category) {
    return {
      'category': category.name,
    };
  }
}
