class DishOption {
  final String label;
  final double price;
  const DishOption(this.label, this.price);

  Map<String, dynamic> toJson() => {'label': label, 'price': price};
}

class Dish {
  final String id;
  final String name;
  final String category;
  final String image;
  final String description;
  final double basePrice;
  final double rating;
  final int reviews;
  final List<String> ingredients;
  final List<String> nutrition;
  final List<DishOption> sizes;
  final List<DishOption> extras;

  const Dish({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.description,
    required this.basePrice,
    required this.rating,
    required this.reviews,
    required this.ingredients,
    required this.nutrition,
    required this.sizes,
    required this.extras,
  });
}