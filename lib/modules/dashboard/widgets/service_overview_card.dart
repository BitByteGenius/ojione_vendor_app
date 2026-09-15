import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/enums/service_type.dart';

class ServiceOverviewCard extends StatelessWidget {
  final ServiceType service;
  final int activeCount;
  final int pendingOrders;
  final double revenue;

  const ServiceOverviewCard({
    super.key,
    required this.service,
    required this.activeCount,
    required this.pendingOrders,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceSm),
                decoration: BoxDecoration(
                  color: service.bgColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(service.icon, color: service.color, size: 20),
              ),
              const SizedBox(width: AppDimensions.spaceSm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.displayName, style: AppTextStyles.h4),
                    Text(
                      service.description,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                color: service.color,
                onPressed: () => Get.toNamed(service.routePath),
                tooltip: 'Open ${service.displayName}',
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          const Divider(),
          const SizedBox(height: AppDimensions.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Active Items', '$activeCount'),
              _buildStat('Active Bookings', '$pendingOrders'),
              _buildStat('Revenue', '₹${revenue.toStringAsFixed(0)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
