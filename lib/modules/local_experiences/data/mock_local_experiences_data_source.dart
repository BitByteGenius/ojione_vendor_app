import 'package:flutter/material.dart';
import '../../../core/network/api_response.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/enums/booking_status.dart';
import '../../../shared/widgets/charts/chart_data_models.dart';
import '../models/experience_category_model.dart';
import '../models/experience_model.dart';
import '../models/experience_schedule_model.dart';
import '../models/local_experiences_analytics_model.dart';
import 'local_experiences_data_source.dart';

class MockLocalExperiencesDataSource implements LocalExperiencesDataSource {
  @override
  Future<ApiResponse<LocalExperiencesDashboardAnalytics>> getExperiencesAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final analytics = LocalExperiencesDashboardAnalytics(
      totalExperiences: 8,
      activeExperiences: 7,
      pendingApproval: 1,
      totalBookings: 118,
      upcomingExperiences: 14,
      totalParticipants: 385,
      totalRevenue: 164200,
      pendingPayouts: 22500,
      revenueTrends: const [
        ChartDataPoint(x: 0, y: 78000, label: 'Apr'),
        ChartDataPoint(x: 1, y: 96000, label: 'May'),
        ChartDataPoint(x: 2, y: 125000, label: 'Jun'),
        ChartDataPoint(x: 3, y: 114000, label: 'Jul'),
        ChartDataPoint(x: 4, y: 142000, label: 'Aug'),
        ChartDataPoint(x: 5, y: 164200, label: 'Sep'),
      ],
      bookingTrends: const [
        BarGroupDataModel(x: 0, label: 'Mon', value: 7),
        BarGroupDataModel(x: 1, label: 'Tue', value: 11),
        BarGroupDataModel(x: 2, label: 'Wed', value: 16),
        BarGroupDataModel(x: 3, label: 'Thu', value: 18),
        BarGroupDataModel(x: 4, label: 'Fri', value: 29),
        BarGroupDataModel(x: 5, label: 'Sat', value: 38),
        BarGroupDataModel(x: 6, label: 'Sun', value: 34),
      ],
      bookingStatusBreakdown: const [
        PieSliceDataModel(label: 'Confirmed', value: 68, color: AppColors.localExpService, displayValue: '68 (58%)'),
        PieSliceDataModel(label: 'Completed', value: 38, color: Color(0xFF0284C7), displayValue: '38 (32%)'),
        PieSliceDataModel(label: 'Pending Slots', value: 8, color: Color(0xFFF59E0B), displayValue: '8 (7%)'),
        PieSliceDataModel(label: 'Cancelled', value: 4, color: Color(0xFFEF4444), displayValue: '4 (3%)'),
      ],
      experiencePerformances: const [
        ExperiencePerformanceModel(
          id: 'exp-01',
          title: 'Assam Traditional Tea Tasting & Garden Walk',
          category: 'Local Food Experience',
          participantsCount: 164,
          revenue: 84000,
          rating: 4.9,
          reviewsCount: 36,
          status: 'Active',
        ),
        ExperiencePerformanceModel(
          id: 'exp-02',
          title: 'Sarthebari Bell-Metal Craft & Blacksmithing Workshop',
          category: 'Craft Workshop',
          participantsCount: 78,
          revenue: 48000,
          rating: 4.8,
          reviewsCount: 19,
          status: 'Active',
        ),
        ExperiencePerformanceModel(
          id: 'exp-03',
          title: 'Old Guwahati Heritage & Sunset River Walk',
          category: 'Cultural Experience',
          participantsCount: 120,
          revenue: 28000,
          rating: 4.9,
          reviewsCount: 44,
          status: 'Active',
        ),
        ExperiencePerformanceModel(
          id: 'exp-04',
          title: 'Bodo Traditional Weaving & Cooking Masterclass',
          category: 'Cooking Class',
          participantsCount: 23,
          revenue: 4200,
          rating: 4.7,
          reviewsCount: 6,
          status: 'Active',
        ),
      ],
      recentBookings: const [
        ExperienceBookingItemModel(
          id: 'EXP-8801',
          participantName: 'Nisha Singhal',
          experienceTitle: 'Tea Tasting & Garden Walk',
          slotDate: '20 Sep 2026',
          slotTime: '09:30 AM',
          participantsCount: 3,
          amount: 2550,
          status: BookingStatus.confirmed,
        ),
        ExperienceBookingItemModel(
          id: 'EXP-8800',
          participantName: 'Alok Bhattacharya',
          experienceTitle: 'Sarthebari Bell-Metal Workshop',
          slotDate: '21 Sep 2026',
          slotTime: '10:00 AM',
          participantsCount: 2,
          amount: 2400,
          status: BookingStatus.confirmed,
        ),
        ExperienceBookingItemModel(
          id: 'EXP-8799',
          participantName: 'Geeta Menon',
          experienceTitle: 'Old Guwahati Heritage Walk',
          slotDate: '15 Sep 2026',
          slotTime: '04:30 PM',
          participantsCount: 4,
          amount: 2000,
          status: BookingStatus.completed,
        ),
        ExperienceBookingItemModel(
          id: 'EXP-8798',
          participantName: 'Rahul Pradhan',
          experienceTitle: 'Bodo Cooking Masterclass',
          slotDate: '25 Sep 2026',
          slotTime: '11:00 AM',
          participantsCount: 2,
          amount: 1800,
          status: BookingStatus.pending,
        ),
      ],
    );

