import 'package:flutter/material.dart';
import '../../../widgets/app_bar.dart';

class LoyaltyPage extends StatelessWidget {
  const LoyaltyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Loyalty & Rewards', showBack: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_iphone, size: 64),
              const SizedBox(height: 12),
              const Text('This is the Loyalty & Rewards placeholder screen.'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mock action executed')),
                ),
                child: const Text('Try mock action'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
