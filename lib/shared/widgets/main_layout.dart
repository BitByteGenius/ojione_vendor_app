import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'mobile_app_bar.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? trailingHeader;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final bool showVendorBadge;
  final bool showNotificationBell;

  const MainLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.floatingActionButton,
    this.trailingHeader,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.showVendorBadge = false,
    this.showNotificationBell = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.darkBackground : AppColors.lightBackground);

    final mergedActions = <Widget>[
      if (trailingHeader != null)
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: trailingHeader!,
        ),
      if (actions != null) ...actions!,
    ];

    return GestureDetector(
      // Dismiss keyboard when tapping outside inputs on mobile
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bg,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: MobileAppBar(
          title: title,
          subtitle: subtitle,
          showBackButton: showBackButton,
          onBackPressed: onBackPressed,
          actions: mergedActions.isNotEmpty ? mergedActions : null,
          showVendorBadge: showVendorBadge,
          showNotificationBell: showNotificationBell,
        ),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        body: SafeArea(
          top: false,
          child: body,
        ),
      ),
    );
  }
}
