// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plants_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantsModel _$PlantsModelFromJson(Map<String, dynamic> json) => PlantsModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String,
      plantHead: json['plantHead'],
      plantHeadId: json['plantHeadId'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      headUser: json['headUser'],
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['_count'] == null
          ? null
          : Count.fromJson(json['_count'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlantsModelToJson(PlantsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'plantHead': instance.plantHead,
      'plantHeadId': instance.plantHeadId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'headUser': instance.headUser,
      'members': instance.members,
      '_count': instance.count,
    };

Count _$CountFromJson(Map<String, dynamic> json) => Count(
      visitors: json['visitors'] as num,
    );

Map<String, dynamic> _$CountToJson(Count instance) => <String, dynamic>{
      'visitors': instance.visitors,
    };

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      id: (json['id'] as num).toInt(),
      plantId: json['plantId'] as num,
      userId: json['userId'] as num,
      hasAllAccess: json['hasAllAccess'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'plantId': instance.plantId,
      'userId': instance.userId,
      'hasAllAccess': instance.hasAllAccess,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'user': instance.user,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
    };
