import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/i18n/i18n.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool showPwd = false;
  @override
  Widget build(BuildContext context) {
    final t = I18n.of(context).t;
    final authState = ref.watch(authProvider);
    ref.listen(authProvider, (prev, next) {
      if (prev?.loading == true && next.loading == false) {
        if (next.authenticated) {
          Navigator.of(context).pushReplacementNamed('/');
        } else if (!next.authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t['loginFailed'] ?? 'Login failed')),
          );
        }
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text(t['login']!)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(controller: email, decoration: InputDecoration(labelText: t['email'], prefixIcon: const Icon(Icons.email_outlined))),
        const SizedBox(height: 12),
        TextField(controller: password, obscureText: !showPwd, decoration: InputDecoration(labelText: t['password'], prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(icon: Icon(showPwd?Icons.visibility_off:Icons.visibility), onPressed: ()=> setState(()=> showPwd=!showPwd)),)),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: authState.loading ? null : () async {
            if (email.text.trim().isEmpty || password.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t['enterEmailPassword'] ?? 'Enter email and password')),
              );
              return;
            }
            try {
              await ref.read(authProvider.notifier).login(email.text.trim(), password.text);
            } catch (e) {
              // Error handled by provider listen
            }
          },
          child: authState.loading ? const CircularProgressIndicator(color: Colors.white) : Text(t['signIn']!),
        ),
        TextButton(onPressed: ()=> Navigator.of(context).pushNamed('/register'), child: Text(t['createAccount']!)),
      ]),
    );
  }
}