    return ApiResponse.success(data: analytics);
  }

  @override
  Future<ApiResponse<List<ExperienceModel>>> getExperiences() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final mock = [
      ExperienceModel(
        id: 'exp-01',
        title: 'Assam Traditional Tea Tasting & Garden Walk',
        description: 'Guided tour of an organic tea estate, tea leaf plucking session, and tasting 6 rare orthodox and CTC specialty flushes.',
        category: 'Local Food Experience',
        city: 'Jorhat',
        meetingPoint: 'Toklai Experimental Tea Research Station Gate',
        durationHours: 2.5,
        maxCapacity: 12,
        pricePerPerson: 850,
        whatsIncluded: ['Tea expert guide', 'Sampling of 6 teas', 'Traditional Assamese pitha snacks', 'Take-home sample pack'],
        whatsNotIncluded: ['Transport to meeting point'],
        requirements: 'Comfortable outdoor footwear and sun hat',
        cancellationPolicy: 'Full refund up to 24h before',
        status: 'published',
        rating: 4.9,
        reviewsCount: 36,
        schedules: [
          ExperienceScheduleModel(
            id: 'sch-1',
            experienceId: 'exp-01',
            startTime: '09:30 AM',
            endTime: '12:00 PM',
            daysOfWeek: ['Wednesday', 'Saturday', 'Sunday'],
            maxCapacity: 12,
            bookedCount: 4,
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      ExperienceModel(
        id: 'exp-02',
        title: 'Sarthebari Bell-Metal Craft & Blacksmithing Workshop',
        description: 'Hands-on artisan session learning ancestral hammering and engraving techniques of heritage bell-metal bell craft.',
        category: 'Craft Workshop',
        city: 'Barpeta',
        meetingPoint: 'Sarthebari Heritage Guild Pavilion',
        durationHours: 3.0,
        maxCapacity: 8,
        pricePerPerson: 1200,
        whatsIncluded: ['Master artisan instruction', 'Safety gear & raw brass sheet', 'Keep your engraved bowl artifact'],
        whatsNotIncluded: ['Lunch'],
        requirements: 'Minimum age 14 years',
        cancellationPolicy: '48 hours cancellation window',
        status: 'published',
        rating: 4.8,
        reviewsCount: 19,
        schedules: [],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
    return ApiResponse.success(data: mock);
  }

  @override
  Future<ApiResponse<List<ExperienceCategoryModel>>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final categories = [
      ExperienceCategoryModel(id: 'cat-1', name: 'Local Food Experience', icon: 'restaurant_rounded'),
      ExperienceCategoryModel(id: 'cat-2', name: 'Cooking Class', icon: 'soup_kitchen_rounded'),
      ExperienceCategoryModel(id: 'cat-3', name: 'Cultural Experience', icon: 'museum_rounded'),
      ExperienceCategoryModel(id: 'cat-4', name: 'Village Experience', icon: 'cottage_rounded'),
      ExperienceCategoryModel(id: 'cat-5', name: 'Photography Walk', icon: 'camera_alt_rounded'),
      ExperienceCategoryModel(id: 'cat-6', name: 'Local Market Tour', icon: 'store_rounded'),
      ExperienceCategoryModel(id: 'cat-7', name: 'Adventure Activity', icon: 'kayaking_rounded'),
      ExperienceCategoryModel(id: 'cat-8', name: 'Craft Workshop', icon: 'handyman_rounded'),
      ExperienceCategoryModel(id: 'cat-9', name: 'Traditional Art Experience', icon: 'palette_rounded'),
      ExperienceCategoryModel(id: 'cat-10', name: 'Festival Experience', icon: 'celebration_rounded'),
      ExperienceCategoryModel(id: 'cat-11', name: 'Nature Experience', icon: 'forest_rounded'),
    ];
    return ApiResponse.success(data: categories);
  }

  @override
  Future<ApiResponse<bool>> createExperience(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Experience created and submitted for verification');
  }
}
