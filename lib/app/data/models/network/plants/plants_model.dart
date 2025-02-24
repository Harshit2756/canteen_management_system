import 'package:json_annotation/json_annotation.dart';

part 'plants_model.g.dart';

@JsonSerializable()
class PlantsModel {
  PlantsModel({
    required this.id,
    required this.name,
    required this.code,
    required this.plantHead,
    required this.plantHeadId,
    required this.createdAt,
    required this.updatedAt,
    required this.headUser,
    required this.members,
    required this.count,
  });

  final int id;
  final String name;
  final String code;
  final dynamic plantHead;
  final dynamic plantHeadId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic headUser;
  final List<Member>? members;

  @JsonKey(name: '_count')
  final Count? count;

  factory PlantsModel.fromJson(Map<String, dynamic> json) => _$PlantsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlantsModelToJson(this);

  @override
  String toString() {
    return "$id, $name, $code, $plantHead, $plantHeadId, $createdAt, $updatedAt, $headUser, $members, $count, ";
  }
}

@JsonSerializable()
class Count {
  Count({
    required this.visitors,
  });

  final num visitors;

  factory Count.fromJson(Map<String, dynamic> json) => _$CountFromJson(json);

  Map<String, dynamic> toJson() => _$CountToJson(this);

  @override
  String toString() {
    return "$visitors, ";
  }
}

@JsonSerializable()
class Member {
  Member({
    required this.id,
    required this.plantId,
    required this.userId,
    required this.hasAllAccess,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  final int id;
  final num plantId;
  final num userId;
  final bool hasAllAccess;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);

  @override
  String toString() {
    return "$id, $plantId, $userId, $hasAllAccess, $createdAt, $updatedAt, $user, ";
  }
}

@JsonSerializable()
class User {
  User({
    required this.name,
  });

  final String name;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "$name, ";
  }
}

/*
{
	"id": 1,
	"name": "Test Plant",
	"code": "PLT01",
	"plantHead": null,
	"plantHeadId": null,
	"createdAt": "2025-02-16T07:19:10.995Z",
	"updatedAt": "2025-02-16T07:19:10.995Z",
	"headUser": null,
	"members": [
		{
			"id": 1,
			"plantId": 1,
			"userId": 1,
			"hasAllAccess": true,
			"createdAt": "2025-02-16T10:16:07.377Z",
			"updatedAt": "2025-02-16T10:16:07.377Z",
			"user": {
				"name": "Rajesh Sharma"
			}
		}
	],
	"_count": {
		"visitors": 1
	}
}*/
