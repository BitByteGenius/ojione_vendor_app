import 'experience_schedule_model.dart';

class ExperienceModel {
  final String id;
  final String title;
  final String description;
  final String category; // 'Cooking Class', 'Village Experience', 'Craft Workshop', etc.
  final String city;
  final String meetingPoint;
  final double durationHours;
  final int maxCapacity;
  final double pricePerPerson;
  final List<String> whatsIncluded;
  final List<String> whatsNotIncluded;
  final String requirements;
  final String cancellationPolicy;
  final String status; // 'published', 'pending_approval', 'draft'
  final double rating;
  final int reviewsCount;
  final List<ExperienceScheduleModel> schedules;
  final DateTime createdAt;

  ExperienceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.city,
    required this.meetingPoint,
    required this.durationHours,
    required this.maxCapacity,
    required this.pricePerPerson,
    required this.whatsIncluded,
    required this.whatsNotIncluded,
    required this.requirements,
    required this.cancellationPolicy,
    required this.status,
    this.rating = 4.9,
    this.reviewsCount = 12,
    this.schedules = const [],
    required this.createdAt,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Cultural Experience',
      city: json['city'] ?? 'Guwahati',
      meetingPoint: json['meeting_point'] ?? json['meetingPoint'] ?? '',
      durationHours: (json['duration_hours'] ?? json['durationHours'] ?? 2.5).toDouble(),
      maxCapacity: json['max_capacity'] ?? json['maxCapacity'] ?? 10,
      pricePerPerson: (json['price_per_person'] ?? json['pricePerPerson'] ?? 0).toDouble(),
      whatsIncluded: List<String>.from(json['whats_included'] ?? []),
      whatsNotIncluded: List<String>.from(json['whats_not_included'] ?? []),
      requirements: json['requirements'] ?? 'Comfortable walking shoes',
      cancellationPolicy: json['cancellation_policy'] ?? 'Free cancellation up to 24 hours before start time',
      status: json['status'] ?? 'draft',
      rating: (json['rating'] ?? 4.9).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      schedules: (json['schedules'] as List<dynamic>? ?? [])
          .map((s) => ExperienceScheduleModel.fromJson(s))
          .toList(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'city': city,
      'meeting_point': meetingPoint,
      'duration_hours': durationHours,
      'max_capacity': maxCapacity,
      'price_per_person': pricePerPerson,
      'whats_included': whatsIncluded,
      'whats_not_included': whatsNotIncluded,
      'requirements': requirements,
      'cancellation_policy': cancellationPolicy,
      'status': status,
      'rating': rating,
      'reviews_count': reviewsCount,
      'schedules': schedules.map((s) => s.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
