import 'package:flutter/material.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Addresses')),
      body: ListView(children: const [
        ListTile(title: Text('Home'), subtitle: Text('123 Main St'), trailing: Text('Default')),
        ListTile(title: Text('Work'), subtitle: Text('456 Office Rd')),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}
