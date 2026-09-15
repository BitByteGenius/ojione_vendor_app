import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../models/availability_model.dart';

class StayAvailabilityCalendarWidget extends StatelessWidget {
  final List<StayAvailabilityModel> availabilityList;

  const StayAvailabilityCalendarWidget({
    super.key,
    required this.availabilityList,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: availabilityList.map((av) {
          final isBlocked = av.isBlocked;
          final available = av.availableUnits;

          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: AppDimensions.spaceSm),
            padding: const EdgeInsets.all(AppDimensions.spaceSm),
            decoration: BoxDecoration(
              color: isBlocked ? AppColors.errorLight.withAlpha(50) : (available == 0 ? Colors.grey.shade100 : AppColors.successLight.withAlpha(50)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(
                color: isBlocked ? AppColors.error.withAlpha(100) : (available == 0 ? Colors.grey.shade300 : AppColors.success.withAlpha(100)),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatters.date(av.date, format: 'EEE, dd MMM'),
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  isBlocked ? 'BLOCKED' : '$available Available',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isBlocked ? AppColors.error : AppColors.success,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${av.bookedUnits} Booked',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
