import 'package:get/get.dart';
import '../../modules/auth/auth.dart';
import '../../modules/bookings/bookings.dart';
import '../../modules/dashboard/dashboard.dart';
import '../../modules/earnings/earnings.dart';
import '../../modules/local_experiences/local_experiences.dart';
import '../../modules/notifications/notifications.dart';
import '../../modules/rental/rental.dart';
import '../../modules/settings/settings.dart';
import '../../modules/stay/stay.dart';
import '../../modules/shop/shop.dart';
import '../../modules/trips/trips.dart';
import '../../modules/vendor_profile/vendor_profile.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.dashboard;

  static final routes = <GetPage>[
    // Auth
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.registrationSuccess,
      page: () => const RegistrationSuccessScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),

    // Dashboard
    GetPage(
      name: AppRoutes.root,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),

    // Vendor Profile
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: VendorProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: VendorProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.businessDetails,
      page: () => const BusinessDetailsScreen(),
      binding: VendorProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.documents,
      page: () => const DocumentsScreen(),
      binding: VendorProfileBinding(),
    ),

    // Central Bookings
    GetPage(
      name: AppRoutes.bookings,
      page: () => const BookingsScreen(),
      binding: BookingsBinding(),
    ),
    GetPage(
      name: AppRoutes.bookingDetails,
      page: () => const BookingDetailsScreen(),
      binding: BookingsBinding(),
    ),
    GetPage(
      name: AppRoutes.bookingCalendar,
      page: () => const BookingCalendarScreen(),
      binding: BookingsBinding(),
    ),

    // Earnings
    GetPage(
      name: AppRoutes.earnings,
      page: () => const EarningsScreen(),
      binding: EarningsBinding(),
    ),
    GetPage(
      name: AppRoutes.transactions,
      page: () => const TransactionsScreen(),
      binding: EarningsBinding(),
    ),
    GetPage(
      name: AppRoutes.payouts,
      page: () => const PayoutsScreen(),
      binding: EarningsBinding(),
    ),

    // Notifications & Settings
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),

    // 1. Stay Service
    GetPage(
      name: AppRoutes.stay,
      page: () => const StayDashboardScreen(),
      binding: StayBinding(),
    ),
    GetPage(
      name: AppRoutes.stayProperties,
      page: () => const PropertiesScreen(),
      binding: StayBinding(),
    ),
    GetPage(
      name: AppRoutes.stayAddProperty,
      page: () => const AddPropertyScreen(),
      binding: StayBinding(),
    ),
    GetPage(
      name: AppRoutes.stayPropertyDetails,
      page: () => const PropertyDetailsScreen(),
      binding: StayBinding(),
    ),
    GetPage(
      name: AppRoutes.stayRooms,
      page: () => const RoomsScreen(),
      binding: StayBinding(),
    ),
    GetPage(
      name: AppRoutes.stayAvailability,
      page: () => const StayAvailabilityScreen(),
      binding: StayBinding(),
    ),
    GetPage(
      name: AppRoutes.stayPricing,
      page: () => const StayPricingScreen(),
      binding: StayBinding(),
    ),

    // 2. Tours & Trips Service
    GetPage(
      name: AppRoutes.trips,
      page: () => const TripsDashboardScreen(),
      binding: TripsBinding(),
    ),
    GetPage(
      name: AppRoutes.tripPackages,
      page: () => const PackagesScreen(),
      binding: TripsBinding(),
    ),
    GetPage(
      name: AppRoutes.tripAddPackage,
      page: () => const AddPackageScreen(),
      binding: TripsBinding(),
    ),
    GetPage(
      name: AppRoutes.tripDestinations,
      page: () => const DestinationsScreen(),
      binding: TripsBinding(),
    ),
    GetPage(
      name: AppRoutes.tripItinerary,
      page: () => const ItineraryScreen(),
      binding: TripsBinding(),
    ),

    // 3. Shop Service
    GetPage(
      name: AppRoutes.shop,
      page: () => const ShopDashboardScreen(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.shopProducts,
      page: () => const ProductsScreen(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.shopAddProduct,
      page: () => const AddProductScreen(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.shopOrders,
      page: () => const ShopOrdersScreen(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.shopInventory,
      page: () => const InventoryScreen(),
      binding: ShopBinding(),
    ),

    // 4. Vehicle Rental Service
    GetPage(
      name: AppRoutes.rental,
      page: () => const RentalDashboardScreen(),
      binding: RentalBinding(),
    ),
    GetPage(
      name: AppRoutes.rentalVehicles,
      page: () => const VehiclesScreen(),
      binding: RentalBinding(),
    ),
    GetPage(
      name: AppRoutes.rentalAddVehicle,
      page: () => const AddVehicleScreen(),
      binding: RentalBinding(),
    ),
    GetPage(
      name: AppRoutes.rentalAvailability,
      page: () => const RentalAvailabilityScreen(),
      binding: RentalBinding(),
    ),
    GetPage(
      name: AppRoutes.rentalPricing,
      page: () => const RentalPricingScreen(),
      binding: RentalBinding(),
    ),

    // 5. Local Experiences Service
    GetPage(
      name: AppRoutes.experiences,
      page: () => const ExperiencesDashboardScreen(),
      binding: LocalExperiencesBinding(),
    ),
    GetPage(
      name: AppRoutes.experienceList,
      page: () => const ExperiencesScreen(),
      binding: LocalExperiencesBinding(),
    ),
    GetPage(
      name: AppRoutes.experienceAdd,
      page: () => const AddExperienceScreen(),
      binding: LocalExperiencesBinding(),
    ),
    GetPage(
      name: AppRoutes.experienceSchedule,
      page: () => const ScheduleScreen(),
      binding: LocalExperiencesBinding(),
    ),
  ];
}
