class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.sewasetu.com/api/v1';

  // Auth endpoints
  static const String login = '/auth/vendor/login';
  static const String register = '/auth/vendor/register';
  static const String verifyOtp = '/auth/vendor/verify-otp';
  static const String resendOtp = '/auth/vendor/resend-otp';
  static const String refreshToken = '/auth/vendor/refresh-token';
  static const String forgotPassword = '/auth/vendor/forgot-password';
  static const String resetPassword = '/auth/vendor/reset-password';
  static const String logout = '/auth/vendor/logout';

  // Vendor Profile & Verification
  static const String vendorProfile = '/vendor/profile';
  static const String vendorBusiness = '/vendor/business';
  static const String vendorDocuments = '/vendor/documents';
  static const String vendorServices = '/vendor/services';

  // Dashboard & Analytics
  static const String dashboardMetrics = '/vendor/dashboard/metrics';
  static const String dashboardRecentBookings = '/vendor/dashboard/recent-bookings';

  // Stay Service Endpoints
  static const String stays = '/vendor/stays';
  static const String stayProperties = '/vendor/stays/properties';
  static const String stayRooms = '/vendor/stays/rooms';
  static const String stayAmenities = '/vendor/stays/amenities';
  static const String stayAvailability = '/vendor/stays/availability';
  static const String stayPricing = '/vendor/stays/pricing';

  // Trips & Tours Endpoints
  static const String trips = '/vendor/trips';
  static const String tripPackages = '/vendor/trips/packages';
  static const String tripDestinations = '/vendor/trips/destinations';
  static const String tripItineraries = '/vendor/trips/itineraries';
  static const String tripAvailability = '/vendor/trips/availability';

  // Shop Endpoints (State-wise indigenous products)
  static const String shop = '/vendor/shop';
  static const String shopProducts = '/vendor/shop/products';
  static const String shopCategories = '/vendor/shop/categories';
  static const String shopInventory = '/vendor/shop/inventory';
  static const String shopOrders = '/vendor/shop/orders';
  static const String shopReturns = '/vendor/shop/returns';

  // Rental Endpoints (City-based vehicle rentals)
  static const String rental = '/vendor/rental';
  static const String rentalVehicles = '/vendor/rental/vehicles';
  static const String rentalCategories = '/vendor/rental/categories';
  static const String rentalAvailability = '/vendor/rental/availability';
  static const String rentalPricing = '/vendor/rental/pricing';

  // Local Experiences Endpoints
  static const String experiences = '/vendor/experiences';
  static const String experienceCategories = '/vendor/experiences/categories';
  static const String experienceSchedules = '/vendor/experiences/schedules';
  static const String experiencePricing = '/vendor/experiences/pricing';
  static const String experienceBookings = '/vendor/experiences/bookings';

  // Central Bookings
  static const String bookings = '/vendor/bookings';
  static const String bookingDetails = '/vendor/bookings/';

  // Earnings, Transactions & Payouts
  static const String earnings = '/vendor/earnings';
  static const String transactions = '/vendor/earnings/transactions';
  static const String payouts = '/vendor/earnings/payouts';

  // Notifications
  static const String notifications = '/vendor/notifications';
  static const String markNotificationRead = '/vendor/notifications/read';
}
