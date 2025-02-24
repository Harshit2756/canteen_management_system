import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart'; 

/// User data model
///
/// Purpose:
/// - Define user data structure
/// - Handle user data serialization
/// - Provide user-related utility methods
///
/// Example JSON:
/// {
///   "id": 1,
///   "contractorId": null,
///   "name": "Parit",
///   "username": "whynotparit",
///   "mobile_number": "",
///   "role": "ADMIN"
/// }

@JsonSerializable()
class UserModel {
  final int id;
  // TODO: Uncomment the contractorId field when the API is ready
  // final int? contractorId;
  final String name;
  final String username;
  @JsonKey(name: 'mobile_number')
  final String? mobileNumber;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.mobileNumber,
    required this.role,
    // this.contractorId,
  });

  /// Creates a `UserModel` from JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Converts `UserModel` to JSON.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, username: $username, mobileNumber: $mobileNumber, role: $role}';
  }
}
