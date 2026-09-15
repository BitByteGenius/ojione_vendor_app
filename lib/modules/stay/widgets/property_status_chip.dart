import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_status_chip.dart';

class PropertyStatusChip extends StatelessWidget {
  final String status;

  const PropertyStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return AppStatusChip(status: status);
  }
}
