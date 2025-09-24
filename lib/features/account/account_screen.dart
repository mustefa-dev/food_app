import 'package:flutter/material.dart';
import '../../src/state/app_state.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    if (!app.isLoggedIn) return const AuthScreen();
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(app.currentUser!.name),
          subtitle: Text(app.currentUser!.email),
          trailing: TextButton(onPressed: app.signOut, child: const Text('تسجيل خروج')),
        ),
        const Divider(),
        const ListTile(leading: Icon(Icons.card_giftcard_outlined), title: Text('النقاط')),
        const ListTile(leading: Icon(Icons.receipt_long_outlined), title: Text('طلباتي')),
        const ListTile(leading: Icon(Icons.account_balance_wallet_outlined), title: Text('المحفظة')),
        const ListTile(leading: Icon(Icons.percent_outlined), title: Text('كوبونات')),
        const ListTile(leading: Icon(Icons.help_outline), title: Text('مساعدة')),
        const ListTile(leading: Icon(Icons.info_outline), title: Text('عن التطبيق')),
      ]),
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
    final app = AppStateWidget.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'تسجيل دخول' : 'إنشاء حساب')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (!isLogin)
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'الاسم'),
          ),
        if (!isLogin) const SizedBox(height: 12),
        TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'الإيميل'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'كلمة المرور'),
        ),
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(error!, style: const TextStyle(color: Colors.red))
        ],
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            String? e;
            if (isLogin) {
              e = await app.signIn(emailCtrl.text.trim(), passCtrl.text);
            } else {
              e = await app.signUp(
                nameCtrl.text.trim().isEmpty ? 'مستخدم' : nameCtrl.text.trim(),
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
          child: Text(isLogin ? 'دخول' : 'تسجيل'),
        ),
        TextButton(
          onPressed: () => setState(() => isLogin = !isLogin),
          child: Text(isLogin ? 'ما عندك حساب؟ سجل الآن' : 'عندك حساب؟ سجّل دخول'),
        ),
      ]),
    );
  }
}

