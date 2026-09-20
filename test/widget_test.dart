import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sewasetu_vendor/app/app.dart';
import 'package:sewasetu_vendor/core/services/auth_service.dart';
import 'package:sewasetu_vendor/modules/rental/controllers/rental_controller.dart';
import 'package:sewasetu_vendor/modules/rental/screens/add_vehicle_screen.dart';
import 'package:sewasetu_vendor/modules/settings/controllers/settings_controller.dart';
import 'package:sewasetu_vendor/modules/settings/screens/settings_screen.dart';
import 'package:sewasetu_vendor/modules/vendor_home/widgets/demo_vendor_switcher_modal.dart';
import 'package:sewasetu_vendor/modules/stay/controllers/stay_controller.dart';
import 'package:sewasetu_vendor/modules/stay/screens/add_property_screen.dart';
import 'package:sewasetu_vendor/shared/enums/service_type.dart';
import 'package:sewasetu_vendor/shared/widgets/mobile_bottom_nav_bar.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('SewaSetu Vendor App loads and displays splash branding', (WidgetTester tester) async {
    Get.put(AuthService(), permanent: true);
    await tester.pumpWidget(const SewaSetuVendorApp());
    expect(find.byType(SewaSetuVendorApp), findsOneWidget);
    expect(find.text('SewaSetu'), findsOneWidget);
    expect(find.text('MULTI-SERVICE VENDOR APP'), findsOneWidget);

    // Fast-forward splash animation & timer, then allow mock data timers to settle
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
  });

  test('Multi-Service Vendor Isolation logic: Vendor A (Stay + Rental)', () {
    final auth = AuthService();
    auth.setDemoVendorAStayRental();

    expect(auth.assignedServices.length, 2);
    expect(auth.hasService(ServiceType.stay), isTrue);
    expect(auth.hasService(ServiceType.rental), isTrue);
    expect(auth.hasService(ServiceType.shop), isFalse);
    expect(auth.hasService(ServiceType.trips), isFalse);
    expect(auth.hasService(ServiceType.localExperiences), isFalse);
  });

  test('Multi-Service Vendor Isolation logic: Vendor B (Shop only)', () {
    final auth = AuthService();
    auth.setDemoVendorBShopOnly();

    expect(auth.assignedServices.length, 1);
    expect(auth.hasService(ServiceType.shop), isTrue);
    expect(auth.hasService(ServiceType.stay), isFalse);
    expect(auth.hasService(ServiceType.rental), isFalse);
    expect(auth.hasService(ServiceType.trips), isFalse);
    expect(auth.hasService(ServiceType.localExperiences), isFalse);
  });

  test('Multi-Service Vendor Isolation logic: Vendor C (Trips + Local Experiences)', () {
    final auth = AuthService();
    auth.setDemoVendorCTripsExperiences();

    expect(auth.assignedServices.length, 2);
    expect(auth.hasService(ServiceType.trips), isTrue);
    expect(auth.hasService(ServiceType.localExperiences), isTrue);
    expect(auth.hasService(ServiceType.stay), isFalse);
    expect(auth.hasService(ServiceType.shop), isFalse);
    expect(auth.hasService(ServiceType.rental), isFalse);
  });

  testWidgets('Mobile Bottom Navigation adapts dynamically: Single Service (Shop)', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: MobileBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
            assignedServices: const [ServiceType.shop],
          ),
        ),
      ),
    );

    // Should display [Home, Shop, Orders, Earnings, Profile]
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Earnings'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    // Should NOT display Services or Bookings
    expect(find.text('Services'), findsNothing);
    expect(find.text('Bookings'), findsNothing);
  });

  testWidgets('Mobile Bottom Navigation adapts dynamically: Multi Service (Stay + Rental)', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: MobileBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
            assignedServices: const [ServiceType.stay, ServiceType.rental],
          ),
        ),
      ),
    );

    // Should display [Home, Services, Bookings, Earnings, Profile]
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Bookings'), findsOneWidget);
    expect(find.text('Earnings'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('DemoVendorSwitcherModal renders without overflow on narrow mobile viewport (320px)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Get.put(AuthService(), permanent: true);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DemoVendorSwitcherModal(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Switch Vendor Profile'), findsOneWidget);
    expect(find.text('Select a vendor account persona to test dynamic service isolation:'), findsOneWidget);
    expect(find.text('Vendor A — Stay & Rental'), findsOneWidget);
    expect(find.text('Vendor B — Assam Craft Emporium'), findsOneWidget);
    expect(find.text('Vendor C — Brahmaputra Expeditions'), findsOneWidget);
    expect(find.text('Vendor D — Northeast Multi-Enterprise'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsScreen renders without overflow on narrow mobile viewport (320px)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Get.put(AuthService(), permanent: true);
    Get.put(SettingsController());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Vendor Settings'), findsOneWidget);
    expect(find.text('Email Notifications'), findsOneWidget);
    expect(find.text('Preferred Language'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AddVehicleScreen renders single-column without overflow on narrow mobile (320px)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Get.put(AuthService(), permanent: true);
    Get.put(RentalController());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: AddVehicleScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add Vehicle to Rental Fleet'), findsOneWidget);
    expect(find.text('Manufacturer / Make'), findsOneWidget);
    expect(find.text('Add to Fleet'), findsOneWidget);
  });

  testWidgets('AddPropertyScreen renders all 5 property creation sections without error', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Get.put(AuthService(), permanent: true);
    Get.put(StayController());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: AddPropertyScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 5 user requested sections are present
    expect(find.text('1. Media & Files (Uploads)'), findsOneWidget);
    expect(find.text('2. Basic Information'), findsOneWidget);
    expect(find.text('3. Location Details'), findsOneWidget);
    expect(find.text('4. Pricing & Availability'), findsOneWidget);
    expect(find.text('5. Amenities & Features'), findsOneWidget);

    // Verify key fields
    expect(find.text('Host Profile Picture'), findsOneWidget);
    expect(find.text('Property Photos (images)'), findsOneWidget);
    expect(find.text('Listing Title (title)'), findsOneWidget);
    expect(find.text('Stay Type (stayType)'), findsOneWidget);
    expect(find.text('Room Configuration (roomConfiguration)'), findsOneWidget);
    expect(find.text('Street Address (address)'), findsOneWidget);
    expect(find.text('City (city)'), findsOneWidget);
    expect(find.text('Price Per Night (pricePerNight) *'), findsOneWidget);
    expect(find.text('Price Per Month (pricePerMonth)'), findsOneWidget);
    expect(find.text('Available Units / Rooms (availableRooms)'), findsOneWidget);

    // Verify submission action button
    expect(find.text('Submit Property for Approval'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
