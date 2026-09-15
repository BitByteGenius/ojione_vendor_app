import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../models/booking_filter_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';

class BookingsRepository {
  final ApiClient apiClient = ApiClient.instance;

  Future<ApiResponse<List<BookingModel>>> getBookings({BookingFilterModel? filter}) async {
    // API client call ready:
    // final response = await _apiClient.get(ApiEndpoints.bookings, queryParameters: {...});
    // return ApiResponse.fromJson(response.data, (json) => ...);

    await Future.delayed(const Duration(milliseconds: 300));
    final mockBookings = [
      BookingModel(
        id: '1',
        bookingReference: 'BK-2026-1049',
        serviceType: ServiceType.stay,
        itemName: 'Boutique Heritage Villa (Deluxe Suite)',
        customerName: 'Rohan Das',
        customerEmail: 'rohan.das@gmail.com',
        customerPhone: '+91 98765 11223',
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 4)),
        guestsOrUnits: 2,
        totalAmount: 8500,
        commissionAmount: 850,
        vendorEarnings: 7650,
        status: BookingStatus.confirmed,
        paymentStatus: 'Paid (Razorpay)',
        specialRequests: 'Ground floor room requested',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      BookingModel(
        id: '2',
        bookingReference: 'BK-2026-1048',
        serviceType: ServiceType.localExperiences,
        itemName: 'Assam Traditional Tea Tasting & Garden Walk',
        customerName: 'Priya Sen',
        customerEmail: 'priya.sen@outlook.com',
        customerPhone: '+91 98765 44332',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 1, hours: 3)),
        guestsOrUnits: 4,
        totalAmount: 2400,
        commissionAmount: 240,
        vendorEarnings: 2160,
        status: BookingStatus.confirmed,
        paymentStatus: 'Paid (UPI)',
        specialRequests: 'Include tea sampling kit',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      BookingModel(
        id: '3',
        bookingReference: 'BK-2026-1047',
        serviceType: ServiceType.rental,
        itemName: 'Toyota Innova Crysta (Self-Drive)',
        customerName: 'Amit Baruah',
        customerEmail: 'amit.baruah@gmail.com',
        customerPhone: '+91 98765 99887',
        startDate: DateTime.now().subtract(const Duration(days: 2)),
        endDate: DateTime.now().subtract(const Duration(days: 1)),
        guestsOrUnits: 1,
        totalAmount: 5600,
        commissionAmount: 560,
        vendorEarnings: 5040,
        status: BookingStatus.completed,
        paymentStatus: 'Paid',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      BookingModel(
        id: '4',
        bookingReference: 'BK-2026-1046',
        serviceType: ServiceType.trips,
        itemName: 'Kaziranga Wildlife Safari & Cultural Trail (3D/2N)',
        customerName: 'Neha Verma',
        customerEmail: 'neha.v@gmail.com',
        customerPhone: '+91 98765 77665',
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 10)),
        guestsOrUnits: 3,
        totalAmount: 18000,
        commissionAmount: 1800,
        vendorEarnings: 16200,
        status: BookingStatus.pending,
        paymentStatus: 'Advance Paid (50%)',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    var result = mockBookings;
    if (filter != null) {
      if (filter.serviceType != null) {
        result = result.where((b) => b.serviceType == filter.serviceType).toList();
      }
      if (filter.status != null) {
        result = result.where((b) => b.status == filter.status).toList();
      }
    }

    return ApiResponse.success(data: result);
  }

  Future<ApiResponse<bool>> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Booking status updated successfully');
  }
}
