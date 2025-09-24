import 'package:flutter/material.dart';
import '../../src/state/app_state.dart';
import '../../src/utils/helpers.dart';
import '../../src/i18n/i18n.dart';
import '../account/account_screen.dart';
import '../checkout/checkout_screen.dart';
import '../../src/models/models.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final couponCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = I18nProvider.of(context);
    final app = AppStateWidget.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.t('cart.title'))),
      body: Column(children: [
        Expanded(
          child: ListView(children: [
            for (final e in app.cart.entries)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: cs.tertiary.withAlpha(31),
                  foregroundColor: cs.tertiary,
                  child: const Icon(Icons.fastfood),
                ),
                title: Text(textOf(context, e.key.item.title)),
                subtitle: Text(buildAddOnsText(context, e.key.selectedAddOns)),
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
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.percent),
                      hintText: t.t('cart.coupon_hint'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => setState(() => app.applyCoupon(couponCtrl.text.trim())),
                  child: Text(t.t('cart.apply_coupon')),
                ),
              ]),
            ),
            if (app.appliedCoupon == 'HAL10')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: [
                  Icon(Icons.check_circle, color: cs.secondary),
                  const SizedBox(width: 8),
                  Text(t.t('cart.coupon_applied_10')),
                ]),
              )
            else if ((couponCtrl.text.trim().isNotEmpty))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: [
                  Icon(Icons.error_outline, color: cs.error),
                  const SizedBox(width: 8),
                  Text(t.t('cart.coupon_invalid'), style: TextStyle(color: cs.error)),
                ]),
              ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TipsChooser(),
            ),
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
            OutlinedButton(onPressed: () => Navigator.pop(context), child: Text(t.t('cart.add_more'))),
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
                child: Text(t.t('cart.checkout')),
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
    final t = I18nProvider.of(context);
    final app = AppStateWidget.of(context);

    Widget tip(int v) => ChoiceChip(
      label: Text(v == 0 ? t.t('cart.no_tip') : '${t.t('currency.iqd_short')} ${formatIQD(v)}'),
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
  const PaymentSummary({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.service,
    required this.tips,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = I18nProvider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.t('cart.summary'), style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        _row(context, t.t('cart.subtotal'), subtotal),
        if (discount > 0) _row(context, t.t('cart.discount'), -discount, color: cs.secondary),
        _row(context, t.t('cart.delivery'), delivery),
        _row(context, t.t('cart.service'), service),
        if (tips > 0) _row(context, t.t('cart.tips'), tips),
        const Divider(),
        _row(context, t.t('cart.total'), total, bold: true, color: cs.primary),
      ]),
    );
  }

  Widget _row(BuildContext context, String label, int amount, {bool bold = false, Color? color}) {
    final cur = currencyLabel(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
        Text('${amount < 0 ? '-' : ''}$cur${formatIQD(amount.abs())}',
            style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: color)),
      ]),
    );
  }
}
