import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/i18n/i18n.dart';
import 'auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget { const RegisterScreen({super.key}); @override ConsumerState<RegisterScreen> createState()=> _RegisterScreenState(); }
class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final name = TextEditingController(); final email = TextEditingController(); final password = TextEditingController(); bool showPwd=false; bool loading=false;
  @override
  Widget build(BuildContext context) {
    final t = I18n.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t['register']!)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(controller: name, decoration: InputDecoration(labelText: t['fullName'], prefixIcon: const Icon(Icons.person_outline))),
        const SizedBox(height: 12),
        TextField(controller: email, decoration: InputDecoration(labelText: t['email'], prefixIcon: const Icon(Icons.email_outlined))),
        const SizedBox(height: 12),
        TextField(controller: password, obscureText: !showPwd, decoration: InputDecoration(labelText: t['password'], prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(icon: Icon(showPwd?Icons.visibility_off:Icons.visibility), onPressed: ()=> setState(()=> showPwd=!showPwd)),)),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: loading?null: () async { setState(()=>loading=true); await ref.read(authProvider.notifier).register(name.text.trim(), email.text.trim(), password.text); setState(()=>loading=false); },
          child: loading? const CircularProgressIndicator(color: Colors.white): Text(t['createAccount']!),
        ),
      ]),
    );
  }
}
