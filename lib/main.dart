import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Global Services
  Get.put(AuthService(), permanent: true);

  runApp(const SewaSetuVendorApp());
}
