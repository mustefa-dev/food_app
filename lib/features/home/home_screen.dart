import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/i18n/i18n.dart';
import '../../core/ui/skeletons.dart';
import '../../core/storage/local_store.dart';
import '../restaurant/restaurant_screen.dart';
import '../favorites/favorites_drawer.dart';
import 'home_providers.dart';

final cachedRestaurantsProvider = StateProvider<List<Map<String,dynamic>>>((ref)=> (LocalStore.restaurantsBox.get('list') as List?)?.cast<Map<String,dynamic>>() ?? []);

class HomeScreen extends ConsumerStatefulWidget { const HomeScreen({super.key}); @override ConsumerState<HomeScreen> createState()=> _HomeScreenState(); }
class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initSelectedRestaurant();
  }
  Future<void> _initSelectedRestaurant() async {
    if (_initialized) return;
    _initialized = true;
    final last = await LocalStore.getLastRestaurant();
    if (last != null && ref.read(selectedRestaurantIdProvider) == null) {
      ref.read(selectedRestaurantIdProvider.notifier).state = last;
    }
  }
  @override
  Widget build(BuildContext context) {
    final t = I18n.of(context).t;
    final selectedRestaurantId = ref.watch(selectedRestaurantIdProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t['appTitle']!), actions: [IconButton(onPressed: ()=> Navigator.of(context).pushNamed('/scan'), icon: const Icon(Icons.qr_code_scanner))]),
      drawer: const FavoritesDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: t['searchPlaceholder'],
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: selectedRestaurantId == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.restaurant_menu, size: 64, color: Colors.orange),
                      const SizedBox(height: 24),
                      Text(
                        'Select a favorite restaurant from the drawer to view its menu',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : _RestaurantMenuView(restaurantId: selectedRestaurantId),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Map<String,dynamic> data; const _RestaurantCard({required this.data});
  @override Widget build(BuildContext context) {
    final t = I18n.of(context).t;
    final img = data['image'] as String? ?? '';
    final Widget imageWidget = img.startsWith('http') ? CachedNetworkImage(imageUrl: img, height:170, width:double.infinity, fit: BoxFit.cover) : Image.asset(img, height:170, width:double.infinity, fit: BoxFit.cover);
    return InkWell(
      onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> RestaurantScreen(restaurantId: data['id']))),
      child: Card(margin: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: imageWidget),
        Padding(padding: const EdgeInsets.all(12), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${data['name']}', style: const TextStyle(fontSize:16, fontWeight: FontWeight.w600)),
            const SizedBox(height:4), Text('${data['eta'] ?? '--'} ${t['minutes']} • ⭐ ${data['rating'] ?? '--'}', style: const TextStyle(color: Colors.black54)),
          ])),
          TextButton(onPressed: (){}, child: Text(t['viewMenu']!))
        ])),
      ])),
    );
  }
}

class _RestaurantMenuView extends ConsumerWidget {
  final String restaurantId;
  const _RestaurantMenuView({required this.restaurantId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider(restaurantId));
    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Failed to load categories')),
      data: (categories) => categories.isEmpty
        ? const Center(child: Text('No categories found'))
        : ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final itemsAsync = ref.watch(itemsProvider({'restaurantId': restaurantId, 'categoryId': cat['id'].toString()}));
              return ExpansionTile(
                title: Text(cat['name'] ?? ''),
                children: [
                  itemsAsync.when(
                    loading: () => const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
                    error: (e, _) => Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load items')),
                    data: (items) => items.isEmpty
                      ? const Padding(padding: EdgeInsets.all(16), child: Text('No items'))
                      : Column(children: items.map((it) => ListTile(
                          title: Text(it['name'] ?? ''),
                          subtitle: Text(it['description'] ?? ''),
                          trailing: it['price'] != null ? Text('₤${(it['price'] as num).toStringAsFixed(2)}') : null,
                        )).toList()),
                  )
                ],
              );
            },
          ),
    );
  }
}

class _ShimmerList extends StatelessWidget { const _ShimmerList(); @override Widget build(BuildContext context) {
  return Column(children: List.generate(3, (i)=> const Padding(padding: EdgeInsets.only(bottom:16), child: ShimmerBox(height:220)))); } }
