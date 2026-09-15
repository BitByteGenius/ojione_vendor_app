import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rental_controller.dart';
import 'rental_dashboard_screen.dart';

class VehiclesScreen extends GetView<RentalController> {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RentalDashboardScreen();
  }
}
