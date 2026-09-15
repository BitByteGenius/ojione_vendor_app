class AppPermissions {
  AppPermissions._();

  // Stay permissions
  static const String propertyCreate = 'PROPERTY_CREATE';
  static const String propertyUpdate = 'PROPERTY_UPDATE';
  static const String propertyDelete = 'PROPERTY_DELETE';

  // Bookings permissions
  static const String bookingView = 'BOOKING_VIEW';
  static const String bookingUpdate = 'BOOKING_UPDATE';

  // Shop / Product permissions
  static const String productCreate = 'PRODUCT_CREATE';
  static const String productUpdate = 'PRODUCT_UPDATE';
  static const String productDelete = 'PRODUCT_DELETE';

  // Vehicle Rental permissions
  static const String vehicleCreate = 'VEHICLE_CREATE';
  static const String vehicleUpdate = 'VEHICLE_UPDATE';
  static const String vehicleDelete = 'VEHICLE_DELETE';

  // Local Experience permissions
  static const String experienceCreate = 'EXPERIENCE_CREATE';
  static const String experienceUpdate = 'EXPERIENCE_UPDATE';
  static const String experienceDelete = 'EXPERIENCE_DELETE';

  // Earnings & Financial permissions
  static const String earningsView = 'EARNINGS_VIEW';
  static const String payoutRequest = 'PAYOUT_REQUEST';

  // Vendor Profile permissions
  static const String profileEdit = 'PROFILE_EDIT';
  static const String documentUpload = 'DOCUMENT_UPLOAD';

  // Default vendor permissions (Owner has all)
  static const List<String> allPermissions = [
    propertyCreate,
    propertyUpdate,
    propertyDelete,
    bookingView,
    bookingUpdate,
    productCreate,
    productUpdate,
    productDelete,
    vehicleCreate,
    vehicleUpdate,
    vehicleDelete,
    experienceCreate,
    experienceUpdate,
    experienceDelete,
    earningsView,
    payoutRequest,
    profileEdit,
    documentUpload,
  ];

  static const List<String> managerPermissions = [
    propertyCreate,
    propertyUpdate,
    bookingView,
    bookingUpdate,
    productCreate,
    productUpdate,
    vehicleCreate,
    vehicleUpdate,
    experienceCreate,
    experienceUpdate,
    earningsView,
  ];

  static const List<String> staffPermissions = [
    bookingView,
    bookingUpdate,
  ];
}
