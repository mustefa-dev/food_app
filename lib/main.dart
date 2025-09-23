import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'routing/app_router.dart';
import 'state/app_state.dart';
import 'state/auth_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SavoryRoot());
}

class SavoryRoot extends StatelessWidget {
  const SavoryRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AuthState()),
      ],
      child: Builder(
        builder: (context) {
          final auth = context.watch<AuthState>();
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Savory',
            theme: buildLightTheme(),
            routerConfig: buildRouter(auth),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
          );
        },
      ),
    );
  }
}