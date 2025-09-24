import 'localized.dart';

class AppUser {
  final String email;
  final String name;
  const AppUser({required this.email, required this.name});
}

class Restaurant {
  final LocalizedText name;
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

  factory Restaurant.fromJson(Map<String, dynamic> j) {
    return Restaurant(
      name: LocalizedText.custom(j, enKey: 'nameEn', arKey: 'nameAr'),
      rating: (j['rating'] as num).toDouble(),
      reviews: j['reviews'] as int,
      deliveryMinutesMin: j['deliveryMinutesMin'] as int,
      deliveryMinutesMax: j['deliveryMinutesMax'] as int,
      deliveryFee: j['deliveryFee'] as int,
      categories: (j['categories'] as List)
          .map((c) => MenuCategory.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MenuCategory {
  final String id;
  final LocalizedText name;
  final List<MenuItem> items;

  MenuCategory({required this.id, required this.name, required this.items});

  factory MenuCategory.fromJson(Map<String, dynamic> j) {
    return MenuCategory(
      id: j['id'] as String,
      name: LocalizedText.custom(j, enKey: 'nameEn', arKey: 'nameAr'),
      items: (j['items'] as List)
          .map((i) => MenuItem.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AddOn {
  final String id;
  final LocalizedText name;
  final int price;

  const AddOn({required this.id, required this.name, required this.price});

  factory AddOn.fromJson(Map<String, dynamic> j) {
    return AddOn(
      id: j['id'] as String,
      name: LocalizedText.custom(j, enKey: 'nameEn', arKey: 'nameAr'),
      price: j['price'] as int,
    );
  }
}

class MenuItem {
  final String id;
  final LocalizedText title;
  final LocalizedText description;
  final int price; // IQD
  final String imageUrl;
  final List<AddOn> addOns;

  const MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.addOns = const [],
  });

  factory MenuItem.fromJson(Map<String, dynamic> j) {
    return MenuItem(
      id: j['id'] as String,
      title: LocalizedText.custom(j, enKey: 'titleEn', arKey: 'titleAr'),
      description: LocalizedText.custom(j, enKey: 'descEn', arKey: 'descAr'),
      price: j['price'] as int,
      imageUrl: j['imageUrl'] as String,
      addOns: (j['addOns'] as List? ?? const [])
          .map((a) => AddOn.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
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
