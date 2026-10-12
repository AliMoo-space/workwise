class ManagerModel {
  const ManagerModel({required this.id, required this.name});

  final int id;
  final String name;

  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return ManagerModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
