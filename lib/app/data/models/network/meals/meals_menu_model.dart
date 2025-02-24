import 'package:json_annotation/json_annotation.dart';

part 'meals_menu_model.g.dart';

@JsonSerializable()
class MealsMenuModel {
  MealsMenuModel({
    required this.id,
    required this.name,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final num price;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MealsMenuModel.fromJson(Map<String, dynamic> json) => _$MealsMenuModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealsMenuModelToJson(this);

  @override
  String toString() {
    return "$id, $name, $price, $createdAt, $updatedAt, ";
  }
}

/*
{
	"id": 1,
	"name": "Test Meal",
	"price": 150,
	"createdAt": "2025-02-22T05:19:32.972Z",
	"updatedAt": "2025-02-22T05:19:32.972Z"
}*/
