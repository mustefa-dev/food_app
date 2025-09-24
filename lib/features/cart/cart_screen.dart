import 'package:flutter/material.dart';
import '../../main.dart';
import '../../src/models/models.dart';
import '../../src/state/app_state.dart';
import '../../src/utils/helpers.dart';
import '../account/account_screen.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final couponCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('السلة')),
      body: Column(children: [
        Expanded(
          child: ListView(children: [
            for (final e in app.cart.entries)
              ListTile(
                leading: CircleAvatar(
                    backgroundColor: cs.tertiary.withAlpha(31),
                    foregroundColor: cs.tertiary,
                    child: const Icon(Icons.fastfood)
                ),
                title: Text(e.key.item.title),
                subtitle: Text(buildAddOnsText(e.key.selectedAddOns)),
                trailing: SizedBox(
                  width: 140,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => app.setQty(e.key, e.value - 1)),
                    Text('${e.value}'),
                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => app.setQty(e.key, e.value + 1)),
                  ]),
                ),
              ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: couponCtrl,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.percent),
                      hintText: 'كود الخصم',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => setState(() => app.applyCoupon(couponCtrl.text.trim())),
                  child: const Text('تطبيق'),
                ),
              ]),
            ),
            if (app.appliedCoupon == 'HAL10')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: [
                  Icon(Icons.check_circle, color: cs.secondary),
                  const SizedBox(width: 8),
                  const Text('تم تطبيق خصم 10%')
                ]),
              )
            else if ((couponCtrl.text.trim().isNotEmpty))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: [
                  Icon(Icons.error_outline, color: cs.error),
                  const SizedBox(width: 8),
                  Text('الكوبون غير صالح', style: TextStyle(color: cs.error))
                ]),
              ),
            const SizedBox(height: 8),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: TipsChooser()),
            const SizedBox(height: 8),
            PaymentSummary(
              subtotal: app.subtotal,
              discount: app.discount,
              delivery: app.isFreeDelivery ? 0 : app.deliveryFee,
              service: app.serviceFee,
              tips: app.tips,
              total: app.finalTotal,
            ),
          ]),
        ),
        SafeArea(
          minimum: const EdgeInsets.all(12),
          child: Row(children: [
            OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('أضف أصناف')),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: AppStateWidget.of(context).cart.isEmpty
                    ? null
                    : () async {
                  final app = AppStateWidget.of(context);
                  if (!app.isLoggedIn) {
                    final ok = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                    if (ok != true) return;
                  }
                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  }
                },
                child: const Text('كمّل الطلب'),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class TipsChooser extends StatelessWidget {
  const TipsChooser({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    Widget tip(int v) => ChoiceChip(
      label: Text(v == 0 ? 'بدون بخشيش' : 'بخشيش د.ع ${formatIQD(v)}'),
      selected: app.tips == v,
      onSelected: (_) => app.setTips(v),
    );
    return Row(children: [
      const Icon(Icons.volunteer_activism_outlined),
      const SizedBox(width: 8),
      Expanded(child: Wrap(spacing: 8, children: [tip(0), tip(500), tip(1000)]))
    ]);
  }
}

class PaymentSummary extends StatelessWidget {
  final int subtotal, discount, delivery, service, tips, total;
  const PaymentSummary({super.key, required this.subtotal, required this.discount, required this.delivery, required this.service, required this.tips, required this.total});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('ملخص الدفع', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        _row('المجموع', subtotal),
        if (discount > 0) _row('خصم', -discount, color: cs.secondary),
        _row('التوصيل', delivery),
        _row('الخدمة', service),
        if (tips > 0) _row('بخشيش', tips),
        const Divider(),
        _row('الإجمالي', total, bold: true, color: cs.primary),
      ]),
    );
  }

  Widget _row(String label, int amount, {bool bold = false, Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
      Text('${amount < 0 ? '-' : ''}د.ع ${formatIQD(amount.abs())}', style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: color)),
    ]),
  );
}

