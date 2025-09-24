import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../cart/providers/cart_providers.dart';
import '../providers/menu_providers.dart';

class RestaurantScreen extends ConsumerWidget {
  final String restaurantId;
  const RestaurantScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMenu = ref.watch(menuProvider(restaurantId));
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant')),
      body: asyncMenu.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (menu) => Column(children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: menu.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (c, i) => Chip(label: Text(menu.categories[i].name)),
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: ListView.builder(
              itemCount: menu.items.length,
              itemBuilder: (c, i) {
                final item = menu.items[i];
                return ListTile(
                  leading: item.imageUrl != null ? Image.network(item.imageUrl!, width: 56, height: 56, fit: BoxFit.cover) : const Icon(Icons.fastfood),
                  title: Text(item.name),
                  subtitle: Text(item.description ?? ''),
                  trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('\$${item.price.toStringAsFixed(2)}'),
                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => ref.read(cartProvider.notifier).add(item))
                  ]),
                );
              },
            ),
          ),
          if (cart.itemCount > 0)
            GestureDetector(
              onTap: () => context.push('/cart'),
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(children: [
                  const Icon(Icons.shopping_bag, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text('${cart.itemCount} items', style: const TextStyle(color: Colors.white))),
                  Text('\$${cart.subtotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}
