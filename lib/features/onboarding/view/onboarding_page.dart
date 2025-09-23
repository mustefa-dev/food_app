import 'package:flutter/material.dart';
import '../../../widgets/app_bar.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Onboarding & Branding', showBack: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.phone_iphone, size: 64),
              SizedBox(height: 12),
              Text('This is the Onboarding & Branding placeholder screen.'),
            ],
          ),
        ),
      ),
    );
  }
}
