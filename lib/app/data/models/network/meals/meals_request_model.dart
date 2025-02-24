import 'package:json_annotation/json_annotation.dart';

part 'meals_request_model.g.dart';

@JsonSerializable()
class MealsRequestModel {
  MealsRequestModel({
    required this.id,
    required this.ticketId,
    required this.mealName,
    required this.quantity,
    required this.price,
    required this.status,
    required this.requestedBy,
    required this.plantName,
    required this.requestTime,
    required this.remarks,
  });

  final int id;
  final String ticketId;
  final String mealName;
  final num quantity;
  final num price;
  final String status;
  final String requestedBy;
  final String plantName;
  final DateTime? requestTime;
  final String remarks;

  factory MealsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MealsRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealsRequestModelToJson(this);

  @override
  String toString() {
    return "$id, $ticketId, $mealName, $quantity, $price, $status, $requestedBy, $plantName, $requestTime, $remarks, ";
  }
}

/*
{
	"id": 1,
	"ticketId": "MEAL-6480F918",
	"mealName": "Test Meal",
	"quantity": 1,
	"price": 150,
	"status": "PENDING",
	"requestedBy": "Admin",
	"plantName": "Test Plant",
	"requestTime": "2025-02-22T05:22:54.625Z",
	"remarks": "-"
}*/
