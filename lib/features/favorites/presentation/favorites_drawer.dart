import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/favorites_providers.dart';

class FavoritesDrawer extends ConsumerWidget {
  const FavoritesDrawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    return Drawer(
      child: SafeArea(
        child: Column(children: [
          const ListTile(title: Text('User Name'), subtitle: Text('user@email.com')),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (c, i) {
                final r = favorites[i];
                return ListTile(
                  title: Text(r.name),
                  subtitle: Text(r.description ?? ''),
                  trailing: PopupMenuButton(
                    itemBuilder: (ctx) => const [
                      PopupMenuItem(value: 'default', child: Text('Set as default')),
                      PopupMenuItem(value: 'remove', child: Text('Remove')),
                    ],
                    onSelected: (v) async {
                      if (v == 'default') {
                        // set last restaurant
                      } else {
                        await ref.read(favoritesProvider.notifier).removeFavorite(r.id);
                      }
                    },
                  ),
                  onTap: () => context.go('/restaurant/${r.id}'),
                );
              },
            ),
          ),
          ListTile(leading: const Icon(Icons.qr_code), title: const Text('Scan QR / Add restaurant'), onTap: () => context.push('/scan')),
        ]),
      ),
    );
  }
}
