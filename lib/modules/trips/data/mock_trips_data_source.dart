import 'package:flutter/material.dart';
import '../../../core/network/api_response.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/enums/booking_status.dart';
import '../../../shared/widgets/charts/chart_data_models.dart';
import '../models/itinerary_model.dart';
import '../models/trip_package_model.dart';
import '../models/trips_analytics_model.dart';
import 'trips_data_source.dart';

class MockTripsDataSource implements TripsDataSource {
  @override
  Future<ApiResponse<TripsDashboardAnalytics>> getTripsAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final analytics = TripsDashboardAnalytics(
      totalPackages: 6,
      activePackages: 5,
      pendingApproval: 1,
      totalBookings: 94,
      upcomingTrips: 18,
      totalCustomers: 268,
      totalRevenue: 286000,
      pendingPayouts: 34500,
      revenueTrends: const [
        ChartDataPoint(x: 0, y: 140000, label: 'Apr'),
        ChartDataPoint(x: 1, y: 175000, label: 'May'),
        ChartDataPoint(x: 2, y: 210000, label: 'Jun'),
        ChartDataPoint(x: 3, y: 195000, label: 'Jul'),
        ChartDataPoint(x: 4, y: 250000, label: 'Aug'),
        ChartDataPoint(x: 5, y: 286000, label: 'Sep'),
      ],
      bookingTrends: const [
        BarGroupDataModel(x: 0, label: 'Mon', value: 8),
        BarGroupDataModel(x: 1, label: 'Tue', value: 11),
        BarGroupDataModel(x: 2, label: 'Wed', value: 14),
        BarGroupDataModel(x: 3, label: 'Thu', value: 16),
        BarGroupDataModel(x: 4, label: 'Fri', value: 24),
        BarGroupDataModel(x: 5, label: 'Sat', value: 29),
        BarGroupDataModel(x: 6, label: 'Sun', value: 19),
      ],
      bookingStatusBreakdown: const [
        PieSliceDataModel(label: 'Confirmed', value: 52, color: AppColors.tripsService, displayValue: '52 (55%)'),
        PieSliceDataModel(label: 'Completed', value: 31, color: Color(0xFF10B981), displayValue: '31 (33%)'),
        PieSliceDataModel(label: 'Upcoming', value: 8, color: Color(0xFFF59E0B), displayValue: '8 (9%)'),
        PieSliceDataModel(label: 'Cancelled', value: 3, color: Color(0xFFEF4444), displayValue: '3 (3%)'),
      ],
      packagePerformances: const [
        PackagePerformanceModel(
          id: 'tp-01',
          title: 'Kaziranga Safari & Majuli Island Heritage',
          duration: '4 Days / 3 Nights',
          totalBookings: 42,
          revenue: 154000,
          rating: 4.9,
          reviewsCount: 32,
          status: 'Active',
        ),
        PackagePerformanceModel(
          id: 'tp-02',
          title: 'Meghalaya Living Root Bridges & Waterfalls',
          duration: '3 Days / 2 Nights',
          totalBookings: 28,
          revenue: 82000,
          rating: 4.8,
          reviewsCount: 18,
          status: 'Active',
        ),
        PackagePerformanceModel(
          id: 'tp-03',
          title: 'Arunachal Tawang Monastery & Sela Pass Circuit',
          duration: '6 Days / 5 Nights',
          totalBookings: 18,
          revenue: 50000,
          rating: 4.9,
          reviewsCount: 12,
          status: 'Active',
        ),
        PackagePerformanceModel(
          id: 'tp-04',
          title: 'Manas Wildlife River Rafting & Border Safari',
          duration: '2 Days / 1 Night',
          totalBookings: 0,
          revenue: 0,
          rating: 0.0,
          reviewsCount: 0,
          status: 'Pending Approval',
        ),
      ],
      recentBookings: const [
        TripBookingItemModel(
          id: 'TR-4021',
          customerName: 'Vivek Singhania',
          packageTitle: 'Kaziranga Safari & Majuli Island',
          departureDate: '21 Sep 2026',
          travelersCount: 4,
          amount: 58000,
          status: BookingStatus.confirmed,
        ),
        TripBookingItemModel(
          id: 'TR-4020',
          customerName: 'Anindita Roy',
          packageTitle: 'Meghalaya Root Bridges Expedition',
          departureDate: '24 Sep 2026',
          travelersCount: 2,
          amount: 22400,
          status: BookingStatus.confirmed,
        ),
        TripBookingItemModel(
          id: 'TR-4019',
          customerName: 'Sanjay Deshmukh',
          packageTitle: 'Tawang High Altitude Circuit',
          departureDate: '15 Sep 2026',
          travelersCount: 3,
          amount: 72000,
          status: BookingStatus.completed,
        ),
        TripBookingItemModel(
          id: 'TR-4018',
          customerName: 'Rituparna Sarmah',
          packageTitle: 'Kaziranga Safari & Majuli Island',
          departureDate: '28 Sep 2026',
          travelersCount: 2,
          amount: 29000,
          status: BookingStatus.pending,
        ),
      ],
    );

    return ApiResponse.success(data: analytics);
  }

  @override
  Future<ApiResponse<List<TripPackageModel>>> getPackages() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final mock = [
      TripPackageModel(
        id: 'tp-01',
        title: 'Kaziranga Safari & Majuli River Island Heritage',
        description: 'Complete 4-day wildlife safari including elephant and jeep safaris, plus ferry to Majuli mask-making sattras.',
        durationDays: 4,
        durationNights: 3,
        pricePerPerson: 14500,
        destinations: ['Kaziranga', 'Jorhat', 'Majuli Island'],
        inclusions: ['All Transfers (AC Cab)', '3-Star Resort Stay', 'Jeep & Elephant Safari Passes', 'Daily Breakfast & Dinner'],
        exclusions: ['Flight/Train Tickets', 'Camera Fees', 'Personal Expenses'],
        status: 'published',
        rating: 4.9,
        reviewsCount: 28,
        itinerary: [
          ItineraryDayModel(
            dayNumber: 1,
            title: 'Arrival in Guwahati & Drive to Kaziranga',
            description: 'Pick up from airport/railway station, scenic drive through Brahmaputra valley.',
            activities: ['Airport pickup', 'Orchid Park visit', 'Resort check-in'],
            mealsIncluded: 'Dinner',
          ),
          ItineraryDayModel(
            dayNumber: 2,
            title: 'Kaziranga Jungle Safari',
            description: 'Early morning elephant safari in Kohora range followed by afternoon open-top jeep safari.',
            activities: ['Elephant Safari', 'Jeep Safari', 'Tea Garden Walk'],
            mealsIncluded: 'Breakfast, Dinner',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      TripPackageModel(
        id: 'tp-02',
        title: 'Meghalaya Living Root Bridges & Waterfalls Expedition',
        description: '3-day hiking trip covering Cherrapunjee waterfalls, double-decker root bridge, and Dawki crystal river.',
        durationDays: 3,
        durationNights: 2,
        pricePerPerson: 11200,
        destinations: ['Shillong', 'Cherrapunjee', 'Dawki'],
        inclusions: ['Dedicated SUV & Fuel', 'Homestay Lodging', 'Guide for Root Bridge Hike'],
        exclusions: ['Meals unless mentioned', 'Boating entry charges'],
        status: 'published',
        rating: 4.8,
        reviewsCount: 14,
        itinerary: [],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
    return ApiResponse.success(data: mock);
  }

  @override
  Future<ApiResponse<bool>> createPackage(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Trip package submitted for approval');
  }
}
