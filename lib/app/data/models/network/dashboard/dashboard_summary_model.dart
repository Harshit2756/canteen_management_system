import 'package:json_annotation/json_annotation.dart';

part 'dashboard_summary_model.g.dart';

@JsonSerializable()
class DashboardSummaryModel {
  DashboardSummaryModel({
    required this.todayVisitCount,
    required this.pendingRequestCount,
    required this.monthlyVisitsCount,
    required this.approvedVisitsCount,
  });

  final num todayVisitCount;
  final num pendingRequestCount;
  final num monthlyVisitsCount;
  final num approvedVisitsCount;

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) => _$DashboardSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryModelToJson(this);

  @override
  String toString() {
    return "$todayVisitCount, $pendingRequestCount, $monthlyVisitsCount, $approvedVisitsCount, ";
  }
}

/*
{
	"todayVisitCount": 1,
	"pendingRequestCount": 0,
	"monthlyVisitsCount": 1,
	"approvedVisitsCount": 1
}*/
