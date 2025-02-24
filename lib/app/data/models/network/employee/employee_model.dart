import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  EmployeeModel({
    required this.id,
    required this.name,
    required this.username,
    required this.mobileNumber,
    required this.role,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String username;

  @JsonKey(name: 'mobile_number')
  final String mobileNumber;
  final String role;
  final DateTime? createdAt;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  @override
  String toString() {
    return "$id, $name, $username, $mobileNumber, $role, $createdAt, ";
  }
}

/*
{
	"id": 8,
	"name": "Siddharth Bhardwaj",
	"username": "siddharthbhard",
	"mobile_number": "1234567890",
	"role": "EMPLOYEE",
	"createdAt": "2025-02-23T18:45:45.104Z"
}*/
