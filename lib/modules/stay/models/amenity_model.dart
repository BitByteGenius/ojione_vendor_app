class AmenityModel {
  final String id;
  final String name;
  final String icon;
  final String category;

  AmenityModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? 'check_circle',
      category: json['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'category': category,
    };
  }
}
