import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../core/storage/local_store.dart';
import 'favorite_restaurant_provider.dart';

class FavoriteRestaurant {
  final String id; final String name; final String image; final String? description;
  const FavoriteRestaurant({required this.id, required this.name, required this.image, this.description});
  Map<String,dynamic> toJson()=> {'id':id,'name':name,'image':image,'description':description};
  factory FavoriteRestaurant.fromJson(Map<String,dynamic> j)=> FavoriteRestaurant(id:j['id'], name:j['name'], image:j['image']??'', description:j['description']);
}

class FavoritesController extends StateNotifier<List<FavoriteRestaurant>> {
  FavoritesController(this.ref): super(LocalStore.loadFavorites().map(FavoriteRestaurant.fromJson).toList());
  final Ref ref;
  Future<void> add(FavoriteRestaurant f) async { if (state.any((e)=>e.id==f.id)) return; final list=[...state,f]; state=list; await LocalStore.saveFavorites(list.map((e)=>e.toJson()).toList()); await LocalStore.setLastRestaurant(f.id); }
  Future<String?> addById(String id, {BuildContext? context}) async {
    try {
      final service = ref.read(favoriteRestaurantProvider);
      final result = await service.addFavorite(id);
      debugPrint('Favorite API result: ' + result.toString());
      if (result['favoriteRestaurant'] != null) {
        // Add to local storage only if backend succeeded
        final meta = (LocalStore.restaurantsBox.get(id) as Map?) ?? {'id':id,'name':'Restaurant $id','image':'assets/images/banner.png'};
        await add(FavoriteRestaurant(id:id, name:'${meta['name']}', image: '${meta['image']}', description: meta['description'] as String?));
        return null;
      } else if (result['error'] != null) {
        return result['error'];
      } else if (result['message'] != null) {
        return result['message'];
      } else {
        return 'Unknown error: ' + result.toString();
      }
    } catch (e) {
      debugPrint('Favorite API exception: ' + e.toString());
      return 'Network or server error';
    }
  }
  Future<void> remove(String id) async { final list = state.where((e)=>e.id!=id).toList(); state=list; await LocalStore.saveFavorites(list.map((e)=>e.toJson()).toList()); }
  Future<void> setDefault(String id) async { await LocalStore.setLastRestaurant(id); }
}

final favoritesProvider = StateNotifierProvider<FavoritesController, List<FavoriteRestaurant>>((ref)=> FavoritesController(ref));
