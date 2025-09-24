import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_state.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Scaffold(appBar: AppBar(title: const Text('Cart')), body: Column(children: [
      Expanded(child: ListView.separated(itemCount: cart.items.length, separatorBuilder: (_, __)=> const Divider(height:0), itemBuilder: (c,i){
        final it=cart.items[i]; final img=it.img;
        final imageWidget = img.startsWith('http') ? CachedNetworkImage(imageUrl: img, width:56, height:56, fit: BoxFit.cover) : (img.isEmpty? const Icon(Icons.fastfood): Image.asset(img, width:56, height:56, fit: BoxFit.cover));
        return ListTile(leading: ClipRRect(borderRadius: BorderRadius.circular(10), child: imageWidget), title: Text(it.name), subtitle: Text('\$${it.price.toStringAsFixed(2)}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: ()=> ref.read(cartProvider.notifier).dec(it.id)),
            Text('${it.qty}'),
            IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: ()=> ref.read(cartProvider.notifier).inc(it.id)),
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: ()=> ref.read(cartProvider.notifier).remove(it.id)),
          ]));
      })),
      Card(margin: const EdgeInsets.all(12), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        _row('Subtotal', cart.subtotal), _row('Taxes', cart.taxes), _row('Delivery', cart.delivery), const Divider(), _row('Total', cart.total, bold:true),
      ]))),
    ]),
    bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(12), child:
      FilledButton(onPressed: cart.totalItems==0?null: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const CheckoutScreen())), child: const Text('Proceed to checkout'))
    )));
  }
  Widget _row(String label, double value, {bool bold=false})=> Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(fontWeight: bold? FontWeight.bold: FontWeight.normal)), Text('\$${value.toStringAsFixed(2)}', style: TextStyle(fontWeight: bold? FontWeight.bold: FontWeight.normal))
  ]);
}
