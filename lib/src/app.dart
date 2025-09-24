import 'package:flutter/material.dart';
import 'package:orange_eats_offline_full/src/state/app_state.dart';
import 'package:orange_eats_offline_full/src/utils/helpers.dart';
// Project modules

import '../../features/restaurant/restaurant_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/account/account_screen.dart';

class Brand {
  static const primary = Color(0xFF06C167); // Green as primary
  static const secondary = Color(0xFF34D399); // Lighter green
  static const tertiary = Color(0xFF059669); // Darker green
  static const onSurface = Color(0xFF0F172A); // Rich black for text
  static const bg = Color(0xFFFFFFFF);
  static const bgAlt = Color(0xFFF1FDF7);
  static const outline = Color(0xFFD1FAE5); // Light green outline
  static const error = Color(0xFFDC2626); // Error red
  static const warning = Color(0xFFFACC15); // Warning yellow
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
    fontFamily: 'Cairo', // Add Cairo or Tajawal in pubspec
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surface,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    chipTheme: ChipThemeData(
      shape: StadiumBorder(side: BorderSide(color: scheme.outline)),
      backgroundColor: scheme.surfaceContainerHigh,
      selectedColor: scheme.secondary.withAlpha(46),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: scheme.outline),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 64,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primary.withAlpha(41), // Fixed opacity warning
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),
  );
}

// ===================== APP =====================
class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      state: AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'مطعم واحد — HallGlow',
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: ThemeMode.system,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: MainScaffold(),
        ),
      ),
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
    return Stack(
      children: [
        Scaffold(
          body: _pages[_index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
              NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'طلباتي'),
              NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
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
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartScreen()),
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
                    const Text('شوف السلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ]),
                  Text('د.ع ${formatIQD(app.subtotal)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
