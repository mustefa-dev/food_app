import 'package:flutter/material.dart';
import '../../main.dart';
import '../../src/state/app_state.dart';
import '../../src/models/models.dart';
import '../../src/utils/helpers.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedAddress = 0;
  String payment = 'بطاقة •••• 8075';
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final info = CheckoutInfo(
      address: app.savedAddresses[selectedAddress].details,
      paymentMethod: payment,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('اتمام الطلب')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        sectionTitle('عنوان التوصيل'),
        const SizedBox(height: 6),
        for (int i = 0; i < app.savedAddresses.length; i++)
          Card(
            child: RadioListTile<int>(
              value: i,
              groupValue: selectedAddress,
              onChanged: (v) => setState(() => selectedAddress = v ?? 0),
              title: Text(app.savedAddresses[i].label),
              subtitle: Text(app.savedAddresses[i].details),
            ),
          ),
        const SizedBox(height: 12),
        sectionTitle('الدفع'),
        RadioListTile<String>(
          value: 'بطاقة •••• 8075',
          groupValue: payment,
          onChanged: (v) => setState(() => payment = v!),
          title: const Text('Mastercard •••• 8075'),
        ),
        RadioListTile<String>(
          value: 'بطاقة •••• 2590',
          groupValue: payment,
          onChanged: (v) => setState(() => payment = v!),
          title: const Text('Mastercard •••• 2590'),
        ),
        RadioListTile<String>(
          value: 'دفع عند التسليم',
          groupValue: payment,
          onChanged: (v) => setState(() => payment = v!),
          title: const Text('كاش عند التسليم'),
        ),
        const Divider(height: 32),
        PaymentSummary(
          subtotal: app.subtotal,
          discount: app.discount,
          delivery: app.isFreeDelivery ? 0 : app.deliveryFee,
          service: app.serviceFee,
          tips: app.tips,
          total: app.finalTotal,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            info.paymentMethod = payment;
            info.address = app.savedAddresses[selectedAddress].details;
            app.placeOrder(info);
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OrderPlacedScreen()),
                    (route) => route.isFirst,
              );
            }
          },
          child: const Text('تأكيد الطلب'),
        ),
      ]),
    );
  }
}

