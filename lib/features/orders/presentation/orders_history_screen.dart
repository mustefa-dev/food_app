import 'package:flutter/material.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (c, i) => const ListTile(title: Text('Restaurant Name'), subtitle: Text('2 items • \$12.50 • DELIVERED'), trailing: Icon(Icons.chevron_right)),
      ),
    );
  }
}
