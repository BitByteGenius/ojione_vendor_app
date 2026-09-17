import 'package:get/get.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../earnings/controllers/earnings_controller.dart';
import '../../local_experiences/controllers/local_experiences_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../rental/controllers/rental_controller.dart';
import '../../shop/controllers/shop_controller.dart';
import '../../stay/controllers/stay_controller.dart';
import '../../trips/controllers/trips_controller.dart';
import '../../vendor_profile/controllers/vendor_profile_controller.dart';
import '../data/vendor_home_repository.dart';
import '../controllers/vendor_home_controller.dart';

class VendorHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorHomeRepository>(() => VendorHomeRepository());
    Get.lazyPut<VendorHomeController>(() => VendorHomeController(repository: Get.find<VendorHomeRepository>()));
    Get.lazyPut<StayController>(() => StayController());
    Get.lazyPut<RentalController>(() => RentalController());
    Get.lazyPut<ShopController>(() => ShopController());
    Get.lazyPut<TripsController>(() => TripsController());
    Get.lazyPut<LocalExperiencesController>(() => LocalExperiencesController());
    Get.lazyPut<BookingsController>(() => BookingsController());
    Get.lazyPut<EarningsController>(() => EarningsController());
    Get.lazyPut<VendorProfileController>(() => VendorProfileController());
    Get.lazyPut<NotificationsController>(() => NotificationsController());
  }
}
