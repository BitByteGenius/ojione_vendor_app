import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  final double percentage; // 0.0 to 100.0
  final String? label;
  final String? trailingText;
  final Color progressColor;
  final Color? trackColor;
  final double height;

  const AppProgressBar({
    super.key,
    required this.percentage,
    this.label,
    this.trailingText,
    this.progressColor = AppColors.primary,
    this.trackColor,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgTrack = trackColor ?? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    final clampedFraction = (percentage / 100.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || trailingText != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              if (trailingText != null)
                Text(
                  trailingText!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Container(
            height: height,
            width: double.infinity,
            color: bgTrack,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: clampedFraction,
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
