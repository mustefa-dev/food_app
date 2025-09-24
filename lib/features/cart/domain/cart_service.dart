import '../../restaurant/data/models/menu_models.dart';

class CartLine {
  final MenuItem item;
  int qty;
  CartLine(this.item, this.qty);
  double get total => item.price * qty;
}

class CartState {
  final List<CartLine> lines;
  CartState(this.lines);
  int get itemCount => lines.fold(0, (a, l) => a + l.qty);
  double get subtotal => lines.fold(0, (a, l) => a + l.total);
  double taxes([double rate = 0.1]) => subtotal * rate;
  double deliveryFee([double fee = 2.0]) => fee;
  double smallOrderFee([double threshold = 10.0, double fee = 1.0]) => subtotal < threshold ? fee : 0;
  double total() => subtotal + taxes() + deliveryFee() + smallOrderFee();
}
