import '../../../l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart' as mock;
import '../../../models/cart_item.dart';
import '../../../state/app_state.dart';

class DishPage extends StatefulWidget {
  final String dishId;
  const DishPage({super.key, required this.dishId});

  @override
  State<DishPage> createState() => _DishPageState();
}

class _DishPageState extends State<DishPage> {
  int sizeIndex = 0;
  final extras = <int>{};
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final dish = mock.dishes.firstWhere((d) => d.id == widget.dishId, orElse: () => mock.dishes.first);
    final size = dish.sizes[sizeIndex];
    final extrasTotal = extras.fold<double>(0, (a, i) => a + dish.extras[i].price);
    final total = (size.price + extrasTotal) * qty;

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // Hero Image with App Bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: kPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    dish.image,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dish Info
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dish.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${dish.rating}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              ' (${dish.reviews} reviews)',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$${dish.basePrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: kPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          dish.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nutrition Info
                        Wrap(
                          spacing: 8,
                          children: dish.nutrition.map((n) => Chip(
                            label: Text(n, style: const TextStyle(fontSize: 12)),
                            backgroundColor: kSecondary.withOpacity(0.1),
                            labelStyle: const TextStyle(color: kSecondary),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Size Options
                  if (dish.sizes.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Size',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...dish.sizes.asMap().entries.map((entry) {
                            final index = entry.key;
                            final sizeOption = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap: () => setState(() => sizeIndex = index),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: sizeIndex == index ? kSecondary : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: sizeIndex == index ? kSecondary : Colors.grey[400]!,
                                            width: 2,
                                          ),
                                          color: sizeIndex == index ? kSecondary : Colors.transparent,
                                        ),
                                        child: sizeIndex == index
                                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                                          : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          sizeOption.label,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: sizeIndex == index ? kSecondary : Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '\$${sizeOption.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: sizeIndex == index ? kSecondary : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],

                  // Extras
                  if (dish.extras.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add extras',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...dish.extras.asMap().entries.map((entry) {
                            final index = entry.key;
                            final extra = entry.value;
                            final isSelected = extras.contains(index);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap: () => setState(() {
                                  if (isSelected) {
                                    extras.remove(index);
                                  } else {
                                    extras.add(index);
                                  }
                                }),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected ? kSecondary : Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: isSelected ? kSecondary : Colors.grey[400]!,
                                            width: 2,
                                          ),
                                          color: isSelected ? kSecondary : Colors.transparent,
                                        ),
                                        child: isSelected
                                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                                          : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          extra.label,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected ? kSecondary : Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '+\$${extra.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? kSecondary : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Add to Cart Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: qty > 1 ? () => setState(() => qty--) : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      '$qty',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => qty++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final app = context.read<AppState>();
                    app.addToCart(CartItem(
                      dish: dish,
                      size: size,
                      extras: extras.map((i) => dish.extras[i]).toList(),
                      qty: qty,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart!'),
                        backgroundColor: kSecondary,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add to Cart  •  \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}