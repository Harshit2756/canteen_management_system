import 'package:json_annotation/json_annotation.dart';

part 'column_model.g.dart';

@JsonSerializable()
class ColumnModel {
  ColumnModel({this.field, this.headerName, this.sortable});

  final String? field;
  final String? headerName;
  final bool? sortable;

  factory ColumnModel.fromJson(Map<String, dynamic> json) => _$ColumnModelFromJson(json);

  Map<String, dynamic> toJson() => _$ColumnModelToJson(this);

  @override
  String toString() {
    return "$field, $headerName, $sortable, ";
  }
}

/*
{
	"field": "quantity",
	"headerName": "Quantity",
	"width": 100,
	"sortable": true
}*/
