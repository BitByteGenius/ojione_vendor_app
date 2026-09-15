class AppConstants {
  AppConstants._();

  static const String appName = 'SewaSetu Vendor Panel';
  static const String appTagline = 'Multi-Service Vendor Management Platform';
  static const String appVersion = '1.0.0';

  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';

  // Pagination
  static const int defaultPageSize = 10;

  // Local Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserData = 'user_data';
  static const String keyThemeMode = 'theme_mode';
  static const String keyActiveServices = 'active_services';

  // Network Timeouts (milliseconds)
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
