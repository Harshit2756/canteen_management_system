import '../../app/data/models/network/member/member_model.dart';
import '../../app/data/models/network/plants/plants_model.dart';
import '../../app/data/models/network/meals/meals_request_model.dart';

class AddMembersArguments {
  final bool isEditing;
  final MemberModel? member;

  AddMembersArguments({required this.isEditing, this.member});
}

class AddVisitorArguments {
  final bool isEditing;
  final MealsRequestModel? visitor;

  AddVisitorArguments({required this.isEditing, this.visitor});
}

class MembersListViewArguments {
  final List<Member> members;
  final String plantId;

  MembersListViewArguments({required this.members, required this.plantId});
}
