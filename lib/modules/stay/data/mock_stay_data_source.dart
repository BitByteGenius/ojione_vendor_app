import 'package:flutter/material.dart';
import '../../../core/network/api_response.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/enums/booking_status.dart';
import '../../../shared/widgets/charts/chart_data_models.dart';
import '../models/amenity_model.dart';
import '../models/availability_model.dart';
import '../models/pricing_model.dart';
import '../models/property_image_model.dart';
import '../models/property_model.dart';
import '../models/room_model.dart';
import '../models/stay_analytics_model.dart';
import 'stay_data_source.dart';

class MockStayDataSource implements StayDataSource {
  @override
  Future<ApiResponse<StayDashboardAnalytics>> getStayAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final analytics = StayDashboardAnalytics(
      totalProperties: 4,
      activeProperties: 3,
      pendingApproval: 1,
      totalRooms: 24,
      totalBookings: 184,
      todayBookings: 6,
      upcomingBookings: 22,
      occupancyRate: 82.5,
      totalRevenue: 348500,
      pendingPayouts: 42000,
      revenueOverview: const [
        ChartDataPoint(x: 0, y: 195000, label: 'Apr'),
        ChartDataPoint(x: 1, y: 220000, label: 'May'),
        ChartDataPoint(x: 2, y: 280000, label: 'Jun'),
        ChartDataPoint(x: 3, y: 245000, label: 'Jul'),
        ChartDataPoint(x: 4, y: 310000, label: 'Aug'),
        ChartDataPoint(x: 5, y: 348500, label: 'Sep'),
      ],
      bookingTrends: const [
        BarGroupDataModel(x: 0, label: 'Mon', value: 12),
        BarGroupDataModel(x: 1, label: 'Tue', value: 16),
        BarGroupDataModel(x: 2, label: 'Wed', value: 14),
        BarGroupDataModel(x: 3, label: 'Thu', value: 21),
        BarGroupDataModel(x: 4, label: 'Fri', value: 28),
        BarGroupDataModel(x: 5, label: 'Sat', value: 34),
        BarGroupDataModel(x: 6, label: 'Sun', value: 26),
      ],
      bookingStatusBreakdown: const [
        PieSliceDataModel(label: 'Confirmed', value: 98, color: AppColors.primary, displayValue: '98 (53%)'),
        PieSliceDataModel(label: 'Completed', value: 62, color: Color(0xFF2563EB), displayValue: '62 (34%)'),
        PieSliceDataModel(label: 'Pending Check-in', value: 16, color: Color(0xFFD97706), displayValue: '16 (9%)'),
        PieSliceDataModel(label: 'Cancelled', value: 8, color: Color(0xFFDC2626), displayValue: '8 (4%)'),
      ],
      propertyPerformances: const [
        PropertyPerformanceModel(
          id: 'prop-001',
          name: 'Kaziranga Eco-Lodge & Heritage Retreat',
          propertyType: 'Eco Resort',
          totalRooms: 12,
          occupancyPercentage: 88.0,
          monthRevenue: 184500,
          rating: 4.9,
          reviewsCount: 52,
          approvalStatus: 'Approved & Live',
        ),
        PropertyPerformanceModel(
          id: 'prop-002',
          name: 'Brahmaputra Riverside Boutique Homestay',
          propertyType: 'Boutique Stay',
          totalRooms: 6,
          occupancyPercentage: 79.0,
          monthRevenue: 98000,
          rating: 4.7,
          reviewsCount: 28,
          approvalStatus: 'Approved & Live',
        ),
        PropertyPerformanceModel(
          id: 'prop-003',
          name: 'Majuli Island Bamboo Cottages',
          propertyType: 'Heritage Cottage',
          totalRooms: 6,
          occupancyPercentage: 74.0,
          monthRevenue: 66000,
          rating: 4.8,
          reviewsCount: 19,
          approvalStatus: 'Approved & Live',
        ),
        PropertyPerformanceModel(
          id: 'prop-004',
          name: 'Haflong Hilltop Tea Villa',
          propertyType: 'Hill Resort',
          totalRooms: 8,
          occupancyPercentage: 0.0,
          monthRevenue: 0,
          rating: 0.0,
          reviewsCount: 0,
          approvalStatus: 'Pending Admin Approval',
        ),
      ],
      recentBookings: const [
        StayBookingItemModel(
          id: 'ST-8841',
          guestName: 'Dr. Rajiv Baruah',
          propertyName: 'Kaziranga Eco-Lodge',
          roomType: 'Deluxe Heritage Cottage',
          checkIn: 'Today',
          checkOut: '19 Sep 2026',
          nights: 3,
          amount: 13500,
          status: BookingStatus.confirmed,
        ),
        StayBookingItemModel(
          id: 'ST-8840',
          guestName: 'Meenakshi Iyer',
          propertyName: 'Brahmaputra Riverside Stay',
          roomType: 'Riverview Suite',
          checkIn: 'Tomorrow',
          checkOut: '20 Sep 2026',
          nights: 3,
          amount: 16800,
          status: BookingStatus.confirmed,
        ),
        StayBookingItemModel(
          id: 'ST-8839',
          guestName: 'Karan Malhotra',
          propertyName: 'Majuli Island Cottages',
          roomType: 'Bamboo Stilt Hut',
          checkIn: '14 Sep 2026',
          checkOut: '16 Sep 2026',
          nights: 2,
          amount: 7200,
          status: BookingStatus.completed,
        ),
        StayBookingItemModel(
          id: 'ST-8838',
          guestName: 'Sneha Kalita',
          propertyName: 'Kaziranga Eco-Lodge',
          roomType: 'Executive Tea Suite',
          checkIn: '22 Sep 2026',
          checkOut: '25 Sep 2026',
          nights: 3,
          amount: 20400,
          status: BookingStatus.pending,
        ),
      ],
      recentReviews: const [
        StayReviewModel(
          guestName: 'Arjun Sen',
          propertyName: 'Kaziranga Eco-Lodge',
          rating: 5.0,
          comment: 'Outstanding Assamese food, serene cottages right beside the tea bushes. Will visit again!',
          date: 'Yesterday',
        ),
        StayReviewModel(
          guestName: 'Pooja Hegde',
          propertyName: 'Brahmaputra Riverside Stay',
          rating: 4.8,
          comment: 'Spectacular sunset view over the river and very welcoming staff.',
          date: '3 days ago',
        ),
      ],
    );

