// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitorDashboardModel _$VisitorDashboardModelFromJson(
        Map<String, dynamic> json) =>
    VisitorDashboardModel(
      id: (json['id'] as num).toInt(),
      ticketId: json['ticketId'] as String,
      name: json['name'] as String,
      companyName: json['companyName'] as String?,
      visitPurpose: json['visitPurpose'] as String?,
      meetingWith: json['meetingWith'] as String?,
      status: json['status'] as String?,
      plantName: json['plantName'] as String?,
      entryTime: json['entryTime'] == null
          ? null
          : DateTime.parse(json['entryTime'] as String),
      exitTime: json['exitTime'] == null
          ? null
          : DateTime.parse(json['exitTime'] as String),
      requestTime: json['requestTime'] == null
          ? null
          : DateTime.parse(json['requestTime'] as String),
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$VisitorDashboardModelToJson(
        VisitorDashboardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'name': instance.name,
      'companyName': instance.companyName,
      'visitPurpose': instance.visitPurpose,
      'meetingWith': instance.meetingWith,
      'status': instance.status,
      'plantName': instance.plantName,
      'entryTime': instance.entryTime?.toIso8601String(),
      'exitTime': instance.exitTime?.toIso8601String(),
      'requestTime': instance.requestTime?.toIso8601String(),
      'remarks': instance.remarks,
    };
