import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../restaurant/data/models/menu_models.dart';
import '../domain/cart_service.dart';

final cartProvider = StateNotifierProvider<CartController, CartState>((ref) => CartController());

class CartController extends StateNotifier<CartState> {
  CartController() : super(CartState([]));

  void add(MenuItem item) {
    final lines = [...state.lines];
    final idx = lines.indexWhere((l) => l.item.id == item.id);
    if (idx == -1) {
      lines.add(CartLine(item, 1));
    } else {
      lines[idx].qty++;
    }
    state = CartState(lines);
  }

  void dec(String itemId) {
    final lines = [...state.lines];
    final idx = lines.indexWhere((l) => l.item.id == itemId);
    if (idx != -1) {
      lines[idx].qty--;
      if (lines[idx].qty <= 0) lines.removeAt(idx);
      state = CartState(lines);
    }
  }

  void remove(String itemId) {
    state = CartState(state.lines.where((l) => l.item.id != itemId).toList());
  }

  void clear() => state = CartState([]);
}
