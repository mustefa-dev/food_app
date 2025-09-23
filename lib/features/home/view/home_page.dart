import '../../../l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart' as mock;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with location
            SliverToBoxAdapter(
              child: Container(
                color: kPrimary,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: kSecondary, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Downtown, New York',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                          onPressed: () => context.push('/cart'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for food or restaurants',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Hero Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?q=80&w=400&auto=format&fit=crop',
                              width: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Get delivery in\nas fast as 15 min',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: kSecondary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Order now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Categories
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: mock.categories.length,
                      itemBuilder: (context, index) {
                        final category = mock.categories[index];
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 16),
                          child: InkWell(
                            onTap: () => context.push('/menu'),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      category['emoji'] as String,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recommended Restaurants
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Popular near you',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Restaurant Cards
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final dish = mock.dishes[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      child: InkWell(
                        onTap: () => context.push('/dish/${dish.id}'),
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.network(
                                    dish.image,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star, color: Colors.yellow, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          dish.rating.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: kSecondary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      '15-25 min',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dish.name,
                                    style: const TextStyle(
                                      fontSize: 18,
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
                                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        '15-25 min',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(Icons.delivery_dining, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Free delivery',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const Spacer(),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: mock.dishes.length,
              ),
            ),

            // Bottom padding for navigation bar
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}