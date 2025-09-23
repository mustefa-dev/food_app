import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(label: 'Home', icon: Icons.home_rounded, route: '/'),
    _TabItem(label: 'Menu', icon: Icons.restaurant_menu_rounded, route: '/menu'),
    _TabItem(label: 'Offers', icon: Icons.local_offer_rounded, route: '/offers'),
    _TabItem(label: 'Cart', icon: Icons.shopping_cart_rounded, route: '/cart'),
    _TabItem(label: 'Profile', icon: Icons.person_rounded, route: '/profile'),
  ];

  int _indexForLocation(String location) {
    // Match by startsWith for nested paths under a tab
    for (var i = 0; i < _tabs.length; i++) {
      final p = _tabs[i].route;
      if (p == '/') {
        if (location == '/' || location.startsWith('/?') ||
            location.startsWith('/#') ||
            location.startsWith('/home')) return i;
      } else if (location == p || location.startsWith('$p/')) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _indexForLocation(location);
    final cartCount = context.watch<AppState>().cart.length;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: kPrimary,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        final dest = _tabs[i];
                        if (dest.route != location) context.go(dest.route);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _navIcon(_tabs[i], cartCount, selectedIndex == i),
                            const SizedBox(height: 4),
                            Text(
                              _tabs[i].label,
                              style: TextStyle(
                                fontSize: 10,
                                color: selectedIndex == i ? kSecondary : Colors.grey[400],
                                fontWeight: selectedIndex == i ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon(_TabItem t, int cartCount, bool isSelected) {
    Widget icon = Icon(
      t.icon,
      color: isSelected ? kSecondary : Colors.grey[400],
      size: 24,
    );

    if (t.route == '/cart' && cartCount > 0) {
      return Badge(
        label: Text(
          '$cartCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        child: icon,
      );
    }
    return icon;
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final String route;
  const _TabItem({required this.label, required this.icon, required this.route});
}
