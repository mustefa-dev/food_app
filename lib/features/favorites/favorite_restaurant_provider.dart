import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/http.dart';
import '../../core/storage/secure_store.dart';

final favoriteRestaurantProvider = Provider((ref) => FavoriteRestaurantService());

class FavoriteRestaurantService {
  Future<Map<String, dynamic>> addFavorite(String restaurantId) async {
    final token = await SecureStore.access();
    if (token == null) throw Exception('Not authenticated');
    final dio = Http.build();
    try {
      final response = await dio.post(
        '/api/favorite-restaurants',
        data: {'restaurantId': restaurantId},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return e.response?.data as Map<String, dynamic>;
      }
      rethrow;
    }
  }
}
