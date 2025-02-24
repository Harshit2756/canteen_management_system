class MemberIdModel {
  final String id;
  final String name;

  MemberIdModel({required this.id, required this.name});

  factory MemberIdModel.fromJson(Map<String, dynamic> json) => MemberIdModel(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
