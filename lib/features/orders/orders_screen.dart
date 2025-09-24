import 'package:flutter/material.dart';
import '../../src/models/models.dart';
import '../../src/state/app_state.dart';
import '../../src/utils/helpers.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: app.orders.isEmpty
          ? const _EmptyOrders()
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final o = app.orders[i];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.restaurant)),
              title: Text(app.restaurant.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('${formatDate(o.dateTime)}  •  ${o.lines.length} عنصر\nرقم الطلب: ${o.id}\nالمستخدم: ${o.customerEmail}'),
              isThreeLine: true,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('د.ع ${formatIQD(o.total)}', style: const TextStyle(fontWeight: FontWeight.w700))],
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
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: cs.outline),
          const SizedBox(height: 12),
          const Text('ما عندك طلبات بعد'),
          const SizedBox(height: 6),
          Text('بلّش تختار أكلك من قائمة المطعم', style: TextStyle(color: cs.onSurface.withOpacity(.7))),
        ]),
      ),
    );
  }
}

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, size: 96, color: Color(0xFF34D399)),
            const SizedBox(height: 16),
            const Text('تم تأكيد طلبك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('الراكب راح يوصل تقريبًا خلال 15 - 25 دقيقة'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
                    (route) => false,
              ),
              child: const Text('تتبع الطلب'),
            ),
          ]),
        ),
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
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          StatusTile(label: 'جاري التحضير', active: status.index >= OrderStatus.preparing.index, color: cs.primary),
          StatusTile(label: 'تم الاستلام من المطعم', active: status.index >= OrderStatus.pickedUp.index, color: cs.secondary),
          StatusTile(label: 'في الطريق إليك', active: status.index >= OrderStatus.onTheWay.index, color: cs.tertiary),
          StatusTile(label: 'تم التسليم', active: status.index >= OrderStatus.delivered.index, color: Colors.teal),
          const Spacer(),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: status == OrderStatus.delivered ? null : () => setState(() => status = OrderStatus.pickedUp),
                child: const Text('تحديد: تم الاستلام'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: status.index >= OrderStatus.onTheWay.index || status == OrderStatus.delivered ? null : () => setState(() => status = OrderStatus.onTheWay),
                child: const Text('تحديد: في الطريق'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: status == OrderStatus.delivered ? null : () => setState(() => status = OrderStatus.delivered),
                child: const Text('تحديد: تم التسليم'),
              ),
            ),
          ])
        ]),
      ),
    );
  }
}

class StatusTile extends StatelessWidget {
  final String label; final bool active; final Color color;
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

