class ShopCategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? parentCategoryId;

  ShopCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.parentCategoryId,
  });

  factory ShopCategoryModel.fromJson(Map<String, dynamic> json) {
    return ShopCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      parentCategoryId: json['parent_category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'parent_category_id': parentCategoryId,
    };
  }
}
