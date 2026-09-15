class DestinationModel {
  final String id;
  final String name;
  final String state;
  final String description;
  final String imageUrl;

  DestinationModel({
    required this.id,
    required this.name,
    required this.state,
    required this.description,
    required this.imageUrl,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      state: json['state'] ?? 'Assam',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'description': description,
      'image_url': imageUrl,
    };
  }
}
