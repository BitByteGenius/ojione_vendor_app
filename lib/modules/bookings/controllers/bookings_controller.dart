import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/enums/service_type.dart';
import '../data/bookings_repository.dart';
import '../models/booking_filter_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';

class BookingsController extends GetxController {
  final BookingsRepository _repository = BookingsRepository();

  final isLoading = true.obs;
  final bookings = <BookingModel>[].obs;
  final selectedBooking = Rxn<BookingModel>();
  final filter = BookingFilterModel().obs;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      isLoading.value = true;
      final res = await _repository.getBookings(filter: filter.value);
      if (res.success && res.data != null) {
        final assigned = AuthService.to.assignedServices;
        final isolated = res.data!.where((b) => assigned.contains(b.serviceType)).toList();
        bookings.assignAll(isolated);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bookings');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByService(ServiceType? service) {
    filter.update((f) {
      f?.serviceType = service;
    });
    loadBookings();
  }

  void filterByStatus(BookingStatus? status) {
    filter.update((f) {
      f?.status = status;
    });
    loadBookings();
  }

  void selectBooking(BookingModel b) {
    selectedBooking.value = b;
    Get.toNamed('/bookings/details');
  }

  Future<void> updateStatus(String bookingId, BookingStatus newStatus) async {
    try {
      isLoading.value = true;
      final res = await _repository.updateBookingStatus(bookingId, newStatus);
      if (res.success) {
        Get.snackbar('Success', res.message);
        loadBookings();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update booking status');
    } finally {
      isLoading.value = false;
    }
  }
}
