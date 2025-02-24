// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meals_reports_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealsReportsModel _$MealsReportsModelFromJson(Map<String, dynamic> json) =>
    MealsReportsModel(
      id: (json['id'] as num).toInt(),
      ticketId: json['ticketId'] as String,
      mealName: json['mealName'] as String,
      quantity: json['quantity'] as num,
      requestedBy: json['requestedBy'] as String,
      plantName: json['plantName'] as String,
      serveTime: json['serveTime'] == null
          ? null
          : DateTime.parse(json['serveTime'] as String),
      consumeTime: json['consumeTime'],
      status: json['status'] as String,
    );

Map<String, dynamic> _$MealsReportsModelToJson(MealsReportsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'mealName': instance.mealName,
      'quantity': instance.quantity,
      'requestedBy': instance.requestedBy,
      'plantName': instance.plantName,
      'serveTime': instance.serveTime?.toIso8601String(),
      'consumeTime': instance.consumeTime,
      'status': instance.status,
    };
