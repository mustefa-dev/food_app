import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app.dart';
import '../../../core/storage/secure_store.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(children: [
        ListTile(
          title: const Text('Language'),
          subtitle: const Text('Arabic / English'),
          trailing: DropdownButton<Locale>(
            value: ref.watch(localeProvider) ?? const Locale('en'),
            items: const [DropdownMenuItem(value: Locale('en'), child: Text('English')), DropdownMenuItem(value: Locale('ar'), child: Text('العربية'))],
            onChanged: (loc) => ref.read(localeProvider.notifier).state = loc,
          ),
        ),
        SwitchListTile(
          title: const Text('Auto-open last restaurant'),
          value: true,
          onChanged: (v) => SecureStore.setAutoOpenLast(v),
        ),
        const ListTile(title: Text('Addresses'), trailing: Icon(Icons.chevron_right)),
        const ListTile(title: Text('Orders'), trailing: Icon(Icons.chevron_right)),
        const ListTile(title: Text('Logout')),
      ]),
    );
  }
}
