import '../../../shared/enums/booking_status.dart';
import '../../../shared/widgets/charts/chart_data_models.dart';

class RentalBookingItemModel {
  final String id;
  final String customerName;
  final String vehicleName;
  final String registrationNumber;
  final String rentalDates;
  final int days;
  final double amount;
  final BookingStatus status;

  const RentalBookingItemModel({
    required this.id,
    required this.customerName,
    required this.vehicleName,
    required this.registrationNumber,
    required this.rentalDates,
    required this.days,
    required this.amount,
    required this.status,
  });
}

class RentalDashboardAnalytics {
  final int totalVehicles;
  final int availableVehicles;
  final int currentlyRented;
  final int inMaintenance;
  final int totalBookings;
  final int upcomingBookings;
  final double utilizationRate; // e.g. 70.0%
  final double totalRevenue;
  final double pendingPayouts;
  final List<ChartDataPoint> revenueOverview;
  final List<BarGroupDataModel> rentalTrends;
  final List<PieSliceDataModel> fleetStatusBreakdown;
  final List<RentalBookingItemModel> recentBookings;

  const RentalDashboardAnalytics({
    required this.totalVehicles,
    required this.availableVehicles,
    required this.currentlyRented,
    required this.inMaintenance,
    required this.totalBookings,
    required this.upcomingBookings,
    required this.utilizationRate,
    required this.totalRevenue,
    required this.pendingPayouts,
    required this.revenueOverview,
    required this.rentalTrends,
    required this.fleetStatusBreakdown,
    required this.recentBookings,
  });
}
