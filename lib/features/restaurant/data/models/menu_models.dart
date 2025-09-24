import 'package:freezed_annotation/freezed_annotation.dart';
part 'menu_models.freezed.dart';
part 'menu_models.g.dart';

@freezed
class Category with _$Category {
  const factory Category({required String id, required String name}) = _Category;
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({required String id, required String name, String? description, required double price, List<String>? tags, String? imageUrl}) = _MenuItem;
  factory MenuItem.fromJson(Map<String, dynamic> json) => _$MenuItemFromJson(json);
}

@freezed
class MenuPayload with _$MenuPayload {
  const factory MenuPayload({required List<Category> categories, required List<MenuItem> items}) = _MenuPayload;
  factory MenuPayload.fromJson(Map<String, dynamic> json) => _$MenuPayloadFromJson(json);
}
