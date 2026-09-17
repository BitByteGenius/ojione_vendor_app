import 'package:get/get.dart';
import '../../modules/auth/auth.dart';
import '../../modules/bookings/bookings.dart';
import '../../modules/earnings/earnings.dart';
import '../../modules/local_experiences/local_experiences.dart';
import '../../modules/notifications/notifications.dart';
import '../../modules/rental/rental.dart';
import '../../modules/settings/settings.dart';
import '../../modules/stay/stay.dart';
import '../../modules/shop/shop.dart';
import '../../modules/trips/trips.dart';
import '../../modules/vendor_home/vendor_home.dart';
import '../../modules/vendor_profile/vendor_profile.dart';
import '../../shared/enums/service_type.dart';
import 'app_routes.dart';
import 'service_guard_middleware.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = <GetPage>[
    // Splash & Onboarding
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),

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
      name: AppRoutes.registrationStatus,
      page: () => const RegistrationStatusScreen(),
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

    // Mobile Core Shell & Vendor Home
    GetPage(
      name: AppRoutes.root,
      page: () => const VendorShellScreen(),
      binding: VendorHomeBinding(),
    ),
    GetPage(
      name: AppRoutes.vendorShell,
      page: () => const VendorShellScreen(),
      binding: VendorHomeBinding(),
    ),
    GetPage(
      name: AppRoutes.vendorHome,
      page: () => const VendorHomeScreen(),
      binding: VendorHomeBinding(),
    ),
    GetPage(
      name: AppRoutes.servicesHub,
      page: () => const ServicesHubScreen(),
      binding: VendorHomeBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const VendorShellScreen(),
      binding: VendorHomeBinding(),
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

    // 1. Stay Service (Guarded by ServiceGuardMiddleware)
    GetPage(
      name: AppRoutes.stay,
      page: () => const StayDashboardScreen(),
      binding: StayBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.stay)],
    ),
    GetPage(
      name: AppRoutes.stayProperties,
      page: () => const PropertiesScreen(),
      binding: StayBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.stay)],
    ),
    GetPage(
      name: AppRoutes.stayAddProperty,
      page: () => const AddPropertyScreen(),
      binding: StayBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.stay)],
    ),
    GetPage(
      name: AppRoutes.stayPropertyDetails,
      page: () => const PropertyDetailsScreen(),
      binding: StayBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.stay)],
    ),
    GetPage(
      name: AppRoutes.stayRooms,
      page: () => const RoomsScreen(),
      binding: StayBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.stay)],
    ),
    GetPage(
      name: AppRoutes.stayAvailability,
      page: () => const StayAvailabilityScreen(),
      binding: StayBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.stay)],
    ),
    GetPage(
      name: AppRoutes.stayPricing,
      page: () => const StayPricingScreen(),
      binding: StayBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.stay)],
    ),

    // 2. Tours & Trips Service (Guarded by ServiceGuardMiddleware)
    GetPage(
      name: AppRoutes.trips,
      page: () => const TripsDashboardScreen(),
      binding: TripsBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.trips)],
    ),
    GetPage(
      name: AppRoutes.tripPackages,
      page: () => const PackagesScreen(),
      binding: TripsBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.trips)],
    ),
    GetPage(
      name: AppRoutes.tripAddPackage,
      page: () => const AddPackageScreen(),
      binding: TripsBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.trips)],
    ),
    GetPage(
      name: AppRoutes.tripDestinations,
      page: () => const DestinationsScreen(),
      binding: TripsBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.trips)],
    ),
    GetPage(
      name: AppRoutes.tripItinerary,
      page: () => const ItineraryScreen(),
      binding: TripsBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.trips)],
    ),

    // 3. Shop Service (Guarded by ServiceGuardMiddleware)
    GetPage(
      name: AppRoutes.shop,
      page: () => const ShopDashboardScreen(),
      binding: ShopBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.shop)],
    ),
    GetPage(
      name: AppRoutes.shopProducts,
      page: () => const ProductsScreen(),
      binding: ShopBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.shop)],
    ),
    GetPage(
      name: AppRoutes.shopAddProduct,
      page: () => const AddProductScreen(),
      binding: ShopBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.shop)],
    ),
    GetPage(
      name: AppRoutes.shopOrders,
      page: () => const ShopOrdersScreen(),
      binding: ShopBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.shop)],
    ),
    GetPage(
      name: AppRoutes.shopInventory,
      page: () => const InventoryScreen(),
      binding: ShopBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.shop)],
    ),

    // 4. Vehicle Rental Service (Guarded by ServiceGuardMiddleware)
    GetPage(
      name: AppRoutes.rental,
      page: () => const RentalDashboardScreen(),
      binding: RentalBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.rental)],
    ),
    GetPage(
      name: AppRoutes.rentalVehicles,
      page: () => const VehiclesScreen(),
      binding: RentalBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.rental)],
    ),
    GetPage(
      name: AppRoutes.rentalAddVehicle,
      page: () => const AddVehicleScreen(),
      binding: RentalBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.rental)],
    ),
    GetPage(
      name: AppRoutes.rentalAvailability,
      page: () => const RentalAvailabilityScreen(),
      binding: RentalBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.rental)],
    ),
    GetPage(
      name: AppRoutes.rentalPricing,
      page: () => const RentalPricingScreen(),
      binding: RentalBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.rental)],
    ),

    // 5. Local Experiences Service (Guarded by ServiceGuardMiddleware)
    GetPage(
      name: AppRoutes.experiences,
      page: () => const ExperiencesDashboardScreen(),
      binding: LocalExperiencesBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.localExperiences)],
    ),
    GetPage(
      name: AppRoutes.experienceList,
      page: () => const ExperiencesScreen(),
      binding: LocalExperiencesBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.localExperiences)],
    ),
    GetPage(
      name: AppRoutes.experienceAdd,
      page: () => const AddExperienceScreen(),
      binding: LocalExperiencesBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.localExperiences)],
    ),
    GetPage(
      name: AppRoutes.experienceSchedule,
      page: () => const ScheduleScreen(),
      binding: LocalExperiencesBinding(),
      middlewares: [ServiceGuardMiddleware(ServiceType.localExperiences)],
    ),
  ];
}
