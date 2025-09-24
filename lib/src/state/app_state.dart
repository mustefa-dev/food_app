import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/models.dart';
import '../data/demo_data.dart';

class AppState extends ChangeNotifier {
  // --- AUTH (Demo) ---
  final Map<String, String> _users = {
    'demo@hallglow.com': '123456',
  };

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<String?> signIn(String email, String password) async {
    final ok = _users[email] == password;
    if (!ok) return 'الإيميل أو كلمة المرور غير صحيحة';
    _currentUser = AppUser(email: email, name: email.split('@').first);
    notifyListeners();
    return null;
  }

  Future<String?> signUp(String name, String email, String password) async {
    if (_users.containsKey(email)) return 'هذا الإيميل مسجّل مسبقًا';
    _users[email] = password;
    _currentUser = AppUser(email: email, name: name);
    notifyListeners();
    return null;
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }

  // --- RESTAURANT ---
  final Restaurant restaurant = demoRestaurant;

  // --- CART ---
  final Map<CartLine, int> _cart = {};
  Map<CartLine, int> get cart => Map.unmodifiable(_cart);
  int get cartCount => _cart.values.fold(0, (a, b) => a + b);
  int get subtotal => _cart.entries.fold(0, (sum, e) => sum + e.key.totalPrice * e.value);

  int deliveryFee = 1000;
  int serviceFee = 500;
  int tips = 0;
  int freeDeliveryThreshold = 15000;

  // كوبون بسيط: HAL10 = خصم 10%
  String? appliedCoupon;
  int get discount => appliedCoupon == 'HAL10' ? (subtotal * 0.10).round() : 0;

  void applyCoupon(String? code) {
    if (code == null || code.isEmpty) {
      appliedCoupon = null;
    } else if (code.toUpperCase() == 'HAL10') {
      appliedCoupon = 'HAL10';
    } else {
      appliedCoupon = null;
    }
    notifyListeners();
  }

  void setTips(int value) { tips = value; notifyListeners(); }

  int get totalBeforeFees => subtotal - discount;
  int get finalTotal => totalBeforeFees + (isFreeDelivery ? 0 : deliveryFee) + serviceFee + tips;
  bool get isFreeDelivery => totalBeforeFees >= freeDeliveryThreshold;
  int get remainingForFreeDelivery => (freeDeliveryThreshold - totalBeforeFees).clamp(0, 1 << 31);

  void addToCart(MenuItem item, {int quantity = 1, List<AddOn> addOns = const []}) {
    final line = CartLine(item: item, selectedAddOns: addOns);
    final existingKey = _cart.keys.firstWhere((k) => k == line, orElse: () => line);
    _cart.update(existingKey, (q) => q + quantity, ifAbsent: () => quantity);
    notifyListeners();
  }

  void setQty(CartLine line, int qty) {
    if (qty <= 0) {
      _cart.remove(line);
    } else {
      _cart[line] = qty;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    appliedCoupon = null;
    tips = 0;
    notifyListeners();
  }

  final List<Address> savedAddresses = const [
    Address(label: 'البيت', details: 'بغداد، حي المنصور، شارع 14 رمضان، بناية 12، ط3'),
    Address(label: 'العمل', details: 'بغداد، الكرادة داخل، قرب ساحة كهرمانة'),
  ];

  void placeOrder(CheckoutInfo info) {
    if (_cart.isEmpty) return;
    final order = Order(
      id: Random().nextInt(999999999).toString().padLeft(9, '0'),
      dateTime: DateTime.now(),
      lines: Map.of(_cart),
      subtotal: subtotal,
      deliveryFee: isFreeDelivery ? 0 : deliveryFee,
      serviceFee: serviceFee,
      tips: tips,
      discount: discount,
      total: finalTotal,
      address: info.address,
      paymentMethod: info.paymentMethod,
      customerEmail: _currentUser?.email ?? 'guest',
      status: OrderStatus.preparing,
    );
    orders.insert(0, order);
    clearCart();
  }

  final List<Order> orders = [];
}

class AppStateWidget extends InheritedNotifier<AppState> {
  const AppStateWidget({super.key, required super.child, required AppState state}) : super(notifier: state);
  static AppState of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<AppStateWidget>();
    assert(w != null, 'No AppStateWidget found');
    return w!.notifier!;
  }
}

