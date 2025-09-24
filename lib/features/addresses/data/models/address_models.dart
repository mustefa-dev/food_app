import 'package:freezed_annotation/freezed_annotation.dart';
part 'address_models.freezed.dart';
part 'address_models.g.dart';

@freezed
class Address with _$Address {
  const factory Address({required String id, required String label, required String street, String? city, bool? isDefault}) = _Address;
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}
