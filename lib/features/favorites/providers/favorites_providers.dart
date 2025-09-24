import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/favorites_repository.dart';

final apiClientForFavs = Provider<ApiClient>((ref) => ApiClient());
final favoritesRepoProvider = Provider<FavoritesRepository>((ref) => FavoritesRepository(ref.watch(apiClientForFavs)));

final favoritesProvider = StateNotifierProvider<FavoritesController, List<RestaurantSummary>>((ref) {
  return FavoritesController(ref.watch(favoritesRepoProvider));
});

class FavoritesController extends StateNotifier<List<RestaurantSummary>> {
  final FavoritesRepository repo;
  FavoritesController(this.repo) : super(const []);

  Future<void> refresh() async { state = await repo.listFavorites(); }
  Future<void> addFavoriteById(String id) async { await repo.addById(id); await refresh(); }
  Future<void> removeFavorite(String id) async { await repo.remove(id); await refresh(); }
}
