// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColumnModel _$ColumnModelFromJson(Map<String, dynamic> json) => ColumnModel(
      field: json['field'] as String?,
      headerName: json['headerName'] as String?,
      sortable: json['sortable'] as bool?,
    );

Map<String, dynamic> _$ColumnModelToJson(ColumnModel instance) =>
    <String, dynamic>{
      'field': instance.field,
      'headerName': instance.headerName,
      'sortable': instance.sortable,
    };
