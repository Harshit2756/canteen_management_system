class PlantsIdModel {
  final int id;
  final String name;

  PlantsIdModel({required this.id, required this.name});

  factory PlantsIdModel.fromJson(Map<String, dynamic> json) => PlantsIdModel(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  String toString() => 'PlantsIdModel(id: $id, name: $name)';
}
