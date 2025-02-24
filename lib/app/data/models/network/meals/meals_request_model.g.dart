// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meals_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealsRequestModel _$MealsRequestModelFromJson(Map<String, dynamic> json) =>
    MealsRequestModel(
      id: (json['id'] as num).toInt(),
      ticketId: json['ticketId'] as String,
      mealName: json['mealName'] as String,
      quantity: json['quantity'] as num,
      price: json['price'] as num,
      status: json['status'] as String,
      requestedBy: json['requestedBy'] as String,
      plantName: json['plantName'] as String,
      requestTime: json['requestTime'] == null
          ? null
          : DateTime.parse(json['requestTime'] as String),
      remarks: json['remarks'] as String,
    );

Map<String, dynamic> _$MealsRequestModelToJson(MealsRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'mealName': instance.mealName,
      'quantity': instance.quantity,
      'price': instance.price,
      'status': instance.status,
      'requestedBy': instance.requestedBy,
      'plantName': instance.plantName,
      'requestTime': instance.requestTime?.toIso8601String(),
      'remarks': instance.remarks,
    };
