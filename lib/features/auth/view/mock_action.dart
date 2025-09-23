// ...existing code...
import 'package:flutter/material.dart';
import '../data/mock_auth_repository.dart';
import '../data/mock_auth_data.dart';

Future<void> performMockAuthFlow(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  final repo = MockAuthRepository();
  try {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(content: Text('Starting mock auth flow...')),
    );

    final token = await repo.signIn(MockAuthData.createMockSignInCommand());
    final user = await repo.getCurrentUser();

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text('Signed in as ${user?['fullName']} (token: $token)')),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    await repo.signOut();
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(content: Text('Signed out (mock flow complete)')),
    );
  } catch (e) {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text('Mock flow failed: $e')),
    );
  }
}
// ...existing code...
