class StayAvailabilityModel {
  final String id;
  final String propertyId;
  final String? roomId;
  final DateTime date;
  final int totalUnits;
  final int bookedUnits;
  final bool isBlocked;
  final double? customPrice;

  StayAvailabilityModel({
    required this.id,
    required this.propertyId,
    this.roomId,
    required this.date,
    required this.totalUnits,
    required this.bookedUnits,
    this.isBlocked = false,
    this.customPrice,
  });

  int get availableUnits => isBlocked ? 0 : (totalUnits - bookedUnits).clamp(0, totalUnits);

  factory StayAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return StayAvailabilityModel(
      id: json['id'] ?? '',
      propertyId: json['property_id'] ?? '',
      roomId: json['room_id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      totalUnits: json['total_units'] ?? 1,
      bookedUnits: json['booked_units'] ?? 0,
      isBlocked: json['is_blocked'] ?? false,
      customPrice: json['custom_price'] != null ? (json['custom_price']).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'room_id': roomId,
      'date': date.toIso8601String(),
      'total_units': totalUnits,
      'booked_units': bookedUnits,
      'is_blocked': isBlocked,
      'custom_price': customPrice,
    };
  }
}
