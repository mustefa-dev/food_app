import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  static const _autoOpen='auto_open_last', _lastRestaurant='last_restaurant';
  static Future<void> init() async { await Hive.initFlutter(); await Hive.openBox('restaurants'); await Hive.openBox('menus'); await Hive.openBox('orders'); await Hive.openBox('favorites'); }
  static Box get restaurantsBox => Hive.box('restaurants');
  static Box get menusBox => Hive.box('menus');
  static Box get ordersBox => Hive.box('orders');
  static Box get favoritesBox => Hive.box('favorites');

  static Future<void> setAutoOpen(bool v) async { final s=await SharedPreferences.getInstance(); await s.setBool(_autoOpen, v); }
  static Future<bool> getAutoOpen() async { final s=await SharedPreferences.getInstance(); return s.getBool(_autoOpen) ?? true; }
  static Future<void> setLastRestaurant(String id) async { final s=await SharedPreferences.getInstance(); await s.setString(_lastRestaurant, id); }
  static Future<String?> getLastRestaurant() async { final s=await SharedPreferences.getInstance(); return s.getString(_lastRestaurant); }

  // Favorites cache is a list of maps
  static List<Map<String,dynamic>> loadFavorites() {
    final list = (favoritesBox.get('list') as String?) ?? '[]';
    final List data = jsonDecode(list);
    return data.cast<Map>().map((e)=>Map<String,dynamic>.from(e as Map)).toList();
  }
  static Future<void> saveFavorites(List<Map<String,dynamic>> list) async {
    await favoritesBox.put('list', jsonEncode(list));
  }
}
