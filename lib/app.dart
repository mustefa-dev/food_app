import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/i18n/i18n.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/shell.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/qr/qr_scanner_screen.dart';

final langProvider = StateProvider<AppLang>((ref)=>AppLang.en);

class OrangeEatsApp extends ConsumerWidget {
  const OrangeEatsApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(langProvider);
    final t = kTranslations[lang]!;
    return I18n(
      lang: lang, t: t,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: t['appTitle']!,
        theme: AppTheme.light,
        builder: (context, child) => Directionality(textDirection: isRtl(lang) ? TextDirection.rtl : TextDirection.ltr, child: child!),
        onGenerateRoute: (settings) {
          if (settings.name == '/login') return MaterialPageRoute(builder: (_)=> const LoginScreen());
          if (settings.name == '/register') return MaterialPageRoute(builder: (_)=> const RegisterScreen());
          if (settings.name == '/scan') return MaterialPageRoute(builder: (_)=> const QrScannerScreen());
          return MaterialPageRoute(builder: (_)=> const _AuthGate());
        },
      ),
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    if (auth.loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (!auth.authenticated) return const LoginScreen();
    return const AppShell();
  }
}
