// Models used across the app

class AppUser {
  final String email;
  final String name;
  const AppUser({required this.email, required this.name});
}

class Restaurant {
  final String name;
  final double rating;
  final int reviews;
  final int deliveryMinutesMin;
  final int deliveryMinutesMax;
  final int deliveryFee;
  final List<MenuCategory> categories;
  Restaurant({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.deliveryMinutesMin,
    required this.deliveryMinutesMax,
    required this.deliveryFee,
    required this.categories,
  });
}

class MenuCategory {
  final String id;
  final String name;
  final List<MenuItem> items;
  MenuCategory({required this.id, required this.name, required this.items});
}

class AddOn {
  final String id;
  final String name;
  final int price;
  const AddOn({required this.id, required this.name, required this.price});
}

class MenuItem {
  final String id;
  final String title;
  final String description;
  final int price; // IQD
  final String imageUrl;
  final List<AddOn> addOns; // optional add-ons
  const MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.addOns = const [],
  });
}

class CartLine {
  final MenuItem item;
  final List<AddOn> selectedAddOns;
  const CartLine({required this.item, this.selectedAddOns = const []});

  int get addOnsPrice => selectedAddOns.fold(0, (s, a) => s + a.price);
  int get unitPrice => item.price + addOnsPrice;
  int get totalPrice => unitPrice;

  @override
  bool operator ==(Object other) {
    if (other is! CartLine) return false;
    if (other.item.id != item.id) return false;
    if (other.selectedAddOns.length != selectedAddOns.length) return false;
    final a = [...selectedAddOns]..sort((x, y) => x.id.compareTo(y.id));
    final b = [...other.selectedAddOns]..sort((x, y) => x.id.compareTo(y.id));
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(item.id, selectedAddOns.map((e) => e.id).join(','));
}

class Address {
  final String label;
  final String details;
  const Address({required this.label, required this.details});
}

enum OrderStatus { preparing, pickedUp, onTheWay, delivered }

class Order {
  final String id;
  final DateTime dateTime;
  final Map<CartLine, int> lines;
  final int subtotal;
  final int deliveryFee;
  final int serviceFee;
  final int tips;
  final int discount;
  final int total;
  final String address;
  final String paymentMethod;
  final String customerEmail;
  OrderStatus status;
  Order({
    required this.id,
    required this.dateTime,
    required this.lines,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.tips,
    required this.discount,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.customerEmail,
    required this.status,
  });
}

class CheckoutInfo {
  String address;
  String paymentMethod;
  CheckoutInfo({required this.address, required this.paymentMethod});
}

