import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sewasetu_vendor/app/app.dart';
import 'package:sewasetu_vendor/core/services/auth_service.dart';
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
}
