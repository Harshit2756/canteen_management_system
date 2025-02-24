// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSummaryModel _$DashboardSummaryModelFromJson(
        Map<String, dynamic> json) =>
    DashboardSummaryModel(
      todayVisitCount: json['todayVisitCount'] as num,
      pendingRequestCount: json['pendingRequestCount'] as num,
      monthlyVisitsCount: json['monthlyVisitsCount'] as num,
      approvedVisitsCount: json['approvedVisitsCount'] as num,
    );

Map<String, dynamic> _$DashboardSummaryModelToJson(
        DashboardSummaryModel instance) =>
    <String, dynamic>{
      'todayVisitCount': instance.todayVisitCount,
      'pendingRequestCount': instance.pendingRequestCount,
      'monthlyVisitsCount': instance.monthlyVisitsCount,
      'approvedVisitsCount': instance.approvedVisitsCount,
    };
