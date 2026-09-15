import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../models/experience_category_model.dart';
import '../models/experience_model.dart';
import '../models/experience_schedule_model.dart';

class LocalExperiencesRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<ApiResponse<List<ExperienceModel>>> getExperiences() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mock = [
      ExperienceModel(
        id: 'exp-01',
        title: 'Assam Traditional Tea Tasting & Garden Walk',
        description: 'Guided tour of an organic tea estate, tea leaf plucking session, and tasting 6 rare orthodox and CTC specialty flushes.',
        category: 'Food & Tea Tasting',
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
          ExperienceScheduleModel(
            id: 'sch-2',
            experienceId: 'exp-01',
            startTime: '03:00 PM',
            endTime: '05:30 PM',
            daysOfWeek: ['Saturday', 'Sunday'],
            maxCapacity: 12,
            bookedCount: 6,
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
        schedules: [
          ExperienceScheduleModel(
            id: 'sch-3',
            experienceId: 'exp-02',
            startTime: '10:00 AM',
            endTime: '01:00 PM',
            daysOfWeek: ['Friday', 'Saturday'],
            maxCapacity: 8,
            bookedCount: 3,
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      ExperienceModel(
        id: 'exp-03',
        title: 'Old Guwahati Heritage & Sunset River Walk',
        description: 'Walking tour of Uzanbazar colonial bungalows, Latasil cultural square, and sunset prayers by the Brahmaputra ghats.',
        category: 'Cultural Walk',
        city: 'Guwahati',
        meetingPoint: 'Dighalipukhuri North Bank Promenade',
        durationHours: 2.0,
        maxCapacity: 15,
        pricePerPerson: 500,
        whatsIncluded: ['Local historian storyteller', 'Street tea and local rosgulla'],
        whatsNotIncluded: ['Bottled water'],
        requirements: 'Casual walking footwear',
        cancellationPolicy: 'Free cancellation up to 12h prior',
        status: 'published',
        rating: 4.9,
        reviewsCount: 44,
        schedules: [],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
    return ApiResponse.success(data: mock);
  }

  Future<ApiResponse<bool>> createExperience(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Local Experience created and submitted for verification');
  }
}
