import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trips_controller.dart';
import 'trips_dashboard_screen.dart';

class PackagesScreen extends GetView<TripsController> {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TripsDashboardScreen();
  }
}
