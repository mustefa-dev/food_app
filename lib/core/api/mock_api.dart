import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MockApi {
  Future<List<Map<String, dynamic>>> restaurants() async {
    final s = await rootBundle.loadString('assets/mock/restaurants.json');
    final List data = jsonDecode(s);
    return data.cast<Map>().map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
  Future<Map<String, dynamic>> menu(String id) async {
    final s = await rootBundle.loadString('assets/mock/menus/$id.json');
    return (jsonDecode(s) as Map).cast<String, dynamic>();
  }
  Future<Map<String, dynamic>> user() async {
    final s = await rootBundle.loadString('assets/mock/user.json');
    return (jsonDecode(s) as Map).cast<String, dynamic>();
  }
  Future<List<Map<String, dynamic>>> orders() async {
    final s = await rootBundle.loadString('assets/mock/orders.json');
    final List data = jsonDecode(s);
    return data.cast<Map>().map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
