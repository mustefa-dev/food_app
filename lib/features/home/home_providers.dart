import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/local_store.dart';
import 'dart:convert';
import '../../core/api/http.dart';
import '../../core/storage/secure_store.dart';
import 'package:dio/dio.dart';

// Holds the currently selected restaurantId
final selectedRestaurantIdProvider = StateProvider<String?>((ref) => null);

// Fetches categories for a given restaurantId
final categoriesProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, restaurantId) async {
  // Try cache first
  final cachedStr = LocalStore.menusBox.get(restaurantId) as String?;
  if (cachedStr != null) {
    final menu = jsonDecode(cachedStr) as Map<String, dynamic>;
    if (menu['categories'] is List) {
      return List<Map<String, dynamic>>.from(menu['categories']);
    }
  }
  // Fetch from backend
  final token = await SecureStore.access();
  final dio = Http.build();
  final response = await dio.get(
    '/api/restaurants/$restaurantId/categories',
    options: Options(headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    }),
  );
  final data = response.data;
  if (data['data'] != null && data['data'] is List) {
    // Optionally cache
    final menu = {'categories': data['data']};
    await LocalStore.menusBox.put(restaurantId, jsonEncode(menu));
    return List<Map<String, dynamic>>.from(data['data']);
  } else {
    throw Exception(data['error'] ?? 'No categories found');
  }
});

// Fetches items for a given restaurantId and categoryId
final itemsProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, String>>((ref, params) async {
  final restaurantId = params['restaurantId']!;
  final categoryId = params['categoryId']!;
  final token = await SecureStore.access();
  final dio = Http.build();
  final response = await dio.get(
    '/api/restaurants/$restaurantId/categories/$categoryId/items',
    options: Options(headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    }),
    queryParameters: {'pageNumber': 1, 'pageSize': 20, 'isAvailable': true},
  );
  final data = response.data;
  if (data['data'] is List) {
    return List<Map<String, dynamic>>.from(data['data']);
  } else {
    throw Exception(data['error'] ?? 'Unknown error');
  }
});

