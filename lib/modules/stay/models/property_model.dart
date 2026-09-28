import '../../../shared/enums/stay_type.dart';
import 'amenity_model.dart';
import 'property_image_model.dart';
import 'room_model.dart';

class PropertyModel {
  final String id;
  final String name;
  final String description;
  final String propertyType; // 'Hotel', 'Homestay', 'Resort', 'Villa', or StayType
  final StayType? stayType;
  final String? roomConfiguration;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final String? hostAvatarUrl;
  final String? hostName;
  final String? hostPhone;
  final String? hostEmail;
  final double? depositAmount;
  final String? furnishingStatus;
  final String? availableFrom;
  final int maxOccupancy;
  final List<String> houseRules;
  final List<String> requiredDocuments;
  final String checkInTime;
  final String checkOutTime;
  final String status; // 'published', 'pending_approval', 'draft'
  final double rating;
  final int reviewsCount;
  final double basePricePerNight;
  final double? pricePerMonth;
  final int availableRooms;
  final List<RoomModel> rooms;
  final List<AmenityModel> amenities;
  final List<PropertyImageModel> images;
  final DateTime createdAt;

  PropertyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.propertyType,
    this.stayType,
    this.roomConfiguration,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
    this.hostAvatarUrl,
    this.hostName,
    this.hostPhone,
    this.hostEmail,
    this.depositAmount,
    this.furnishingStatus,
    this.availableFrom,
    this.maxOccupancy = 2,
    this.houseRules = const [],
    this.requiredDocuments = const [],
    this.checkInTime = '12:00 PM',
    this.checkOutTime = '11:00 AM',
    required this.status,
    this.rating = 4.8,
    this.reviewsCount = 24,
    required this.basePricePerNight,
    this.pricePerMonth,
    this.availableRooms = 1,
    required this.rooms,
    required this.amenities,
    required this.images,
    required this.createdAt,
  });

  double get displayPricePerMonth {
    if (pricePerMonth != null && pricePerMonth! > 0) {
      return pricePerMonth!;
    }
    if (basePricePerNight > 0) {
      return (basePricePerNight * 30 * 0.85).roundToDouble();
    }
    return 0.0;
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['property_type'] ?? json['stay_type'] ?? 'Homestay';
    return PropertyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      propertyType: typeStr,
      stayType: json['stay_type'] != null
          ? StayType.fromString(json['stay_type'])
          : StayType.fromString(typeStr),
      roomConfiguration: json['room_configuration'] ?? json['roomConfiguration'],
      address: json['address'] ?? '',
      city: json['city'] ?? 'Guwahati',
      state: json['state'] ?? 'Assam',
      pincode: json['pincode'] ?? '781001',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      hostAvatarUrl: json['host_avatar_url'] ?? json['host']?['avatarUrl'],
      hostName: json['host_name'] ?? json['host']?['name'],
      hostPhone: json['host_phone'] ?? json['host']?['phone'],
      hostEmail: json['host_email'] ?? json['host']?['email'],
      depositAmount: (json['deposit_amount'] as num?)?.toDouble(),
      furnishingStatus: json['furnishing_status'] as String?,
      availableFrom: json['available_from'] as String?,
      maxOccupancy: json['max_occupancy'] ?? 2,
      houseRules: (json['house_rules'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      requiredDocuments: (json['required_documents'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      checkInTime: json['check_in_time'] ?? '12:00 PM',
      checkOutTime: json['check_out_time'] ?? '11:00 AM',
      status: json['status'] ?? 'draft',
      rating: (json['rating'] ?? 4.8).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      basePricePerNight: ((json['base_price_per_night'] ?? json['price_per_night'] ?? json['pricePerNight']) ?? 0).toDouble(),
      pricePerMonth: (json['price_per_month'] ?? json['pricePerMonth'] as num?)?.toDouble(),
      availableRooms: json['available_rooms'] ?? json['availableRooms'] ?? 1,
      rooms: (json['rooms'] as List<dynamic>? ?? [])
          .map((r) => RoomModel.fromJson(r))
          .toList(),
      amenities: (json['amenities'] as List<dynamic>? ?? [])
          .map((a) {
            if (a is Map<String, dynamic>) {
              return AmenityModel.fromJson(a);
            }
            return AmenityModel(id: a.toString(), name: a.toString(), icon: 'check_circle', category: 'General');
          })
          .toList(),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((img) {
            if (img is Map<String, dynamic>) {
              return PropertyImageModel.fromJson(img);
            }
            return PropertyImageModel(id: 'img-${DateTime.now().millisecondsSinceEpoch}', url: img.toString());
          })
          .toList(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': name,
      'description': description,
      'property_type': propertyType,
      'stay_type': stayType?.name ?? propertyType.toLowerCase(),
      'room_configuration': roomConfiguration,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'host_avatar_url': hostAvatarUrl,
      'host_name': hostName,
      'host_phone': hostPhone,
      'host_email': hostEmail,
      'deposit_amount': depositAmount,
      'furnishing_status': furnishingStatus,
      'available_from': availableFrom,
      'max_occupancy': maxOccupancy,
      'house_rules': houseRules,
      'required_documents': requiredDocuments,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'status': status,
      'rating': rating,
      'reviews_count': reviewsCount,
      'base_price_per_night': basePricePerNight,
      'price_per_night': basePricePerNight,
      'price_per_month': pricePerMonth,
      'available_rooms': availableRooms,
      'rooms': rooms.map((r) => r.toJson()).toList(),
      'amenities': amenities.map((a) => a.toJson()).toList(),
      'images': images.map((img) => img.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
