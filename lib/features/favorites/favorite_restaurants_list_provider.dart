import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/http.dart';
import '../../core/storage/secure_store.dart';

final favoriteRestaurantsListProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final token = await SecureStore.access();
  if (token == null) throw Exception('Not authenticated');
  final dio = Http.build();
  try {
    final response = await dio.get(
      '/api/favorite-restaurants',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    );
    final data = response.data;
    log('Favorite restaurants API response: ' + data.toString());
    if (data['data'] is List) {
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception(data['error'] ?? 'Unknown error fetching favorites: ' + data.toString());
    }
  } catch (e, st) {
    log('Favorite restaurants API error: $e\n$st');
    rethrow;
  }
});
