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
