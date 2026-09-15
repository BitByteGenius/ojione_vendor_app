import 'itinerary_model.dart';

class TripPackageModel {
  final String id;
  final String title;
  final String description;
  final int durationDays;
  final int durationNights;
  final double pricePerPerson;
  final int minGroupSize;
  final int maxGroupSize;
  final List<String> destinations;
  final List<String> inclusions;
  final List<String> exclusions;
  final List<ItineraryDayModel> itinerary;
  final String status; // 'published', 'draft', 'pending_approval'
  final double rating;
  final int reviewsCount;
  final DateTime createdAt;

  TripPackageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationDays,
    required this.durationNights,
    required this.pricePerPerson,
    this.minGroupSize = 2,
    this.maxGroupSize = 15,
    required this.destinations,
    required this.inclusions,
    required this.exclusions,
    required this.itinerary,
    required this.status,
    this.rating = 4.8,
    this.reviewsCount = 18,
    required this.createdAt,
  });

  factory TripPackageModel.fromJson(Map<String, dynamic> json) {
    return TripPackageModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      durationDays: json['duration_days'] ?? 3,
      durationNights: json['duration_nights'] ?? 2,
      pricePerPerson: (json['price_per_person'] ?? 0).toDouble(),
      minGroupSize: json['min_group_size'] ?? 2,
      maxGroupSize: json['max_group_size'] ?? 15,
      destinations: List<String>.from(json['destinations'] ?? []),
      inclusions: List<String>.from(json['inclusions'] ?? []),
      exclusions: List<String>.from(json['exclusions'] ?? []),
      itinerary: (json['itinerary'] as List<dynamic>? ?? [])
          .map((d) => ItineraryDayModel.fromJson(d))
          .toList(),
      status: json['status'] ?? 'draft',
      rating: (json['rating'] ?? 4.8).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration_days': durationDays,
      'duration_nights': durationNights,
      'price_per_person': pricePerPerson,
      'min_group_size': minGroupSize,
      'max_group_size': maxGroupSize,
      'destinations': destinations,
      'inclusions': inclusions,
      'exclusions': exclusions,
      'itinerary': itinerary.map((i) => i.toJson()).toList(),
      'status': status,
      'rating': rating,
      'reviews_count': reviewsCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
