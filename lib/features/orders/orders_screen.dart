import 'package:flutter/material.dart';
import '../../src/state/app_state.dart';
import '../../src/utils/helpers.dart';
import '../../src/models/models.dart';
import '../../src/i18n/i18n.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = I18nProvider.of(context);
    final app = AppStateWidget.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.t('orders.title'))),
      body: app.orders.isEmpty
          ? const _EmptyOrders()
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final o = app.orders[i];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.restaurant)),
              title: Text(textOf(context, app.restaurant.name), maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                '${formatDate(context, o.dateTime)}  •  ${o.lines.length} ${t.t('orders.items')}\n'
                    '${t.t('orders.id')}: ${o.id}\n'
                    '${t.t('orders.user')}: ${o.customerEmail}',
              ),
              isThreeLine: true,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${currencyLabel(context)}${formatIQD(o.total)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: o)),
              ),
            ),
          );
        },
        separatorBuilder: (context, __) => const SizedBox(height: 8),
        itemCount: app.orders.length,
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();
  @override
  Widget build(BuildContext context) {
    final t = I18nProvider.of(context);
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: cs.outline),
          const SizedBox(height: 12),
          Text(t.t('orders.empty')),
          const SizedBox(height: 6),
          Text(t.t('orders.empty_hint'), style: TextStyle(color: cs.onSurface.withOpacity(.7))),
        ]),
      ),
    );
  }
}

class OrderTrackingScreen extends StatefulWidget {
  final Order? order;
  const OrderTrackingScreen({super.key, this.order});
  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late OrderStatus status;

  @override
  void initState() {
    super.initState();
    status = widget.order?.status ?? OrderStatus.preparing;
  }

  @override
  Widget build(BuildContext context) {
    final t = I18nProvider.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(t.t('orders.track'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          StatusTile(label: t.t('orders.status.preparing'), active: status.index >= OrderStatus.preparing.index, color: cs.primary),
          StatusTile(label: t.t('orders.status.picked'), active: status.index >= OrderStatus.pickedUp.index, color: cs.secondary),
          StatusTile(label: t.t('orders.status.onway'), active: status.index >= OrderStatus.onTheWay.index, color: cs.tertiary),
          StatusTile(label: t.t('orders.status.delivered'), active: status.index >= OrderStatus.delivered.index, color: Colors.teal),
          const Spacer(),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: status == OrderStatus.delivered ? null : () => setState(() => status = OrderStatus.pickedUp),
                child: Text(t.t('orders.mark_picked')),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: status.index >= OrderStatus.onTheWay.index || status == OrderStatus.delivered ? null : () => setState(() => status = OrderStatus.onTheWay),
                child: Text(t.t('orders.mark_onway')),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: status == OrderStatus.delivered ? null : () => setState(() => status = OrderStatus.delivered),
                child: Text(t.t('orders.mark_delivered')),
              ),
            ),
          ])
        ]),
      ),
    );
  }
}

class StatusTile extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  const StatusTile({super.key, required this.label, required this.active, required this.color});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(active ? Icons.check_circle : Icons.radio_button_unchecked, color: active ? color : cs.outline),
      title: Text(label, style: TextStyle(color: active ? cs.onSurface : cs.onSurface.withOpacity(.7))),
    );
  }
}
