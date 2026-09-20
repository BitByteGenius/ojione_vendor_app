import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

class LocationPinResult {
  final double latitude;
  final double longitude;
  final String locationName;
  final String address;

  LocationPinResult({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.address,
  });
}

class MapPickerDialog extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final String initialAddress;

  const MapPickerDialog({
    super.key,
    this.initialLatitude = 26.1445,
    this.initialLongitude = 91.7362,
    this.initialAddress = '',
  });

  static Future<LocationPinResult?> show({
    required BuildContext context,
    double initialLat = 26.1445,
    double initialLng = 91.7362,
    String initialAddress = '',
  }) {
    return showDialog<LocationPinResult>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680, maxHeight: 760),
          child: MapPickerDialog(
            initialLatitude: initialLat,
            initialLongitude: initialLng,
            initialAddress: initialAddress,
          ),
        ),
      ),
    );
  }

  @override
  State<MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends State<MapPickerDialog> with SingleTickerProviderStateMixin {
  late double _latitude;
  late double _longitude;
  late TextEditingController _searchController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  String _selectedLocality = 'Custom Pin Location';
  Offset _pinOffset = const Offset(180, 160);
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _presets = [
    {
      'name': 'HSR Layout, Bengaluru',
      'lat': 12.9121,
      'lng': 77.6446,
      'address': 'Sector 2, HSR Layout, Bengaluru, Karnataka 560102',
    },
    {
      'name': 'Guwahati Central, Assam',
      'lat': 26.1445,
      'lng': 91.7362,
      'address': 'GS Road, Dispur, Guwahati, Assam 781005',
    },
    {
      'name': 'Kaziranga National Park',
      'lat': 26.5898,
      'lng': 93.4150,
      'address': 'Kohora Range, NH-37, Kaziranga, Assam 785609',
    },
    {
      'name': 'Police Bazar, Shillong',
      'lat': 25.5788,
      'lng': 91.8833,
      'address': 'Police Bazar, Shillong, Meghalaya 793001',
    },
  ];

  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLatitude;
    _longitude = widget.initialLongitude;
    _selectedLocality = widget.initialAddress.isNotEmpty ? widget.initialAddress : 'Pinpoint on Map';
    _searchController = TextEditingController(text: widget.initialAddress);
    _latController = TextEditingController(text: _latitude.toStringAsFixed(5));
    _lngController = TextEditingController(text: _longitude.toStringAsFixed(5));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _applyPreset(Map<String, dynamic> preset) {
    setState(() {
      _latitude = preset['lat'];
      _longitude = preset['lng'];
      _selectedLocality = preset['name'];
      _searchController.text = preset['name'];
      _latController.text = _latitude.toStringAsFixed(5);
      _lngController.text = _longitude.toStringAsFixed(5);
    });
  }

  void _onMapTap(TapDownDetails details, Size size) {
    setState(() {
      _pinOffset = details.localPosition;
      // Calculate delta from center to simulate coordinate adjustments
      final dx = (details.localPosition.dx - (size.width / 2)) / (size.width / 2);
      final dy = (details.localPosition.dy - (size.height / 2)) / (size.height / 2);

      _latitude = math.max(-90.0, math.min(90.0, _latitude - (dy * 0.008)));
      _longitude = math.max(-180.0, math.min(180.0, _longitude + (dx * 0.008)));

      _latController.text = _latitude.toStringAsFixed(5);
      _lngController.text = _longitude.toStringAsFixed(5);
      _selectedLocality = 'Selected Pin (${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg, vertical: AppDimensions.spaceMd),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Property Location Pin', style: AppTextStyles.h4),
                    const SizedBox(height: 2),
                    Text(
                      'Tap or drag anywhere on the map to set exact coordinates',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),

        // Quick Search & Presets
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimensions.spaceLg, AppDimensions.spaceMd, AppDimensions.spaceLg, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search locality, street, or landmark...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location_rounded, color: AppColors.primary),
                    tooltip: 'Current GPS Location',
                    onPressed: () {
                      _applyPreset(_presets[0]);
                      Get.snackbar('GPS', 'Acquired current vendor coordinates');
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    setState(() {
                      _selectedLocality = query;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _presets.map((preset) {
                    final isSelected = (_selectedLocality == preset['name']);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        avatar: Icon(
                          Icons.place_outlined,
                          size: 15,
                          color: isSelected ? Colors.white : AppColors.primary,
                        ),
                        label: Text(
                          preset['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        backgroundColor: isSelected ? AppColors.primary : (isDark ? AppColors.darkSurface : AppColors.lightBackground),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        onPressed: () => _applyPreset(preset),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Map Canvas Area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg, vertical: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return GestureDetector(
                        onTapDown: (details) => _onMapTap(details, size),
                        child: CustomPaint(
                          size: size,
                          painter: _MapCanvasPainter(isDark: isDark),
                        ),
                      );
                    },
                  ),

                  // Animated Map Pin Marker
                  Positioned(
                    left: _pinOffset.dx - 22,
                    top: _pinOffset.dy - 44,
                    child: IgnorePointer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.place_rounded, color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 + (_pulseController.value * 0.12),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.4),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 24),
                                ),
                              );
                            },
                          ),
                          Container(
                            width: 4,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating Instructions Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.lightBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.touch_app_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Click map to reposition pin',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.lightTextPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Zoom Mock Controls
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Column(
                      children: [
                        _buildZoomButton(Icons.add, () {
                          Get.snackbar('Zoom', 'Zoomed in (+1)', duration: const Duration(seconds: 1));
                        }),
                        const SizedBox(height: 4),
                        _buildZoomButton(Icons.remove, () {
                          Get.snackbar('Zoom', 'Zoomed out (-1)', duration: const Duration(seconds: 1));
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Latitude / Longitude manual input & Readout Footer
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Latitude', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _latController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            prefixIcon: Icon(Icons.explore_outlined, size: 16),
                          ),
                          onChanged: (v) {
                            final parsed = double.tryParse(v);
                            if (parsed != null) setState(() => _latitude = parsed);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Longitude', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _lngController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            prefixIcon: Icon(Icons.explore_outlined, size: 16),
                          ),
                          onChanged: (v) {
                            final parsed = double.tryParse(v);
                            if (parsed != null) setState(() => _longitude = parsed);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      type: AppButtonType.text,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      text: 'Confirm Location Pin',
                      icon: Icons.check_circle_rounded,
                      onPressed: () {
                        Navigator.of(context).pop(
                          LocationPinResult(
                            latitude: _latitude,
                            longitude: _longitude,
                            locationName: _selectedLocality,
                            address: _searchController.text.isNotEmpty
                                ? _searchController.text
                                : 'Lat: ${_latitude.toStringAsFixed(4)}, Lng: ${_longitude.toStringAsFixed(4)}',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  final bool isDark;

  _MapCanvasPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // Background terrain
    final bgPaint = Paint()..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE8ECEF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Parks / Green spaces
    final greenPaint = Paint()..color = isDark ? const Color(0xFF1E3A2F) : const Color(0xFFD1E7DD);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.1, size.height * 0.15, size.width * 0.3, size.height * 0.25), const Radius.circular(16)),
      greenPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.65, size.height * 0.55, size.width * 0.28, size.height * 0.32), const Radius.circular(20)),
      greenPaint,
    );

    // River / Water body
    final waterPaint = Paint()
      ..color = isDark ? const Color(0xFF1E3A5F) : const Color(0xFFC7DCF8)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final waterPath = Path();
    waterPath.moveTo(0, size.height * 0.75);
    waterPath.quadraticBezierTo(size.width * 0.4, size.height * 0.85, size.width, size.height * 0.45);
    canvas.drawPath(waterPath, waterPaint);

    // Major Highways / Roads
    final majorRoadPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFFFFFFF)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final roadPath1 = Path();
    roadPath1.moveTo(0, size.height * 0.35);
    roadPath1.lineTo(size.width, size.height * 0.4);
    canvas.drawPath(roadPath1, majorRoadPaint);

    final roadPath2 = Path();
    roadPath2.moveTo(size.width * 0.5, 0);
    roadPath2.lineTo(size.width * 0.52, size.height);
    canvas.drawPath(roadPath2, majorRoadPaint);

    // Secondary streets grid
    final gridPaint = Paint()
      ..color = isDark ? const Color(0xFF283548) : const Color(0xFFDFE4EA)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (double y = 40; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 10), gridPaint);
    }
    for (double x = 40; x < size.width; x += 70) {
      canvas.drawLine(Offset(x, 0), Offset(x + 10, size.height), gridPaint);
    }

    // Street Labels simulation
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);

    textPainter.text = TextSpan(
      text: 'NH-37 / EXPRESSWAY',
      style: TextStyle(color: labelColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.15, size.height * 0.36));

    textPainter.text = TextSpan(
      text: 'METRO STATION & TECH PARK',
      style: TextStyle(color: labelColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.54, size.height * 0.12));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
