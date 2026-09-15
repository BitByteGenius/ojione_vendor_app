import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'app_responsive.dart';
import 'app_sidebar.dart';
import 'app_topbar.dart';

class MainLayout extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? trailingHeader;

  const MainLayout({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.trailingHeader,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppResponsive.isDesktop(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      drawer: !isDesktop
          ? const Drawer(
              child: AppSidebar(isCollapsed: false),
            )
          : null,
      floatingActionButton: widget.floatingActionButton,
      body: Row(
        children: [
          // Sidebar on Desktop
          if (isDesktop)
            AppSidebar(
              isCollapsed: _isCollapsed,
              onToggleCollapse: () {
                setState(() {
                  _isCollapsed = !_isCollapsed;
                });
              },
            ),

          // Main Screen Content Area
          Expanded(
            child: Column(
              children: [
                AppTopBar(
                  title: widget.title,
                  trailing: widget.trailingHeader,
                  onMenuPressed: !isDesktop
                      ? () => _scaffoldKey.currentState?.openDrawer()
                      : null,
                ),
                Expanded(
                  child: widget.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
