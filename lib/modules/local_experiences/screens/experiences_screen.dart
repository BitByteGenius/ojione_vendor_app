import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/local_experiences_controller.dart';
import 'experiences_dashboard_screen.dart';

class ExperiencesScreen extends GetView<LocalExperiencesController> {
  const ExperiencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExperiencesDashboardScreen();
  }
}
