class AppRoutes {
  AppRoutes._();

  // Root & Auth
  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';

  // Core Management
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String businessDetails = '/profile/business';
  static const String documents = '/profile/documents';

  // Central Bookings
  static const String bookings = '/bookings';
  static const String bookingDetails = '/bookings/details';
  static const String bookingCalendar = '/bookings/calendar';

  // Financials & Earnings
  static const String earnings = '/earnings';
  static const String transactions = '/earnings/transactions';
  static const String payouts = '/earnings/payouts';

  // Notifications & Settings
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  // 1. Stay Service
  static const String stay = '/stay';
  static const String stayProperties = '/stay/properties';
  static const String stayAddProperty = '/stay/properties/add';
  static const String stayPropertyDetails = '/stay/properties/details';
  static const String stayRooms = '/stay/rooms';
  static const String stayAvailability = '/stay/availability';
  static const String stayPricing = '/stay/pricing';

  // 2. Tours & Trips Service
  static const String trips = '/trips';
  static const String tripPackages = '/trips/packages';
  static const String tripAddPackage = '/trips/packages/add';
  static const String tripDestinations = '/trips/destinations';
  static const String tripItinerary = '/trips/itinerary';

  // 3. Shop Service (Indigenous & State-wise Goods)
  static const String shop = '/shop';
  static const String shopProducts = '/shop/products';
  static const String shopAddProduct = '/shop/products/add';
  static const String shopOrders = '/shop/orders';
  static const String shopInventory = '/shop/inventory';

  // 4. Vehicle Rental Service (City-based)
  static const String rental = '/rental';
  static const String rentalVehicles = '/rental/vehicles';
  static const String rentalAddVehicle = '/rental/vehicles/add';
  static const String rentalAvailability = '/rental/availability';
  static const String rentalPricing = '/rental/pricing';

  // 5. Local Experiences Service (New 5th Service)
  static const String experiences = '/experiences';
  static const String experienceList = '/experiences/list';
  static const String experienceAdd = '/experiences/add';
  static const String experienceSchedule = '/experiences/schedule';
}
