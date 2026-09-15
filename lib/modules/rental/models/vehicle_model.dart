class VehicleModel {
  final String id;
  final String make;
  final String modelName;
  final String registrationNumber;
  final String category;
  final String operatingCity; // Dynamic backend-driven city
  final String transmission; // 'Manual', 'Automatic'
  final String fuelType; // 'Diesel', 'Petrol', 'Electric'
  final String rentalType; // 'Self-Drive', 'Chauffeur Driven', 'Both'
  final int seatingCapacity;
  final double pricePerDay;
  final double securityDeposit;
  final String status; // 'available', 'rented', 'maintenance', 'pending_approval'
  final double rating;
  final int tripsCompleted;
  final DateTime createdAt;

  VehicleModel({
    required this.id,
    required this.make,
    required this.modelName,
    required this.registrationNumber,
    required this.category,
    required this.operatingCity,
    required this.transmission,
    required this.fuelType,
    required this.rentalType,
    required this.seatingCapacity,
    required this.pricePerDay,
    this.securityDeposit = 5000,
    required this.status,
    this.rating = 4.8,
    this.tripsCompleted = 0,
    required this.createdAt,
  });

  String get displayName => '$make $modelName ($registrationNumber)';

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? '',
      make: json['make'] ?? '',
      modelName: json['model_name'] ?? json['modelName'] ?? '',
      registrationNumber: json['registration_number'] ?? json['registrationNumber'] ?? '',
      category: json['category'] ?? 'SUV',
      operatingCity: json['operating_city'] ?? json['operatingCity'] ?? 'Guwahati',
      transmission: json['transmission'] ?? 'Manual',
      fuelType: json['fuel_type'] ?? json['fuelType'] ?? 'Diesel',
      rentalType: json['rental_type'] ?? json['rentalType'] ?? 'Self-Drive',
      seatingCapacity: json['seating_capacity'] ?? json['seatingCapacity'] ?? 5,
      pricePerDay: (json['price_per_day'] ?? json['pricePerDay'] ?? 0).toDouble(),
      securityDeposit: (json['security_deposit'] ?? json['securityDeposit'] ?? 5000).toDouble(),
      status: json['status'] ?? 'available',
      rating: (json['rating'] ?? 4.8).toDouble(),
      tripsCompleted: json['trips_completed'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model_name': modelName,
      'registration_number': registrationNumber,
      'category': category,
      'operating_city': operatingCity,
      'transmission': transmission,
      'fuel_type': fuelType,
      'rental_type': rentalType,
      'seating_capacity': seatingCapacity,
      'price_per_day': pricePerDay,
      'security_deposit': securityDeposit,
      'status': status,
      'rating': rating,
      'trips_completed': tripsCompleted,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
