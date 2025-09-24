import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:orange_eats_offline_full/src/state/app_state.dart';
import 'package:orange_eats_offline_full/src/utils/helpers.dart';

// Screens
import '../features/restaurant/restaurant_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/account/account_screen.dart';
import 'i18n/i18n.dart';

class Brand {
  static const primary = Color(0xFF06C167);
  static const secondary = Color(0xFF34D399);
  static const tertiary = Color(0xFF059669);
  static const onSurface = Color(0xFF0F172A);
  static const bg = Color(0xFFFFFFFF);
  static const bgAlt = Color(0xFFF1FDF7);
  static const outline = Color(0xFFD1FAE5);
  static const error = Color(0xFFDC2626);
  static const warning = Color(0xFFFACC15);
}

ColorScheme _colorScheme(Brightness b) {
  final isDark = b == Brightness.dark;
  return ColorScheme(
    brightness: b,
    primary: Brand.primary,
    onPrimary: Colors.white,
    secondary: Brand.secondary,
    onSecondary: Colors.white,
    tertiary: Brand.tertiary,
    onTertiary: Colors.white,
    error: Brand.error,
    onError: Colors.white,
    surface: isDark ? const Color(0xFF111827) : Brand.bg,
    onSurface: isDark ? const Color(0xFFE2E8F0) : Brand.onSurface,
    surfaceContainerHighest: isDark ? const Color(0xFF1E293B) : Brand.bgAlt,
    surfaceContainerHigh: isDark ? const Color(0xFF1B2332) : const Color(0xFFECFDF5),
    surfaceContainer: isDark ? const Color(0xFF1B1B25) : const Color(0xFFF0FDF4),
    surfaceContainerLow: isDark ? const Color(0xFF151923) : const Color(0xFFDCFCE7),
    surfaceContainerLowest: isDark ? const Color(0xFF0F172A) : Brand.bg,
    outline: isDark ? const Color(0xFF334155) : Brand.outline,
    outlineVariant: isDark ? const Color(0xFF475569) : const Color(0xFFD1FAE5),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: isDark ? Brand.bg : const Color(0xFF0F172A),
    onInverseSurface: isDark ? Brand.onSurface : Colors.white,
    inversePrimary: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
  );
}

ThemeData buildTheme(Brightness brightness) {
  final scheme = _colorScheme(brightness);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: scheme.onSurface),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 64,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primary.withAlpha(41),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: scheme.outline)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: scheme.outline)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: scheme.primary)),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),
  );
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  Future<(I18n, AppState)> _bootstrap() async {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final lang = (locale.languageCode == 'ar') ? 'ar' : 'en';
    final i18n = I18n(Locale(lang));
    await i18n.load(i18n.locale);

    final state = AppState();
    await state.loadDemo();

    return (i18n, state);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(I18n, AppState)>(
      future: _bootstrap(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const MaterialApp(home: SizedBox());
        }
        final (i18n, state) = snap.data!;
        return AppStateWidget(
          state: state,
          child: I18nProvider(
            i18n: i18n,
            child: AnimatedBuilder(
              animation: i18n,
              builder: (context, _) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: i18n.t('app.title'),
                  theme: buildTheme(Brightness.light),
                  darkTheme: buildTheme(Brightness.dark),
                  themeMode: ThemeMode.system,
                  supportedLocales: const [Locale('ar'), Locale('en')],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  locale: i18n.locale,
                  home: const MainScaffold(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;
  final List<Widget> _pages = const [RestaurantScreen(), OrdersScreen(), AccountScreen()];

  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final cs = Theme.of(context).colorScheme;
    final t = I18nProvider.of(context);

    return Stack(
      children: [
        Scaffold(
          body: _pages[_index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            destinations: [
              NavigationDestination(icon: const Icon(Icons.home_outlined), label: t.t('nav.home')),
              NavigationDestination(icon: const Icon(Icons.receipt_long_outlined), label: t.t('nav.orders')),
              NavigationDestination(icon: const Icon(Icons.person_outline), label: t.t('nav.account')),
            ],
            onDestinationSelected: (i) => setState(() => _index = i),
          ),
        ),
        if (app.cartCount > 0)
          Positioned(
            left: 12,
            right: 12,
            bottom: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              // ✅ إصلاح التنقّل: لا تستخدم copyWith على MaterialPageRoute
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                  settings: const RouteSettings(name: 'cart'),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      foregroundColor: cs.primary,
                      child: Text(app.cartCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text(t.t('cta.view_cart'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ]),
                  Text(
                    '${currencyLabel(context)}${formatIQD(app.subtotal)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
