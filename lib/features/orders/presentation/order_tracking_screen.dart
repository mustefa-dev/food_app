import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        StepperWidget(currentStep: 2),
        SizedBox(height: 16),
        Placeholder(fallbackHeight: 160),
      ]),
    );
  }
}

class StepperWidget extends StatelessWidget {
  final int currentStep;
  const StepperWidget({super.key, required this.currentStep});
  @override
  Widget build(BuildContext context) {
    final steps = ['PREPARING', 'READY', 'PICKED_UP', 'ON_THE_WAY', 'DELIVERED'];
    return Column(children: [
      for (int i = 0; i < steps.length; i++) ListTile(leading: Icon(i <= currentStep ? Icons.check_circle : Icons.radio_button_unchecked), title: Text(steps[i]))
    ]);
  }
}
