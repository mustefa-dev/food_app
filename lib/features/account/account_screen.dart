import 'package:flutter/material.dart';
import '../../src/state/app_state.dart';
import '../../src/i18n/i18n.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = I18nProvider.of(context);
    final app = AppStateWidget.of(context);

    if (!app.isLoggedIn) return const AuthScreen();

    return Scaffold(
      appBar: AppBar(title: Text(t.t('account.title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(app.currentUser!.name),
            subtitle: Text(app.currentUser!.email),
            trailing: TextButton(
              onPressed: app.signOut,
              child: Text(t.t('auth.sign_out')),
            ),
          ),
          const Divider(),
          ListTile(leading: const Icon(Icons.card_giftcard_outlined), title: Text(t.t('account.points'))),
          ListTile(leading: const Icon(Icons.receipt_long_outlined), title: Text(t.t('account.my_orders'))),
          ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: Text(t.t('account.wallet'))),
          ListTile(leading: const Icon(Icons.percent_outlined), title: Text(t.t('account.coupons'))),
          ListTile(leading: const Icon(Icons.help_outline), title: Text(t.t('account.help'))),
          ListTile(leading: const Icon(Icons.info_outline), title: Text(t.t('account.about'))),
        ],
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailCtrl = TextEditingController(text: 'demo@hallglow.com');
  final passCtrl = TextEditingController(text: '123456');
  final nameCtrl = TextEditingController();
  bool isLogin = true;
  String? error;

  @override
  Widget build(BuildContext context) {
    final t = I18nProvider.of(context);
    final app = AppStateWidget.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? t.t('auth.sign_in') : t.t('auth.sign_up'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!isLogin)
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: t.t('auth.name')),
            ),
          if (!isLogin) const SizedBox(height: 12),
          TextField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: t.t('auth.email')),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passCtrl,
            obscureText: true,
            decoration: InputDecoration(labelText: t.t('auth.password')),
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(t.t(error!), style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              String? e;
              if (isLogin) {
                e = await app.signIn(emailCtrl.text.trim(), passCtrl.text);
              } else {
                e = await app.signUp(
                  nameCtrl.text.trim().isEmpty ? t.t('auth.default_name') : nameCtrl.text.trim(),
                  emailCtrl.text.trim(),
                  passCtrl.text,
                );
              }
              if (e != null) {
                setState(() => error = e);
              } else {
                if (mounted) Navigator.pop(context, true);
              }
            },
            child: Text(isLogin ? t.t('auth.sign_in_btn') : t.t('auth.sign_up_btn')),
          ),
          TextButton(
            onPressed: () => setState(() => isLogin = !isLogin),
            child: Text(isLogin ? t.t('auth.need_account') : t.t('auth.have_account')),
          ),
        ],
      ),
    );
  }
}
