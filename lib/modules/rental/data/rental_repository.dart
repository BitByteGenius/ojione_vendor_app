import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../models/vehicle_model.dart';

class RentalRepository {
  final ApiClient apiClient = ApiClient.instance;

  Future<ApiResponse<List<String>>> getAvailableCities() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse.success(data: ['Guwahati', 'Dibrugarh', 'Jorhat', 'Shillong', 'Silchar', 'Tezpur']);
  }

  Future<ApiResponse<List<VehicleModel>>> getVehicles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mock = [
      VehicleModel(
        id: 'veh-01',
        make: 'Toyota',
        modelName: 'Innova Crysta 2.4 VX',
        registrationNumber: 'AS-01-EQ-4422',
        category: 'SUV 7-Seater',
        operatingCity: 'Guwahati',
        transmission: 'Manual',
        fuelType: 'Diesel',
        rentalType: 'Both',
        seatingCapacity: 7,
        pricePerDay: 4200,
        securityDeposit: 5000,
        status: 'available',
        rating: 4.9,
        tripsCompleted: 48,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      VehicleModel(
        id: 'veh-02',
        make: 'Mahindra',
        modelName: 'Thar 4x4 Hard Top',
        registrationNumber: 'AS-06-N-1100',
        category: 'Adventure 4x4',
        operatingCity: 'Dibrugarh',
        transmission: 'Automatic',
        fuelType: 'Diesel',
        rentalType: 'Self-Drive',
        seatingCapacity: 4,
        pricePerDay: 4800,
        securityDeposit: 8000,
        status: 'rented',
        rating: 4.8,
        tripsCompleted: 22,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      VehicleModel(
        id: 'veh-03',
        make: 'Royal Enfield',
        modelName: 'Himalayan 450',
        registrationNumber: 'AS-01-EX-9080',
        category: 'Motorcycle Tourer',
        operatingCity: 'Guwahati',
        transmission: 'Manual',
        fuelType: 'Petrol',
        rentalType: 'Self-Drive',
        seatingCapacity: 2,
        pricePerDay: 1800,
        securityDeposit: 3000,
        status: 'available',
        rating: 4.9,
        tripsCompleted: 65,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
    ];
    return ApiResponse.success(data: mock);
  }

  Future<ApiResponse<bool>> createVehicle(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Vehicle added successfully');
  }
}
