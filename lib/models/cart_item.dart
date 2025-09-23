import 'dish.dart';

class CartItem {
  final Dish dish;
  final DishOption size;
  final List<DishOption> extras;
  int qty;

  CartItem({
    required this.dish,
    required this.size,
    required this.extras,
    this.qty = 1,
  });

  double get unitPrice =>
      size.price + extras.fold(0, (a, e) => a + e.price);

  double get total => unitPrice * qty;
}