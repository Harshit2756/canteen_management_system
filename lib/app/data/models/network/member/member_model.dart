import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class MemberModel {
  MemberModel({
    required this.id,
    required this.name,
    required this.username,
    required this.mobileNumber,
    required this.role,
    required this.manager,
    required this.contractorsCount,
    required this.createdAt,
    this.password,
  });

  final int id;
  final String name;
  final String username;
  final String? password;

  @JsonKey(name: 'mobile_number')
  final String mobileNumber;
  final String role;
  final String manager;

  @JsonKey(name: 'contractors_count')
  final num contractorsCount;
  final DateTime? createdAt;

  factory MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);

  @override
  String toString() {
    return "$id, $name, $username, $mobileNumber, $role, $manager, $contractorsCount, $createdAt, ";
  }
}

/*
{
	"id": 6,
	"name": "Siddharth Bhardwaj",
	"username": "siddharthbhard",
	"mobile_number": "1234567890",
	"role": "MANAGER",
	"manager": "Siddharth Bhardwaj",
	"contractors_count": 0,
	"createdAt": "2025-02-17T17:17:21.630Z"
}*/
