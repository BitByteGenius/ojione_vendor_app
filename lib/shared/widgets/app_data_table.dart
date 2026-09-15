import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

class AppDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<Widget>> rows;
  final bool isLoading;
  final Widget? emptyState;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyState,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spaceXl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (rows.isEmpty && emptyState != null) {
      return emptyState!;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              ),
              dataRowMinHeight: 52,
              dataRowMaxHeight: 56,
              horizontalMargin: AppDimensions.spaceMd,
              columnSpacing: AppDimensions.spaceLg,
              columns: columns
                  .map(
                    (title) => DataColumn(
                      label: Text(
                        title.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              rows: rows
                  .map(
                    (cells) => DataRow(
                      cells: cells.map((cell) => DataCell(cell)).toList(),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
