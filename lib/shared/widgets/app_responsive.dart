import 'package:flutter/material.dart';
import '../../core/theme/app_dimensions.dart';

class AppResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const AppResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppDimensions.breakpointMobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppDimensions.breakpointMobile &&
      MediaQuery.of(context).size.width < AppDimensions.breakpointTablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppDimensions.breakpointTablet;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (width >= AppDimensions.breakpointTablet) {
      return desktop;
    } else if (width >= AppDimensions.breakpointMobile && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
