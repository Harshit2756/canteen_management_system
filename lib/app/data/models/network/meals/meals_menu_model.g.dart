// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meals_menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealsMenuModel _$MealsMenuModelFromJson(Map<String, dynamic> json) =>
    MealsMenuModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: json['price'] as num,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MealsMenuModelToJson(MealsMenuModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
