import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget { const OrdersScreen({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Orders')), body: ListView.separated(
      itemCount: 0, separatorBuilder: (_, __)=> const Divider(height:0), itemBuilder: (c,i)=> const SizedBox.shrink()
    ));
  }
}
