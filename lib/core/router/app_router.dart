import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/restaurant/presentation/restaurant_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/qr/presentation/qr_scanner_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';

GoRouter appRouter(WidgetRef ref) => GoRouter(
  initialLocation: '/login', // Always show login first
  routes: [
    GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
    GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
    GoRoute(path: '/restaurant/:id', builder: (c, s) => RestaurantScreen(restaurantId: s.pathParameters['id']!)),
    GoRoute(path: '/cart', builder: (c, s) => const CartScreen()),
    GoRoute(path: '/checkout', builder: (c, s) => const CheckoutScreen()),
    GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
    GoRoute(path: '/scan', builder: (c, s) => const QrScannerScreen()),
  ],
);
