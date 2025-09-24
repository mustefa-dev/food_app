import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/menu_repository.dart';
import '../data/models/menu_models.dart';

final apiClientForMenu = Provider<ApiClient>((ref) => ApiClient());
final menuRepoProvider = Provider<MenuRepository>((ref) => MenuRepository(ref.watch(apiClientForMenu)));
final menuProvider = FutureProvider.family<MenuPayload, String>((ref, restaurantId) async =>
  (await ref.read(menuRepoProvider).fetchMenu(restaurantId)).when(
    ok: (v) => v,
    err: (e) => throw e,
  )
);
