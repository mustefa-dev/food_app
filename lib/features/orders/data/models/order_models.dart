import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_models.freezed.dart';
part 'order_models.g.dart';

@freezed
class Order with _$Order {
  const factory Order({required String id, required String restaurantName, required String status, required double total, required DateTime createdAt}) = _Order;
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
