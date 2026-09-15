import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../models/amenity_model.dart';
import '../models/availability_model.dart';
import '../models/pricing_model.dart';
import '../models/property_image_model.dart';
import '../models/property_model.dart';
import '../models/room_model.dart';

class StayRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<ApiResponse<List<PropertyModel>>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 300));
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
        reviewsCount: 42,
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
              AmenityModel(id: 'a3', name: 'Tea Garden View', icon: 'landscape', category: 'View'),
            ],
            images: [],
          ),
          RoomModel(
            id: 'rm-102',
            propertyId: 'prop-001',
            name: 'Executive Suite with Balcony',
            roomType: 'Suite',
            maxOccupancy: 4,
            totalRooms: 4,
            basePricePerNight: 6800,
            amenities: [
              AmenityModel(id: 'a1', name: 'King Bed', icon: 'bed', category: 'Bedroom'),
              AmenityModel(id: 'a4', name: 'Private Balcony', icon: 'balcony', category: 'Outdoor'),
            ],
            images: [],
          ),
        ],
        amenities: [
          AmenityModel(id: 'a1', name: 'Free WiFi', icon: 'wifi', category: 'Internet'),
          AmenityModel(id: 'a2', name: 'Free Parking', icon: 'local_parking', category: 'Parking'),
          AmenityModel(id: 'a3', name: 'In-house Traditional Dining', icon: 'restaurant', category: 'Dining'),
          AmenityModel(id: 'a4', name: 'Bonfire & Folk Dance', icon: 'fireplace', category: 'Experience'),
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
        reviewsCount: 19,
        basePricePerNight: 3200,
        rooms: [],
        amenities: [],
        images: [],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
    return ApiResponse.success(data: mock);
  }

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

  Future<ApiResponse<List<StayAvailabilityModel>>> getAvailability(String propertyId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final list = List.generate(
      7,
      (i) => StayAvailabilityModel(
        id: 'av-$i',
        propertyId: propertyId,
        date: now.add(Duration(days: i)),
        totalUnits: 10,
        bookedUnits: (i % 3 == 0) ? 6 : 2,
        isBlocked: i == 5,
      ),
    );
    return ApiResponse.success(data: list);
  }

  Future<ApiResponse<bool>> createProperty(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ApiResponse.success(data: true, message: 'Property submitted for approval');
  }
}