    return ApiResponse.success(data: analytics);
  }

  @override
  Future<ApiResponse<List<PropertyModel>>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final mock = [
      PropertyModel(
        id: 'prop-001',
        name: 'Kaziranga Eco-Lodge & Heritage Retreat',
        description: 'Serene forest lodge overlooking tea gardens with authentic Assamese cottages.',
        propertyType: 'Resort',
        address: 'Kohora Range, Kaziranga National Park',
        city: 'Kaziranga',
        state: 'Assam',
        pincode: '785609',
        status: 'published',
        rating: 4.9,
        reviewsCount: 52,
        basePricePerNight: 4500,
        rooms: [
          RoomModel(
            id: 'rm-101',
            propertyId: 'prop-001',
            name: 'Deluxe Heritage Cottage',
            roomType: 'Cottage',
            maxOccupancy: 3,
            totalRooms: 6,
            basePricePerNight: 4500,
            amenities: [
              AmenityModel(id: 'a1', name: 'King Bed', icon: 'bed', category: 'Bedroom'),
              AmenityModel(id: 'a2', name: 'Air Conditioning', icon: 'ac_unit', category: 'Climate'),
            ],
            images: [],
          ),
          RoomModel(
            id: 'rm-102',
            propertyId: 'prop-001',
            name: 'Executive Tea Suite',
            roomType: 'Suite',
            maxOccupancy: 4,
            totalRooms: 6,
            basePricePerNight: 6800,
            amenities: [
              AmenityModel(id: 'a1', name: 'King Bed', icon: 'bed', category: 'Bedroom'),
            ],
            images: [],
          ),
        ],
        amenities: [
          AmenityModel(id: 'a1', name: 'Free WiFi', icon: 'wifi', category: 'Internet'),
          AmenityModel(id: 'a2', name: 'Free Parking', icon: 'local_parking', category: 'Parking'),
        ],
        images: [
          PropertyImageModel(id: 'img1', url: 'https://images.unsplash.com/photo-1566073771259-6a8506099945', isFeatured: true),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      PropertyModel(
        id: 'prop-002',
        name: 'Brahmaputra Riverside Boutique Homestay',
        description: 'Peaceful riverside stay offering home-cooked ethnic meals and sunset boat rides.',
        propertyType: 'Homestay',
        address: 'Uzanbazar Ghat Road',
        city: 'Guwahati',
        state: 'Assam',
        pincode: '781001',
        status: 'published',
        rating: 4.7,
        reviewsCount: 28,
        basePricePerNight: 3200,
        rooms: [],
        amenities: [],
        images: [],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
    return ApiResponse.success(data: mock);
  }

  @override
  Future<ApiResponse<StayPricingModel>> getPricing(String propertyId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse.success(
      data: StayPricingModel(
        id: 'price-$propertyId',
        propertyId: propertyId,
        weekdayBasePrice: 4500,
        weekendBasePrice: 5500,
        extraAdultPrice: 1000,
        extraChildPrice: 500,
        cleaningFee: 350,
        taxPercentage: 12.0,
      ),
    );
  }

  @override
  Future<ApiResponse<List<StayAvailabilityModel>>> getAvailability(String propertyId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final list = List.generate(
      7,
      (i) => StayAvailabilityModel(
        id: 'av-$i',
        propertyId: propertyId,
        date: now.add(Duration(days: i)),
        totalUnits: 12,
        bookedUnits: (i % 3 == 0) ? 8 : 4,
        isBlocked: i == 5,
      ),
    );
    return ApiResponse.success(data: list);
  }

  @override
  Future<ApiResponse<bool>> createProperty(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Property submitted for approval');
  }
}
