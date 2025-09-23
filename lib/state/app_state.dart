import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class AppState extends ChangeNotifier {
  final cart = <CartItem>[];

  double get subtotal => cart.fold(0.0, (a, i) => a + i.total);

  void addToCart(CartItem item) {
    cart.add(item);
    notifyListeners();
  }

  void updateQty(int index, int qty) {
    if (index < 0 || index >= cart.length) return;
    cart[index].qty = qty.clamp(1, 999);
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= cart.length) return;
    cart.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }
}