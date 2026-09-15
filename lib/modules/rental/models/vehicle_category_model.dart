class VehicleCategoryModel {
  final String id;
  final String name; // 'SUV', 'Sedan', 'Hatchback', 'Motorcycle / Scooter'
  final int capacitySeats;

  VehicleCategoryModel({
    required this.id,
    required this.name,
    required this.capacitySeats,
  });

  factory VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    return VehicleCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'SUV',
      capacitySeats: json['capacity_seats'] ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity_seats': capacitySeats,
    };
  }
}
