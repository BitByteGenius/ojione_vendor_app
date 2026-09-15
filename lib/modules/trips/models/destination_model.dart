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

class ItineraryDayModel {
  final int dayNumber;
  final String title;
  final String description;
  final List<String> activities;
  final String mealsIncluded;

  ItineraryDayModel({
    required this.dayNumber,
    required this.title,
    required this.description,
    required this.activities,
    required this.mealsIncluded,
  });

  factory ItineraryDayModel.fromJson(Map<String, dynamic> json) {
    return ItineraryDayModel(
      dayNumber: json['day_number'] ?? 1,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      activities: List<String>.from(json['activities'] ?? []),
      mealsIncluded: json['meals_included'] ?? 'Breakfast',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_number': dayNumber,
      'title': title,
      'description': description,
      'activities': activities,
      'meals_included': mealsIncluded,
    };
  }
}
