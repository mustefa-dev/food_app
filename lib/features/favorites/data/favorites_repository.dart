import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/storage/secure_store.dart';

class RestaurantSummary {
  final String id;
  final String name;
  final String? description;
  RestaurantSummary({required this.id, required this.name, this.description});
}

class FavoritesRepository {
  final ApiClient _client;
  FavoritesRepository(this._client);

  Future<List<RestaurantSummary>> listFavorites() async {
    try {
      final res = await _client.dio.get(Endpoints.favorites);
      final list = (res.data as List).map((e) => RestaurantSummary(id: e['id'], name: e['name'], description: e['description'])).toList();
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<void> addById(String id) async {
    try {
      await _client.dio.post(Endpoints.favorites, data: {'restaurantId': id});
    } catch (_) {/* ignore */}
    await SecureStore.setLastRestaurant(id);
  }

  Future<void> remove(String id) async {
    try { await _client.dio.delete('${Endpoints.favorites}/$id'); } catch (_){/* ignore */}
  }
}
