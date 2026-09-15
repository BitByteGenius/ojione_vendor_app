class PropertyImageModel {
  final String id;
  final String url;
  final bool isFeatured;
  final String? caption;

  PropertyImageModel({
    required this.id,
    required this.url,
    this.isFeatured = false,
    this.caption,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'is_featured': isFeatured,
      'caption': caption,
    };
  }
}

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
