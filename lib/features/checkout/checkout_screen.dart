import 'package:flutter/material.dart';
import '../../src/state/app_state.dart';
import '../../src/models/models.dart';
import '../../src/utils/helpers.dart';
import '../../src/i18n/i18n.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedAddress = 0;
  String payment = '**** 8075';

  @override
  Widget build(BuildContext context) {
    final t = I18nProvider.of(context);
    final app = AppStateWidget.of(context);
    final info = CheckoutInfo(
      address: app.savedAddresses[selectedAddress].details,
      paymentMethod: payment,
    );

    return Scaffold(
      appBar: AppBar(title: Text(t.t('checkout.title'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        sectionTitle(t.t('checkout.delivery_address')),
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
        sectionTitle(t.t('checkout.payment')),
        RadioListTile<String>(
          value: '**** 8075',
          groupValue: payment,
          onChanged: (v) => setState(() => payment = v!),
          title: Text('${t.t("checkout.card")} •••• 8075'),
        ),
        RadioListTile<String>(
          value: '**** 2590',
          groupValue: payment,
          onChanged: (v) => setState(() => payment = v!),
          title: Text('${t.t("checkout.card")} •••• 2590'),
        ),
        RadioListTile<String>(
          value: t.t('checkout.cod'),
          groupValue: payment,
          onChanged: (v) => setState(() => payment = v!),
          title: Text(t.t('checkout.cod')),
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
          child: Text(t.t('checkout.confirm')),
        ),
      ]),
    );
  }
}

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = I18nProvider.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, size: 96, color: Color(0xFF34D399)),
            const SizedBox(height: 16),
            Text(t.t('checkout.placed'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(t.t('checkout.eta')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
                    (route) => false,
              ),
              child: Text(t.t('checkout.track_order')),
            ),
          ]),
        ),
      ),
    );
  }
}
