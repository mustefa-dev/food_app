import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app.dart';
import '../../core/i18n/i18n.dart';
import '../../core/storage/local_store.dart';
import '../auth/auth_provider.dart';

class ProfileScreen extends ConsumerWidget { const ProfileScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref) {
    final t = I18n.of(context).t; final lang = ref.watch(langProvider);
    return Scaffold(appBar: AppBar(title: Text(t['profile']!)), body: ListView(children: [
      ListTile(title: Text(t['language']!), trailing: DropdownButton(value: lang, items: const [
        DropdownMenuItem(value: AppLang.en, child: Text('English')), DropdownMenuItem(value: AppLang.ar, child: Text('العربية')),
      ], onChanged: (v)=> ref.read(langProvider.notifier).state = v!),),
      FutureBuilder<bool>(future: LocalStore.getAutoOpen(), builder: (context, snap){
        final v = snap.data ?? true;
        return SwitchListTile(title: Text(t['autoOpenLast']!), value: v, onChanged: (nv) async { await LocalStore.setAutoOpen(nv); (context as Element).markNeedsBuild(); });
      }),
      ListTile(title: Text(t['logout']!), trailing: const Icon(Icons.logout_outlined), onTap: () async {
        await ref.read(authProvider.notifier).logout();
        if (context.mounted) Navigator.of(context).pushNamedAndRemoveUntil('/login',(r)=>false);
      }),
    ]));
  }
}
