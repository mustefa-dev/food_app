import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/i18n/l10n.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

final localeProvider = StateProvider<Locale?>((ref) => null);

class OrangeEatsApp extends ConsumerWidget {
  const OrangeEatsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'OrangeEats',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: L10n.localizationsDelegates,
      routerConfig: appRouter(ref),
      builder: (context, child) {
        final currentLocale = locale ?? Localizations.localeOf(context);
        final isRtl = L10n.isRtl(currentLocale);
        return Directionality(textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr, child: child!);
      },
    );
  }
}
