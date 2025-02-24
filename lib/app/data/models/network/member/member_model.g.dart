// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      username: json['username'] as String,
      mobileNumber: json['mobile_number'] as String,
      role: json['role'] as String,
      manager: json['manager'] as String,
      contractorsCount: json['contractors_count'] as num,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      password: json['password'] as String?,
    );

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'password': instance.password,
      'mobile_number': instance.mobileNumber,
      'role': instance.role,
      'manager': instance.manager,
      'contractors_count': instance.contractorsCount,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
