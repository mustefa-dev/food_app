import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../favorites/favorites_provider.dart';
import '../home/home_providers.dart';
import './favorite_restaurants_list_provider.dart';

class FavoritesDrawer extends ConsumerWidget {
  const FavoritesDrawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favsAsync = ref.watch(favoriteRestaurantsListProvider);
    return Drawer(
      child: SafeArea(
        child: Column(children: [
          const ListTile(title: Text('Your Favorites'), subtitle: Text('Tap to switch')),
          const Divider(),
          Expanded(
            child: favsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Failed to load favorites')),
              data: (favs) => favs.isEmpty
                ? const Center(child: Text('No favorites'))
                : ListView.separated(
                    itemCount: favs.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (c, i) {
                      final r = favs[i]['restaurant'];
                      final img = r['image'] as String?;
                      Widget leadingWidget;
                      if (img != null && (img.startsWith('http://') || img.startsWith('https://'))) {
                        leadingWidget = ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(imageUrl: img, width: 44, height: 44, fit: BoxFit.cover),
                        );
                      } else {
                        leadingWidget = const Icon(Icons.restaurant);
                      }
                      return ListTile(
                        leading: leadingWidget,
                        title: Text(r['name'] ?? ''),
                        subtitle: Text(r['description'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () {
                          Navigator.pop(context);
                          ref.read(selectedRestaurantIdProvider.notifier).state = r['id'];
                        },
                      );
                    },
                  ),
            ),
          ),
          ListTile(leading: const Icon(Icons.qr_code_scanner), title: const Text('Scan QR / Add restaurant'), onTap: (){ Navigator.pop(context); Navigator.of(context).pushNamed('/scan'); })
        ]),
      ),
    );
  }
}
