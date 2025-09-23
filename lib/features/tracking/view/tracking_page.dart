import '../../../l10n/l10n_ext.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/app_bar.dart';
import '../../../theme/app_theme.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  int eta = 24;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() => eta = eta > 0 ? eta - 1 : 0);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Order Confirmed', Icons.task_alt, 'Restaurant accepted your order'),
      ('Preparing', Icons.restaurant, 'Your food is being prepared'),
      ('Out for Delivery', Icons.delivery_dining, 'Driver is on the way'),
      ('Delivered', Icons.home_outlined, 'Enjoy your meal!'),
    ];
    int active = eta > 16 ? 0 : eta > 8 ? 1 : eta > 0 ? 2 : 3;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppTopBar(
        title: 'Order Tracking',
        actions: [
          IconButton(
            onPressed: () => context.push('/support'),
            icon: const Icon(Icons.support_agent, color: Colors.white),
          )
        ],
        showBack: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map Placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: Stack(
                children: [
                  // Mock map background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[100]!, Colors.green[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Mock delivery route
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.delivery_dining, color: kSecondary, size: 30),
                          const SizedBox(height: 4),
                          Text(
                            '${eta}m away',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ETA Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: kSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: kSecondary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eta > 0 ? 'Arriving in $eta minutes' : 'Delivered!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Order #12345',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (eta > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kSecondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Order Progress
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    final isActive = index == active;
                    final isCompleted = index < active;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isCompleted || isActive ? kSecondary : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCompleted ? Icons.check : step.$2,
                              color: isCompleted || isActive ? Colors.white : Colors.grey[600],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.$1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isCompleted || isActive ? Colors.black : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  step.$3,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isActive)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(kSecondary),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Driver Info
            if (active >= 2 && eta > 0) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Driver',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[600],
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Michael Johnson',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text('4.9 • Honda Civic'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.phone, color: kSecondary),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.message, color: kSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/support'),
                      icon: const Icon(Icons.help_outline),
                      label: const Text('Get Help'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kPrimary,
                        side: const BorderSide(color: kPrimary),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  if (eta == 0) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/'),
                        icon: const Icon(Icons.home),
                        label: const Text('Order Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }
}