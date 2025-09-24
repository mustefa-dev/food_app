import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/models.dart';

class DemoLoader {
  static Future<Restaurant> loadRestaurant() async {
    final raw = await rootBundle.loadString('assets/data/demo_restaurant.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return Restaurant.fromJson(json);
  }
}
