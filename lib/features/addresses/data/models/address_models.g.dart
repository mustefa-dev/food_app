// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressImpl _$$AddressImplFromJson(Map<String, dynamic> json) =>
    _$AddressImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      street: json['street'] as String,
      city: json['city'] as String?,
      isDefault: json['isDefault'] as bool?,
    );

Map<String, dynamic> _$$AddressImplToJson(_$AddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'street': instance.street,
      'city': instance.city,
      'isDefault': instance.isDefault,
    };
