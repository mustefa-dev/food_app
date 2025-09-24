import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../favorites/presentation/favorites_drawer.dart';
import '../../favorites/providers/favorites_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('OrangeEats')),
      drawer: const FavoritesDrawer(),
      body: favs.isEmpty
          ? _EmptyFavorites(onScan: () => context.push('/scan'))
          : ListView.separated(
              itemCount: favs.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (c, i) {
                final r = favs[i];
                return ListTile(
                  title: Text(r.name),
                  subtitle: Text(r.description ?? ''),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/restaurant/${r.id}')
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.push('/scan'), child: const Icon(Icons.qr_code_scanner)),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  final VoidCallback onScan;
  const _EmptyFavorites({required this.onScan});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset('assets/images/empty_favorites.png', height: 160),
          const SizedBox(height: 16),
          const Text('No favorite restaurants yet — scan QR to add one 😉', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          FilledButton(onPressed: onScan, child: const Text('Scan QR'))
        ]),
      ),
    );
  }
}
