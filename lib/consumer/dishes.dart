import 'dart:convert';
import 'package:http/http.dart' as http;

class DishModel {
  final String name;
  final String? description;
  final String? image;
  final double price;

  DishModel(
      {required this.name, this.description, this.image, required this.price});

  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      name: json['dish_name'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'price': price,
    };
  }
}

class DishesApi {
  final String baseUrl = 'https://keychen.adanianlabs.io/consumer/dishes/';

  Future<List<DishModel>> getDishes() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => DishModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load dishes');
    }
  }

  Future<DishModel> addDish(DishModel dish) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      body: jsonEncode(dish.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 201) {
      return DishModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add dish');
    }
  }

  Future<void> deleteDish(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete dish');
    }
  }
}
