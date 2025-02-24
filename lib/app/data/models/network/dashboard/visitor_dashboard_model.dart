import 'package:json_annotation/json_annotation.dart';

part 'visitor_dashboard_model.g.dart';

@JsonSerializable()
class VisitorDashboardModel {
  final int id;
  final String ticketId;
  final String name;
  final String? companyName;
  final String? visitPurpose;
  final String? meetingWith;
  final String? status;
  final String? plantName;
  final DateTime? entryTime;
  final DateTime? exitTime;
  final DateTime? requestTime;
  final String? remarks;

  VisitorDashboardModel({
    required this.id,
    required this.ticketId,
    required this.name,
    this.companyName,
    this.visitPurpose,
    this.meetingWith,
    this.status,
    this.plantName,
    this.entryTime,
    this.exitTime,
    this.requestTime,
    this.remarks,
  });

  factory VisitorDashboardModel.fromJson(Map<String, dynamic> json) => _$VisitorDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorDashboardModelToJson(this);

  @override
  String toString() {
    return "$id, $ticketId, $name, $companyName, $visitPurpose, $meetingWith, $status, $plantName, $entryTime, $exitTime, $requestTime, $remarks";
  }
}
