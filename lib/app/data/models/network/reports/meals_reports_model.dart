import 'package:json_annotation/json_annotation.dart';

part 'meals_reports_model.g.dart';

@JsonSerializable()
class MealsReportsModel {
  MealsReportsModel({
    required this.id,
    required this.ticketId,
    required this.mealName,
    required this.quantity,
    required this.requestedBy,
    required this.plantName,
    required this.serveTime,
    required this.consumeTime,
    required this.status,
  });

  final int id;
  final String ticketId;
  final String mealName;
  final num quantity;
  final String requestedBy;
  final String plantName;
  final DateTime? serveTime;
  final dynamic consumeTime;
  final String status;

  factory MealsReportsModel.fromJson(Map<String, dynamic> json) => _$MealsReportsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealsReportsModelToJson(this);

  @override
  String toString() {
    return "$id, $ticketId, $mealName, $quantity, $requestedBy, $plantName, $serveTime, $consumeTime, $status, ";
  }
}

/*
{
	"id": 1,
	"ticketId": "MEAL-6480F918",
	"mealName": "Test Meal",
	"quantity": 1,
	"requestedBy": "Admin",
	"plantName": "Test Plant",
	"serveTime": "2025-02-23T08:25:44.722Z",
	"consumeTime": null,
	"status": "SERVED"
}*/
