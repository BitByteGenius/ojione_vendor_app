import 'amenity_model.dart';
import 'property_image_model.dart';
import 'room_model.dart';

class PropertyModel {
  final String id;
  final String name;
  final String description;
  final String propertyType; // 'Hotel', 'Homestay', 'Resort', 'Villa'
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String checkInTime;
  final String checkOutTime;
  final String status; // 'published', 'pending_approval', 'draft'
  final double rating;
  final int reviewsCount;
  final double basePricePerNight;
  final List<RoomModel> rooms;
  final List<AmenityModel> amenities;
  final List<PropertyImageModel> images;
  final DateTime createdAt;

  PropertyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.propertyType,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.checkInTime = '12:00 PM',
    this.checkOutTime = '11:00 AM',
    required this.status,
    this.rating = 4.8,
    this.reviewsCount = 24,
    required this.basePricePerNight,
    required this.rooms,
    required this.amenities,
    required this.images,
    required this.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      propertyType: json['property_type'] ?? 'Homestay',
      address: json['address'] ?? '',
      city: json['city'] ?? 'Guwahati',
      state: json['state'] ?? 'Assam',
      pincode: json['pincode'] ?? '781001',
      checkInTime: json['check_in_time'] ?? '12:00 PM',
      checkOutTime: json['check_out_time'] ?? '11:00 AM',
      status: json['status'] ?? 'draft',
      rating: (json['rating'] ?? 4.8).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      basePricePerNight: (json['base_price_per_night'] ?? 0).toDouble(),
      rooms: (json['rooms'] as List<dynamic>? ?? [])
          .map((r) => RoomModel.fromJson(r))
          .toList(),
      amenities: (json['amenities'] as List<dynamic>? ?? [])
          .map((a) => AmenityModel.fromJson(a))
          .toList(),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((img) => PropertyImageModel.fromJson(img))
          .toList(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'property_type': propertyType,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'status': status,
      'rating': rating,
      'reviews_count': reviewsCount,
      'base_price_per_night': basePricePerNight,
      'rooms': rooms.map((r) => r.toJson()).toList(),
      'amenities': amenities.map((a) => a.toJson()).toList(),
      'images': images.map((img) => img.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
