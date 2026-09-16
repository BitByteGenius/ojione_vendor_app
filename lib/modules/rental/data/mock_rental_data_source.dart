import 'package:flutter/material.dart';
import '../../../core/network/api_response.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/enums/booking_status.dart';
import '../../../shared/widgets/charts/chart_data_models.dart';
import '../models/rental_analytics_model.dart';
import '../models/vehicle_model.dart';
import 'rental_data_source.dart';

class MockRentalDataSource implements RentalDataSource {
  @override
  Future<ApiResponse<RentalDashboardAnalytics>> getRentalAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final analytics = RentalDashboardAnalytics(
      totalVehicles: 14,
      availableVehicles: 8,
      currentlyRented: 5,
      inMaintenance: 1,
      totalBookings: 142,
      upcomingBookings: 11,
      utilizationRate: 71.4,
      totalRevenue: 212500,
      pendingPayouts: 28000,
      revenueOverview: const [
        ChartDataPoint(x: 0, y: 115000, label: 'Apr'),
        ChartDataPoint(x: 1, y: 138000, label: 'May'),
        ChartDataPoint(x: 2, y: 165000, label: 'Jun'),
        ChartDataPoint(x: 3, y: 152000, label: 'Jul'),
        ChartDataPoint(x: 4, y: 189000, label: 'Aug'),
        ChartDataPoint(x: 5, y: 212500, label: 'Sep'),
      ],
      rentalTrends: const [
        BarGroupDataModel(x: 0, label: 'Mon', value: 9),
        BarGroupDataModel(x: 1, label: 'Tue', value: 12),
        BarGroupDataModel(x: 2, label: 'Wed', value: 10),
        BarGroupDataModel(x: 3, label: 'Thu', value: 15),
        BarGroupDataModel(x: 4, label: 'Fri', value: 24),
        BarGroupDataModel(x: 5, label: 'Sat', value: 31),
        BarGroupDataModel(x: 6, label: 'Sun', value: 22),
      ],
      fleetStatusBreakdown: const [
        PieSliceDataModel(label: 'Available', value: 8, color: Color(0xFF10B981), displayValue: '8 (57%)'),
        PieSliceDataModel(label: 'Currently Rented', value: 5, color: AppColors.rentalService, displayValue: '5 (36%)'),
        PieSliceDataModel(label: 'In Maintenance', value: 1, color: Color(0xFFF59E0B), displayValue: '1 (7%)'),
      ],
      recentBookings: const [
        RentalBookingItemModel(
          id: 'RN-6021',
          customerName: 'Amit Baruah',
          vehicleName: 'Toyota Innova Crysta 2.4 VX',
          registrationNumber: 'AS-01-EQ-4422',
          rentalDates: '18 Sep → 22 Sep 2026',
          days: 4,
          amount: 16800,
          status: BookingStatus.confirmed,
        ),
        RentalBookingItemModel(
          id: 'RN-6020',
          customerName: 'Kunal Singha',
          vehicleName: 'Mahindra Thar 4x4 Hard Top',
          registrationNumber: 'AS-06-N-1100',
          rentalDates: '16 Sep → 19 Sep 2026',
          days: 3,
          amount: 14400,
          status: BookingStatus.inProgress,
        ),
        RentalBookingItemModel(
          id: 'RN-6019',
          customerName: 'Debabrata Das',
          vehicleName: 'Royal Enfield Himalayan 450',
          registrationNumber: 'AS-01-EX-9080',
          rentalDates: '12 Sep → 15 Sep 2026',
          days: 3,
          amount: 5400,
          status: BookingStatus.completed,
        ),
        RentalBookingItemModel(
          id: 'RN-6018',
          customerName: 'Sunil Gogoi',
          vehicleName: 'Maruti Ertiga Hybrid',
          registrationNumber: 'AS-01-BK-2211',
          rentalDates: '22 Sep → 24 Sep 2026',
          days: 2,
          amount: 7000,
          status: BookingStatus.pending,
        ),
      ],
    );

    return ApiResponse.success(data: analytics);
  }

  @override
  Future<ApiResponse<List<VehicleModel>>> getVehicles() async {
    await Future.delayed(const Duration(milliseconds: 250));
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

  @override
  Future<ApiResponse<List<String>>> getAvailableCities() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return ApiResponse.success(data: ['Guwahati', 'Dibrugarh', 'Jorhat', 'Shillong', 'Silchar', 'Tezpur']);
  }

  @override
  Future<ApiResponse<bool>> createVehicle(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Vehicle added successfully');
  }
}
