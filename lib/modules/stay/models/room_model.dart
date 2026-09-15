import 'amenity_model.dart';
import 'property_image_model.dart';

class RoomModel {
  final String id;
  final String propertyId;
  final String name;
  final String roomType; // 'Deluxe', 'Executive', 'Villa', 'Suite'
  final int maxOccupancy;
  final int totalRooms;
  final double basePricePerNight;
  final List<AmenityModel> amenities;
  final List<PropertyImageModel> images;
  final bool isAvailable;

  RoomModel({
    required this.id,
    required this.propertyId,
    required this.name,
    required this.roomType,
    required this.maxOccupancy,
    required this.totalRooms,
    required this.basePricePerNight,
    required this.amenities,
    required this.images,
    this.isAvailable = true,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] ?? '',
      propertyId: json['property_id'] ?? json['propertyId'] ?? '',
      name: json['name'] ?? '',
      roomType: json['room_type'] ?? 'Deluxe Room',
      maxOccupancy: json['max_occupancy'] ?? 2,
      totalRooms: json['total_rooms'] ?? 1,
      basePricePerNight: (json['base_price_per_night'] ?? json['basePricePerNight'] ?? 0).toDouble(),
      amenities: (json['amenities'] as List<dynamic>? ?? [])
          .map((e) => AmenityModel.fromJson(e))
          .toList(),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => PropertyImageModel.fromJson(e))
          .toList(),
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'name': name,
      'room_type': roomType,
      'max_occupancy': maxOccupancy,
      'total_rooms': totalRooms,
      'base_price_per_night': basePricePerNight,
      'amenities': amenities.map((a) => a.toJson()).toList(),
      'images': images.map((img) => img.toJson()).toList(),
      'is_available': isAvailable,
    };
  }
}
