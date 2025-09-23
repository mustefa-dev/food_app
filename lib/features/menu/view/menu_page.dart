import '../../../l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/app_bar.dart';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart' as mock;

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String active = 'mains';

  @override
  Widget build(BuildContext context) {
    final items = mock.dishes.where((d) => d.category == active).toList();
    return Scaffold(
      backgroundColor: kBackground,
      appBar: const AppTopBar(title: 'Menu', showBack: false),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: mock.categories.length,
              itemBuilder: (context, index) {
                final category = mock.categories[index];
                final isActive = active == category['id'];
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => setState(() => active = category['id'] as String),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? kPrimary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive ? kPrimary : Colors.grey[300]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category['name'] as String,
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final dish = items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    child: InkWell(
                      onTap: () => context.push('/dish/${dish.id}'),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dish.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dish.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.yellow, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${dish.rating}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        ' (${dish.reviews})',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${dish.basePrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    dish.image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: kSecondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}