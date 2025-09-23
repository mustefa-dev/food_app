import 'package:go_router/go_router.dart';

import '../features/onboarding/view/onboarding_page.dart';
import '../features/auth/view/auth_page.dart';
import '../features/home/view/home_page.dart';
import '../features/menu/view/menu_page.dart';
import '../features/dish/view/dish_page.dart';
import '../features/cart/view/cart_page.dart';
import '../features/checkout/view/checkout_page.dart';
import '../features/tracking/view/tracking_page.dart';
import '../features/profile/view/profile_page.dart';
import '../features/offers/view/offers_page.dart';
import '../features/loyalty/view/loyalty_page.dart';
import '../features/support/view/support_page.dart';
import '../state/auth_state.dart';
import '../widgets/app_shell.dart';

GoRouter buildRouter(AuthState auth) {
  return GoRouter(
    initialLocation: '/auth',
    refreshListenable: auth,
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/auth';
      if (!auth.isLoggedIn && !loggingIn) return '/auth';
      if (auth.isLoggedIn && loggingIn) return '/';
      return null;
    },
    routes: [
      // Public screens (can be shown even when logged out)
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthPage()),

      // Shell with bottom navigation for main app
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomePage()),
          GoRoute(path: '/menu', builder: (_, __) => const MenuPage()),
          GoRoute(path: '/offers', builder: (_, __) => const OffersPage()),
          GoRoute(path: '/cart', builder: (_, __) => const CartPage()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),

          // Detail and other in-app flows keep the bottom nav visible
          GoRoute(path: '/dish/:id', builder: (c, s) => DishPage(dishId: s.pathParameters['id']!)),
          GoRoute(path: '/checkout', builder: (_, __) => const CheckoutPage()),
          GoRoute(path: '/tracking', builder: (_, __) => const TrackingPage()),
          GoRoute(path: '/loyalty', builder: (_, __) => const LoyaltyPage()),
          GoRoute(path: '/support', builder: (_, __) => const SupportPage()),
        ],
      ),
    ],
  );
}
