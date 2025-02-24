class MealsIdModel {
  final int id;
  final String name;

  MealsIdModel({required this.id, required this.name});

  factory MealsIdModel.fromJson(Map<String, dynamic> json) => MealsIdModel(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  String toString() => 'PlantsIdModel(id: $id, name: $name)';
}
