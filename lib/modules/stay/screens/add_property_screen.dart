import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/enums/stay_type.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/stay_controller.dart';
import '../widgets/map_picker_dialog.dart';

class AddPropertyScreen extends GetView<StayController> {
  const AddPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MainLayout(
      title: 'Vendor Property Onboarding',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceLg,
          vertical: AppDimensions.spaceLg,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Banner
                _buildHeaderBanner(context, isDark),
                const SizedBox(height: AppDimensions.spaceMd),

                // Multi-Step Progress Indicator Header
                _buildStepProgressBar(context, isDark),
                const SizedBox(height: AppDimensions.spaceLg),

                // Step Body Content Switcher
                Obx(() {
                  switch (controller.currentStep.value) {
                    case 0:
                      return _buildBasicInfoStep(context, isDark);
                    case 1:
                      return _buildLocationStep(context, isDark);
                    case 2:
                      return _buildPricingInventoryStep(context, isDark);
                    case 3:
                      return _buildAmenitiesRulesStep(context, isDark);
                    case 4:
                      return _buildPhotosStep(context, isDark);
                    case 5:
                      return _buildHostDocumentsStep(context, isDark);
                    case 6:
                      return _buildReviewStep(context, isDark);
                    default:
                      return _buildBasicInfoStep(context, isDark);
                  }
                }),

                const SizedBox(height: AppDimensions.spaceXl),

                // Bottom Action Bar
                _buildActionBar(context, isDark),
                const SizedBox(height: AppDimensions.space2xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // HEADER BANNER
  // ==========================================
  Widget _buildHeaderBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F291E), const Color(0xFF1E293B)]
              : [AppColors.primaryLight, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_business_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Add New Stay Property', style: AppTextStyles.h3),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Verified Vendor Portal',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'List your room, apartment, PG, hostel, homestay, or mess. Complete all 7 steps for fast admin approval.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MULTI-STEP PROGRESS INDICATOR BAR
  // ==========================================
  Widget _buildStepProgressBar(BuildContext context, bool isDark) {
    final stepLabels = [
      'Basic Info',
      'Location',
      'Pricing',
      'Amenities',
      'Photos',
      'Verification',
      'Review',
    ];

    final stepIcons = [
      Icons.info_outline_rounded,
      Icons.location_on_outlined,
      Icons.payments_outlined,
      Icons.style_outlined,
      Icons.photo_library_outlined,
      Icons.verified_user_outlined,
      Icons.rate_review_outlined,
    ];

    return Obx(() {
      final current = controller.currentStep.value;

      return Container(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 640;

            if (isCompact) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Step ${current + 1} of 7',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            stepLabels[current],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${((current + 1) / 7 * 100).round()}% Completed',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (current + 1) / 7,
                      minHeight: 6,
                      backgroundColor: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: List.generate(7, (index) {
                final isSelected = index == current;
                final isCompleted =
                    index < current ||
                    index <= controller.maxCompletedStep.value;

                return Expanded(
                  child: InkWell(
                    onTap: () => controller.goToStep(index),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.primary
                                  : (isCompleted
                                        ? AppColors.primaryLight
                                        : (isDark
                                              ? AppColors.darkBackground
                                              : Colors.grey.shade100)),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isCompleted
                                          ? AppColors.primary
                                          : Colors.grey.shade300),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Icon(
                              isCompleted && !isSelected
                                  ? Icons.check_rounded
                                  : stepIcons[index],
                              size: 18,
                              color: isSelected
                                  ? Colors.white
                                  : (isCompleted
                                        ? AppColors.primary
                                        : AppColors.textMuted),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            stepLabels[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                        ? AppColors.textSecondary
                                        : AppColors.textMuted),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      );
    });
  }

  // ==========================================
  // STEP 0: BASIC INFORMATION & STAY TYPE
  // ==========================================
  Widget _buildBasicInfoStep(BuildContext context, bool isDark) {
    return AppCard(
      title: '1. Basic Property Information',
      subtitle:
          'Select stay category, property subtype, title, overview description, and furnishing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stay Category Selector
          const Text(
            'Stay Category (stayType) *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Select the primary classification of your stay listing',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          Obx(
            () => Wrap(
              spacing: 12,
              runSpacing: 10,
              children: StayType.values.map((type) {
                final isSelected = controller.selectedStayType.value == type;
                return InkWell(
                  onTap: () {
                    controller.selectedStayType.value = type;
                    if (type == StayType.flat)
                      controller.selectedPropertyType.value = '1BHK';
                    if (type == StayType.pg)
                      controller.selectedPropertyType.value = 'PG / Co-Living';
                    if (type == StayType.room)
                      controller.selectedPropertyType.value = '1RK / Room';
                    if (type == StayType.hostel)
                      controller.selectedPropertyType.value = 'Dorm Bed';
                    if (type == StayType.homestay)
                      controller.selectedPropertyType.value = 'Homestay';
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight
                          : (isDark ? AppColors.darkSurface : Colors.white),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type.icon,
                          size: 20,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              type.displayName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primaryDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              type.shortLabel,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Property Subtype / Configuration Chips
          const Text(
            'Property Configuration / Subtype *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Obx(() {
            final configOptions = [
              '1RK',
              '1BHK',
              '2BHK',
              '3BHK',
              'Single Room',
              'Double Sharing',
              'Triple Sharing',
              'Dorm Bed',
              'PG / Co-Living',
              'Mess / Dining',
              'Deluxe Room',
              'Homestay',
              'Villa',
            ];
            return Wrap(
              spacing: 8,
              runSpacing: 6,
              children: configOptions.map((opt) {
                final isSelected = controller.selectedPropertyType.value == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (val) {
                    if (val) {
                      controller.selectedPropertyType.value = opt;
                      controller.roomConfigController.text = opt;
                    }
                  },
                );
              }).toList(),
            );
          }),
          const SizedBox(height: AppDimensions.spaceLg),

          // Property Title
          AppTextField(
            label: 'Property Title (name) *',
            hint:
                'e.g. Modern 1BHK in HSR Layout or Cozy Mens PG near Tech Park',
            controller: controller.titleController,
            validator: Validators.required,
            helperText: 'A clear, descriptive title increases guest bookings',
            prefixIcon: const Icon(Icons.title_rounded, size: 18),
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Description
          AppTextField(
            label: 'Overview & Description (description) *',
            hint:
                'Describe house layout, nearby landmarks, public transit access, curfew, food facilities...',
            controller: controller.descriptionController,
            maxLines: 4,
            validator: Validators.required,
            helperText:
                'Provide detailed information for prospective guests and tenants',
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Furnishing Status
          const Text(
            'Furnishing Status',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Obx(
            () => Row(
              children: ['Fully Furnished', 'Semi-Furnished', 'Unfurnished']
                  .map((furnishing) {
                    final isSelected =
                        controller.selectedFurnishing.value == furnishing;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(furnishing),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (val) {
                          if (val)
                            controller.selectedFurnishing.value = furnishing;
                        },
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 1: LOCATION DETAILS & GPS MAP PIN
  // ==========================================
  Widget _buildLocationStep(BuildContext context, bool isDark) {
    return AppCard(
      title: '2. Location & GPS Mapping',
      subtitle:
          'Street address, city, state, pincode, and exact map pin coordinates',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 560;
              final addressField = AppTextField(
                label: 'Street Address *',
                hint: 'Full street address, building name, flat number',
                controller: controller.addressController,
                validator: Validators.required,
                prefixIcon: const Icon(Icons.home_outlined, size: 18),
              );
              final cityField = AppTextField(
                label: 'City *',
                hint: 'e.g. Guwahati, Bengaluru',
                controller: controller.cityController,
                validator: Validators.required,
                prefixIcon: const Icon(Icons.location_city_rounded, size: 18),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    addressField,
                    const SizedBox(height: AppDimensions.spaceMd),
                    cityField,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(flex: 2, child: addressField),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: cityField),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 560;
              final stateField = AppTextField(
                label: 'State *',
                hint: 'e.g. Assam, Karnataka',
                controller: controller.stateController,
                prefixIcon: const Icon(Icons.map_outlined, size: 18),
              );
              final pincodeField = AppTextField(
                label: 'Pincode *',
                hint: 'e.g. 781001, 560102',
                controller: controller.pincodeController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.pin_drop_outlined, size: 18),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    stateField,
                    const SizedBox(height: AppDimensions.spaceMd),
                    pincodeField,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: stateField),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: pincodeField),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          AppTextField(
            label: 'Nearby Landmarks & Access',
            hint: 'e.g. Near BDA Complex, 5 mins walk from metro station',
            controller: controller.nearbyLandmarksController,
            prefixIcon: const Icon(Icons.explore_outlined, size: 18),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Interactive Map Picker Preview Card
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 540;
                    final headerInfo = Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.map_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Map Location Pin (GPS Coordinates)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Pinpoint location for guest navigation & map searches',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );

                    final pinBtn = ElevatedButton.icon(
                      onPressed: () => _openMapPicker(context),
                      icon: const Icon(
                        Icons.edit_location_alt_rounded,
                        size: 16,
                      ),
                      label: const Text('Adjust Pin on Map'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headerInfo,
                          const SizedBox(height: AppDimensions.spaceSm),
                          pinBtn,
                        ],
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: headerInfo),
                        pinBtn,
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.spaceMd),

                // Map Pin Details Readout
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.pin_drop_rounded,
                          color: Colors.redAccent,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.locationPinName.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Coordinates: Lat: ${controller.latitude.value.toStringAsFixed(5)}, Lng: ${controller.longitude.value.toStringAsFixed(5)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 12,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'PIN LOCKED',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMapPicker(BuildContext context) async {
    final result = await MapPickerDialog.show(
      context: context,
      initialLat: controller.latitude.value,
      initialLng: controller.longitude.value,
      initialAddress:
          '${controller.addressController.text}, ${controller.cityController.text}',
    );

    if (result != null) {
      controller.setCoordinates(
        lat: result.latitude,
        lng: result.longitude,
        locationName: result.locationName,
      );
      Get.snackbar(
        'Location Pin Updated',
        'Pinned at ${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ==========================================
  // STEP 2: PRICING, INVENTORY & OCCUPANCY
  // ==========================================
  Widget _buildPricingInventoryStep(BuildContext context, bool isDark) {
    return AppCard(
      title: '3. Pricing, Rent & Inventory Details',
      subtitle:
          'Set nightly rate, monthly rent, deposit amount, occupancy limits, and availability date',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              final priceNight = AppTextField(
                label: 'Base Price Per Night (₹) *',
                hint: 'e.g. 2200',
                controller: controller.pricePerNightController,
                keyboardType: TextInputType.number,
                validator: Validators.numeric,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    '₹',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                helperText: 'Standard daily booking rate',
              );

              final priceMonth = AppTextField(
                label: 'Monthly Rent / Rate (₹)',
                hint: 'e.g. 28000',
                controller: controller.pricePerMonthController,
                keyboardType: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    '₹',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                helperText: 'Recommended for PGs, hostels & flats',
              );

              final depositAmount = AppTextField(
                label: 'Security Deposit (₹)',
                hint: 'e.g. 10000',
                controller: controller.depositAmountController,
                keyboardType: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    '₹',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                helperText: 'Refundable security deposit',
              );

              if (isNarrow) {
                return Column(
                  children: [
                    priceNight,
                    const SizedBox(height: AppDimensions.spaceMd),
                    priceMonth,
                    const SizedBox(height: AppDimensions.spaceMd),
                    depositAmount,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: priceNight),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: priceMonth),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: depositAmount),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Steppers: Total Units & Max Occupancy
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 540;

              final unitsStepper = Container(
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Units / Rooms',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Total count ready for booking',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Row(
                        children: [
                          IconButton(
                            onPressed: controller.decrementRooms,
                            icon: const Icon(
                              Icons.remove_circle_outline_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${controller.availableRooms.value}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: controller.incrementRooms,
                            icon: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

              final occupancyStepper = Container(
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Max Occupancy (Guests)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Max guests per room/unit',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Row(
                        children: [
                          IconButton(
                            onPressed: controller.decrementOccupancy,
                            icon: const Icon(
                              Icons.remove_circle_outline_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${controller.maxOccupancy.value}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: controller.incrementOccupancy,
                            icon: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    unitsStepper,
                    const SizedBox(height: AppDimensions.spaceMd),
                    occupancyStepper,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: unitsStepper),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: occupancyStepper),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Available From Date Picker & Timings
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 560;

              final datePickerWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available From Date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Obx(() {
                    final dateStr = controller.availableFromDate.value != null
                        ? '${controller.availableFromDate.value!.day}/${controller.availableFromDate.value!.month}/${controller.availableFromDate.value!.year}'
                        : 'Select Date';
                    return OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              controller.availableFromDate.value ??
                              DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) {
                          controller.availableFromDate.value = picked;
                        }
                      },
                      icon: const Icon(Icons.calendar_month_rounded, size: 18),
                      label: Text(dateStr),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
                ],
              );

              final checkInWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Check-in Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: controller.checkInTime.value,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items:
                          [
                                '11:00 AM',
                                '12:00 PM',
                                '01:00 PM',
                                '02:00 PM',
                                '03:00 PM',
                              ]
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) controller.checkInTime.value = val;
                      },
                    ),
                  ),
                ],
              );

              final checkOutWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Check-out Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: controller.checkOutTime.value,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: ['10:00 AM', '11:00 AM', '12:00 PM', '01:00 PM']
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) controller.checkOutTime.value = val;
                      },
                    ),
                  ),
                ],
              );

              if (isNarrow) {
                return Column(
                  children: [
                    datePickerWidget,
                    const SizedBox(height: AppDimensions.spaceMd),
                    Row(
                      children: [
                        Expanded(child: checkInWidget),
                        const SizedBox(width: AppDimensions.spaceMd),
                        Expanded(child: checkOutWidget),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: datePickerWidget),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: checkInWidget),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: checkOutWidget),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 3: AMENITIES & HOUSE RULES
  // ==========================================
  Widget _buildAmenitiesRulesStep(BuildContext context, bool isDark) {
    final amenityCategories = {
      'Essentials': [
        {'name': 'WiFi', 'icon': Icons.wifi_rounded},
        {'name': 'AC', 'icon': Icons.ac_unit_rounded},
        {'name': 'Geyser', 'icon': Icons.hot_tub_rounded},
        {'name': 'Power Backup', 'icon': Icons.bolt_rounded},
        {'name': 'RO Water', 'icon': Icons.water_drop_rounded},
      ],
      'Living & Meals': [
        {'name': 'Meals Included', 'icon': Icons.restaurant_rounded},
        {'name': 'Kitchen Access', 'icon': Icons.kitchen_rounded},
        {
          'name': 'Washing Machine',
          'icon': Icons.local_laundry_service_rounded,
        },
        {'name': 'Housekeeping', 'icon': Icons.cleaning_services_rounded},
        {'name': 'TV', 'icon': Icons.tv_rounded},
      ],
      'Safety & Facilities': [
        {'name': 'Parking', 'icon': Icons.local_parking_rounded},
        {'name': 'CCTV', 'icon': Icons.videocam_rounded},
        {'name': 'Security Guard', 'icon': Icons.security_rounded},
        {'name': 'Gym', 'icon': Icons.fitness_center_rounded},
        {'name': 'Elevator', 'icon': Icons.elevator_rounded},
      ],
      'Room Comfort': [
        {'name': 'Attached Washroom', 'icon': Icons.bathtub_outlined},
        {'name': 'Balcony', 'icon': Icons.balcony_rounded},
        {'name': 'Study Table', 'icon': Icons.desk_rounded},
        {'name': 'Refrigerator', 'icon': Icons.kitchen_outlined},
      ],
    };

    final predefinedRules = [
      'No Smoking inside rooms',
      'Curfew: 11:00 PM',
      'No Loud Parties',
      'Valid Govt ID Required',
      'Pets Allowed',
      'Quiet Hours after 10 PM',
      'Visitors allowed till 8 PM',
    ];

    return AppCard(
      title: '4. Amenities & House Rules',
      subtitle: 'Select property comforts, guest policies, and house rules',
      trailing: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${controller.selectedAmenities.length} Amenities Selected',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amenities Grid Categories
          const Text(
            'Select Property Amenities *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ...amenityCategories.entries.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.key.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: cat.value.map((item) {
                        final name = item['name'] as String;
                        final icon = item['icon'] as IconData;
                        final isSelected = controller.selectedAmenities
                            .contains(name);

                        return FilterChip(
                          avatar: Icon(
                            icon,
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primary,
                          ),
                          label: Text(name),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          checkmarkColor: Colors.white,
                          backgroundColor: isDark
                              ? AppColors.darkSurface
                              : Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                          ),
                          onSelected: (_) => controller.toggleAmenity(name),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 32),

          // Target Audience / Gender Restriction
          const Text(
            'Guest Eligibility / Preference',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              children:
                  [
                    'Unisex / All Guests',
                    'Male Only (Boys PG)',
                    'Female Only (Girls PG)',
                    'Families Only',
                    'Couples Welcome',
                  ].map((g) {
                    final isSelected = controller.genderRestriction.value == g;
                    return ChoiceChip(
                      label: Text(g),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        if (val) controller.genderRestriction.value = g;
                      },
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // House Rules Section
          const Text(
            'House Rules & Policies',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: predefinedRules.map((rule) {
                final isSelected = controller.houseRules.contains(rule);
                return FilterChip(
                  label: Text(rule),
                  selected: isSelected,
                  selectedColor: Colors.indigo,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: 12,
                  ),
                  onSelected: (_) => controller.toggleHouseRule(rule),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Add Custom House Rule Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.customRuleController,
                  decoration: const InputDecoration(
                    hintText: 'Add custom rule (e.g. No shoes inside bedroom)',
                    prefixIcon: Icon(Icons.rule_rounded, size: 18),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: controller.addCustomHouseRule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                child: const Text('Add Rule'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 4: PHOTOS & GALLERY
  // ==========================================
  Widget _buildPhotosStep(BuildContext context, bool isDark) {
    return AppCard(
      title: '5. Property Photos & Gallery',
      subtitle:
          'Upload high-res photos for bedroom, bathroom, kitchen, exterior, and select cover photo',
      trailing: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${controller.uploadedPhotos.length} Photos Added',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 500;
              final headerTexts = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Property Photos (min 1 required) *',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Higher resolution photos significantly improve guest booking conversions',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              );
              final addBtn = ElevatedButton.icon(
                onPressed: () => _showAddPhotoDialog(context),
                icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                label: const Text('Add Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerTexts,
                    const SizedBox(height: AppDimensions.spaceSm),
                    addBtn,
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [headerTexts, addBtn],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Photos Grid
          Obx(() {
            if (controller.uploadedPhotos.isEmpty) {
              return InkWell(
                onTap: () => _showAddPhotoDialog(context),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 42,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No property photos uploaded yet',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Click to upload photos of bedroom, bathroom, kitchen, or exterior',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.25,
              ),
              itemCount: controller.uploadedPhotos.length,
              itemBuilder: (context, index) {
                final photo = controller.uploadedPhotos[index];
                return _buildPhotoTile(photo, index);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPhotoTile(PropertyPhotoItem photo, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: photo.isCover
              ? AppColors.primary
              : Colors.grey.withValues(alpha: 0.3),
          width: photo.isCover ? 2.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            photo.url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                photo.tag,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (photo.isCover)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                    SizedBox(width: 3),
                    Text(
                      'COVER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 6,
            left: 6,
            right: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!photo.isCover)
                  InkWell(
                    onTap: () => controller.setCoverPhoto(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Set Cover',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                InkWell(
                  onTap: () => controller.removePhoto(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 5: HOST CONTACT & VERIFICATION DOCUMENTS
  // ==========================================
  Widget _buildHostDocumentsStep(BuildContext context, bool isDark) {
    return AppCard(
      title: '6. Host Contact & Verification Documents',
      subtitle:
          'Host profile, contact details, ownership proof, utility bill & government ID',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Host Profile Picture Card
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                Obx(
                  () => CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      controller.hostAvatarUrl.value,
                    ),
                    child: controller.hostAvatarUrl.value.isEmpty
                        ? const Icon(Icons.person, size: 32)
                        : null,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          'Host: ${controller.hostName.value}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Verified Vendor Profile Avatar (Shown on guest stay listings)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showChangeAvatarDialog(context),
                  icon: const Icon(Icons.photo_camera_outlined, size: 16),
                  label: const Text('Change'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Contact Details
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 560;
              final phoneField = AppTextField(
                label: 'Host Contact Phone Number *',
                hint: '+91 98765 43210',
                controller: controller.hostPhoneController,
                validator: Validators.required,
                prefixIcon: const Icon(Icons.phone_outlined, size: 18),
              );
              final emailField = AppTextField(
                label: 'Host Email Address',
                hint: 'vendor@oji.com',
                controller: controller.hostEmailController,
                prefixIcon: const Icon(Icons.email_outlined, size: 18),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    phoneField,
                    const SizedBox(height: AppDimensions.spaceMd),
                    emailField,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: phoneField),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: emailField),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Verification Documents Checklist
          const Text(
            'Verification Documents Upload',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Upload required documents to pass admin compliance and activate listing',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),

          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.uploadedDocuments.length,
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final doc = controller.uploadedDocuments[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: doc.isUploaded
                          ? AppColors.success.withValues(alpha: 0.5)
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        doc.isUploaded
                            ? Icons.verified_user_rounded
                            : Icons.description_outlined,
                        color: doc.isUploaded
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  doc.docType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                if (doc.isRequired) ...[
                                  const SizedBox(width: 6),
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doc.isUploaded
                                  ? 'Attached: ${doc.fileName}'
                                  : 'Status: Pending Upload',
                              style: TextStyle(
                                fontSize: 11,
                                color: doc.isUploaded
                                    ? AppColors.success
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          controller.toggleDocumentUpload(
                            index,
                            'document_${index + 1}.pdf',
                          );
                        },
                        icon: Icon(
                          doc.isUploaded ? Icons.check : Icons.upload_file,
                          size: 14,
                        ),
                        label: Text(doc.isUploaded ? 'Uploaded' : 'Upload'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: doc.isUploaded
                              ? AppColors.success
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 6: COMPREHENSIVE REVIEW & SUBMIT
  // ==========================================
  Widget _buildReviewStep(BuildContext context, bool isDark) {
    return AppCard(
      title: '7. Review Listing & Confirm Submission',
      subtitle:
          'Double-check all entered property details before submitting for admin verification',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Summary Card
          Obx(() {
            final coverUrl = controller.uploadedPhotos
                .firstWhere(
                  (p) => p.isCover,
                  orElse: () => controller.uploadedPhotos.isNotEmpty
                      ? controller.uploadedPhotos.first
                      : PropertyPhotoItem(id: '0', url: '', tag: ''),
                )
                .url;

            return Container(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: coverUrl.isNotEmpty
                            ? Image.network(
                                coverUrl,
                                width: 100,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 100,
                                height: 80,
                                color: Colors.grey.shade300,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.titleController.text.trim().isNotEmpty
                                  ? controller.titleController.text.trim()
                                  : 'Property Title',
                              style: AppTextStyles.h4,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${controller.selectedPropertyType.value} (${controller.selectedStayType.value.displayName}) • ${controller.selectedFurnishing.value}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${controller.addressController.text}, ${controller.cityController.text}, ${controller.stateController.text} - ${controller.pincodeController.text}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Pricing & Inventory Summary
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      _buildSummaryItem(
                        'Nightly Price',
                        '₹${controller.pricePerNightController.text} / night',
                        Icons.payments_rounded,
                      ),
                      if (controller.pricePerMonthController.text.isNotEmpty)
                        _buildSummaryItem(
                          'Monthly Rent',
                          '₹${controller.pricePerMonthController.text} / month',
                          Icons.calendar_month_rounded,
                        ),
                      _buildSummaryItem(
                        'Inventory',
                        '${controller.availableRooms.value} Units Available',
                        Icons.meeting_room_rounded,
                      ),
                      _buildSummaryItem(
                        'Occupancy',
                        'Max ${controller.maxOccupancy.value} Guests/unit',
                        Icons.people_alt_rounded,
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Amenities & Documents Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${controller.selectedAmenities.length} Amenities • ${controller.houseRules.length} Rules • ${controller.uploadedPhotos.length} Photos',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'READY FOR ADMIN REVIEW',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppDimensions.spaceLg),

          // Declaration Terms Checkbox
          Obx(
            () => CheckboxListTile(
              value: controller.isTermsAgreed.value,
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) {
                if (val != null) controller.isTermsAgreed.value = val;
              },
              title: const Text(
                'I hereby declare that all property information, pricing, documents, and photos provided above are accurate and genuine.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // ACTION BAR (SUBMISSION & STEPPER NAV)
  // ==========================================
  Widget _buildActionBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final current = controller.currentStep.value;
        final isLastStep = current == controller.totalSteps - 1;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 640;

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isLastStep)
                    AppButton(
                      text: 'Submit Property for Approval',
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: controller.isSubmitting.value,
                      onPressed: controller.isSubmitting.value
                          ? null
                          : controller.submitProperty,
                    )
                  else
                    AppButton(
                      text: 'Next Step',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: controller.nextStep,
                    ),
                  const SizedBox(height: AppDimensions.spaceSm),
                  Row(
                    children: [
                      if (current > 0)
                        Expanded(
                          child: AppButton(
                            text: 'Previous',
                            type: AppButtonType.outline,
                            onPressed: controller.previousStep,
                          ),
                        )
                      else
                        Expanded(
                          child: AppButton(
                            text: 'Cancel',
                            type: AppButtonType.text,
                            onPressed: () => Get.back(),
                          ),
                        ),
                      const SizedBox(width: AppDimensions.spaceSm),
                      Expanded(
                        child: AppButton(
                          text: 'Save Draft',
                          type: AppButtonType.secondary,
                          icon: Icons.save_outlined,
                          onPressed: controller.saveDraft,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return Row(
              children: [
                if (current > 0)
                  Expanded(
                    child: AppButton(
                      text: 'Previous Step',
                      type: AppButtonType.outline,
                      icon: Icons.arrow_back_rounded,
                      onPressed: controller.previousStep,
                    ),
                  )
                else
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      type: AppButtonType.text,
                      onPressed: () => Get.back(),
                    ),
                  ),
                const SizedBox(width: AppDimensions.spaceMd),
                Expanded(
                  child: AppButton(
                    text: 'Save as Draft',
                    type: AppButtonType.secondary,
                    icon: Icons.save_outlined,
                    onPressed: controller.saveDraft,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMd),
                Expanded(
                  flex: 2,
                  child: isLastStep
                      ? AppButton(
                          text: 'Submit Property for Approval',
                          icon: Icons.check_circle_outline_rounded,
                          isLoading: controller.isSubmitting.value,
                          onPressed: controller.isSubmitting.value
                              ? null
                              : controller.submitProperty,
                        )
                      : AppButton(
                          text: 'Next Step',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: controller.nextStep,
                        ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  // ==========================================
  // DIALOGS: ADD PHOTO & CHANGE AVATAR
  // ==========================================
  void _showAddPhotoDialog(BuildContext context) {
    final urlCtrl = TextEditingController(
      text:
          'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800',
    );
    String selectedTag = 'Bedroom';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.add_photo_alternate_rounded,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8),
                Text('Add Property Image'),
              ],
            ),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Photo Category:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        [
                          'Bedroom',
                          'Bathroom',
                          'Kitchen',
                          'Exterior',
                          'Living Area',
                          'Dining',
                        ].map((tag) {
                          final isSelected = selectedTag == tag;
                          return ChoiceChip(
                            label: Text(tag),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              if (val) setState(() => selectedTag = tag);
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  const Text(
                    'Image URL:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: urlCtrl,
                    decoration: const InputDecoration(
                      hintText: 'https://images.unsplash.com/...',
                      prefixIcon: Icon(Icons.link_rounded),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Quick Samples:',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      ActionChip(
                        label: const Text(
                          'Modern Bedroom',
                          style: TextStyle(fontSize: 11),
                        ),
                        onPressed: () {
                          urlCtrl.text =
                              'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800';
                          setState(() => selectedTag = 'Bedroom');
                        },
                      ),
                      ActionChip(
                        label: const Text(
                          'Clean Bathroom',
                          style: TextStyle(fontSize: 11),
                        ),
                        onPressed: () {
                          urlCtrl.text =
                              'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800';
                          setState(() => selectedTag = 'Bathroom');
                        },
                      ),
                      ActionChip(
                        label: const Text(
                          'Modular Kitchen',
                          style: TextStyle(fontSize: 11),
                        ),
                        onPressed: () {
                          urlCtrl.text =
                              'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=800';
                          setState(() => selectedTag = 'Kitchen');
                        },
                      ),
                      ActionChip(
                        label: const Text(
                          'Building Exterior',
                          style: TextStyle(fontSize: 11),
                        ),
                        onPressed: () {
                          urlCtrl.text =
                              'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800';
                          setState(() => selectedTag = 'Exterior');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (urlCtrl.text.isNotEmpty) {
                    controller.addPhoto(urlCtrl.text.trim(), selectedTag);
                    Navigator.of(ctx).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Image'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showChangeAvatarDialog(BuildContext context) {
    final urlCtrl = TextEditingController(text: controller.hostAvatarUrl.value);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: const Row(
          children: [
            Icon(Icons.account_circle_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Update Host Profile Picture'),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Avatar Image URL:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: urlCtrl,
                decoration: const InputDecoration(
                  hintText: 'https://images.unsplash.com/photo-...',
                  prefixIcon: Icon(Icons.image_outlined),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select Sample Avatar:',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    [
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300',
                      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300',
                    ].map((url) {
                      return InkWell(
                        onTap: () => urlCtrl.text = url,
                        borderRadius: BorderRadius.circular(24),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(url),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlCtrl.text.isNotEmpty) {
                controller.updateHostAvatar(urlCtrl.text.trim());
                Navigator.of(ctx).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Update Avatar'),
          ),
        ],
      ),
    );
  }
}
