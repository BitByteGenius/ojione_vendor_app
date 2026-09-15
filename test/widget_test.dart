import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sewasetu_vendor/app/app.dart';
import 'package:sewasetu_vendor/core/services/auth_service.dart';

void main() {
  testWidgets('SewaSetu Vendor Panel root smoke test', (WidgetTester tester) async {
    Get.put(AuthService(), permanent: true);
    await tester.pumpWidget(const SewaSetuVendorApp());
    expect(find.byType(SewaSetuVendorApp), findsOneWidget);
  });
}
