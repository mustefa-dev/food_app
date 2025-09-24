import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(children: [
        Expanded(
          child: ListView.separated(
            itemCount: cart.lines.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (c, i) {
              final l = cart.lines[i];
              return ListTile(
                title: Text(l.item.name),
                subtitle: Text('\$${l.item.price.toStringAsFixed(2)}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => ref.read(cartProvider.notifier).dec(l.item.id)),
                  Text(l.qty.toString()),
                  IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => ref.read(cartProvider.notifier).add(l.item)),
                  IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => ref.read(cartProvider.notifier).remove(l.item.id)),
                ]),
              );
            },
          ),
        ),
        _SummaryCard(),
      ]),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton(
            onPressed: cart.itemCount == 0 ? null : () => context.push('/checkout'),
            child: const Text('Proceed to checkout'),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _row('Subtotal', cart.subtotal),
          _row('Taxes', cart.taxes()),
          _row('Delivery fee', cart.deliveryFee()),
          _row('Small order fee', cart.smallOrderFee()),
          const Divider(),
          _row('Total', cart.total(), bold: true),
        ]),
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)), Text('\$${value.toStringAsFixed(2)}', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal))],
      );
}
