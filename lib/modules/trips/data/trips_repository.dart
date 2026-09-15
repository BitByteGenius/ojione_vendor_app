import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../models/itinerary_model.dart';
import '../models/trip_package_model.dart';

class TripsRepository {
  final ApiClient apiClient = ApiClient.instance;

  Future<ApiResponse<List<TripPackageModel>>> getPackages() async {
    await Future.delayed(const Duration(milliseconds: 300));
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
          ItineraryDayModel(
            dayNumber: 3,
            title: 'Ferry to Majuli Cultural Sattras',
            description: 'Cross the mighty Brahmaputra by government ferry to visit centuries-old neo-Vaishnavite monasteries.',
            activities: ['Ferry crossing', 'Mask making workshop at Samaguri Sattra', 'Mishing ethnic lunch'],
            mealsIncluded: 'Breakfast, Lunch, Dinner',
          ),
          ItineraryDayModel(
            dayNumber: 4,
            title: 'Departure via Jorhat',
            description: 'Breakfast and transfer to Jorhat airport for onward connection.',
            activities: ['Souvenir shopping', 'Airport drop'],
            mealsIncluded: 'Breakfast',
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

  Future<ApiResponse<bool>> createPackage(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Trip package submitted for approval');
  }
}
