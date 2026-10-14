class CompanyLocationModel {
  const CompanyLocationModel({required this.id, required this.name});

  final int id;
  final String name;

  factory CompanyLocationModel.fromJson(Map<String, dynamic> json) {
    return CompanyLocationModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
