import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/app_bar.dart';
import '../../../theme/app_theme.dart';
import '../../../state/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: const AppTopBar(title: 'Account', showBack: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Header
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: kSecondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: kSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@email.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: kSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Gold Member',
                      style: TextStyle(
                        color: kSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Stats
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          '24',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimary,
                          ),
                        ),
                        Text(
                          'Orders',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimary,
                          ),
                        ),
                        Text(
                          'Rating',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          '\$245',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimary,
                          ),
                        ),
                        Text(
                          'Saved',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Options
            _buildMenuSection('Orders & Favorites', [
              _MenuItem(Icons.receipt_long, 'Your orders', () => context.push('/tracking')),
              _MenuItem(Icons.favorite_outline, 'Favorites', () {}),
              _MenuItem(Icons.card_giftcard, 'Promotions', () => context.push('/offers')),
              _MenuItem(Icons.loyalty, 'Loyalty program', () => context.push('/loyalty')),
            ]),

            _buildMenuSection('Account Settings', [
              _MenuItem(Icons.person_outline, 'Manage account', () {}),
              _MenuItem(Icons.location_on_outlined, 'Address book', () {}),
              _MenuItem(Icons.payment, 'Payment methods', () {}),
              _MenuItem(Icons.notifications_outlined, 'Notifications', () {}),
            ]),

            _buildMenuSection('Support', [
              _MenuItem(Icons.help_outline, 'Get help', () => context.push('/support')),
              _MenuItem(Icons.feedback_outlined, 'Send feedback', () {}),
              _MenuItem(Icons.info_outline, 'About', () {}),
              _MenuItem(Icons.privacy_tip_outlined, 'Privacy policy', () {}),
            ]),

            const SizedBox(height: 20),

            // Sign Out Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await context.read<AuthState>().signOut();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signed out successfully'),
                        backgroundColor: kSecondary,
                      ),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100), // Bottom padding for navigation
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  ListTile(
                    leading: Icon(items[i].icon, color: Colors.grey[600]),
                    title: Text(
                      items[i].title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                    onTap: items[i].onTap,
                  ),
                  if (i < items.length - 1)
                    Divider(height: 1, color: Colors.grey[200]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItem(this.icon, this.title, this.onTap);
}
