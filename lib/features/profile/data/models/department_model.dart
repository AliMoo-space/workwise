class DepartmentModel {
  const DepartmentModel({required this.id, required this.name});

  final int id;
  final String name;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
