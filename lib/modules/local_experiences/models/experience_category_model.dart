class ExperienceCategoryModel {
  final String id;
  final String name; // e.g. 'Craft Workshop', 'Food Tour', 'Village Walk', 'Nature Trek'
  final String icon;

  ExperienceCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory ExperienceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExperienceCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? 'local_activity',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
