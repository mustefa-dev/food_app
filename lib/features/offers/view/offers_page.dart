import 'package:flutter/material.dart';
import '../../../widgets/app_bar.dart';
import '../../../theme/app_theme.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: const AppTopBar(title: 'Offers', showBack: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              margin: const EdgeInsets.all(16),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF06C167), Color(0xFF04A355)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
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
                          'Free Delivery',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'On orders over \$25',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Order now',
                            style: TextStyle(
                              color: kSecondary,
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

            // Categories
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Promotions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Offer Cards
            ..._buildOfferCards(),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Restaurant Offers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Restaurant Offers
            ..._buildRestaurantOffers(),

            const SizedBox(height: 100), // Bottom padding for navigation bar
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOfferCards() {
    final offers = [
      {
        'title': '25% Off',
        'subtitle': 'On your first 3 orders',
        'code': 'FIRST25',
        'color': const Color(0xFFFF6B35),
        'icon': Icons.local_fire_department,
      },
      {
        'title': 'Free Delivery',
        'subtitle': 'No minimum order',
        'code': 'FREEDEL',
        'color': const Color(0xFF4285F4),
        'icon': Icons.delivery_dining,
      },
      {
        'title': 'Buy 1 Get 1',
        'subtitle': 'On selected items',
        'code': 'BOGO',
        'color': const Color(0xFFE91E63),
        'icon': Icons.card_giftcard,
      },
    ];

    return offers.map((offer) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (offer['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  offer['icon'] as IconData,
                  color: offer['color'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      offer['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kSecondary, width: 1),
                ),
                child: Text(
                  offer['code'] as String,
                  style: const TextStyle(
                    color: kSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )).toList();
  }

  List<Widget> _buildRestaurantOffers() {
    final restaurants = [
      {
        'name': 'Pizza Palace',
        'offer': '30% off orders over \$20',
        'time': '25-35 min',
        'rating': '4.8',
        'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?q=80&w=400&auto=format&fit=crop',
        'tag': 'Popular',
      },
      {
        'name': 'Burger Barn',
        'offer': 'Free fries with any burger',
        'time': '15-25 min',
        'rating': '4.6',
        'image': 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=400&auto=format&fit=crop',
        'tag': 'Fast',
      },
      {
        'name': 'Sushi Spot',
        'offer': 'Buy 2 get 1 free rolls',
        'time': '30-40 min',
        'rating': '4.9',
        'image': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?q=80&w=400&auto=format&fit=crop',
        'tag': 'Premium',
      },
    ];

    return restaurants.map((restaurant) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    restaurant['image'] as String,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                    child: Text(
                      restaurant['tag'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                          restaurant['rating'] as String,
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['name'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant['offer'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['time'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Order Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
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
    )).toList();
  }
}
