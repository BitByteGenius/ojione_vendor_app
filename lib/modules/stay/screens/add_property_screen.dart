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
      title: 'Create Property Listing',
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
                // Top Banner / Header
                _buildHeaderBanner(context, isDark),
                const SizedBox(height: AppDimensions.spaceLg),

                // 1. Media & Files (Uploads)
                _buildMediaAndHostSection(context, isDark),
                const SizedBox(height: AppDimensions.spaceLg),

                // 2. Basic Information (Stay Type, Title, Description, Room Config)
                _buildBasicInformationSection(context, isDark),
                const SizedBox(height: AppDimensions.spaceLg),

                // 3. Location Details & Map Picker
                _buildLocationSection(context, isDark),
                const SizedBox(height: AppDimensions.spaceLg),

                // 4. Pricing & Availability
                _buildPricingAvailabilitySection(context, isDark),
                const SizedBox(height: AppDimensions.spaceLg),

                // 5. Amenities & Features
                _buildAmenitiesSection(context, isDark),
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
          color: isDark ? AppColors.darkBorder : AppColors.primary.withValues(alpha: 0.2),
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
            child: const Icon(Icons.add_business_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Onboard New Stay Property', style: AppTextStyles.h3),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                  'List your room, apartment, PG, hostel, or homestay. Provide accurate photos, pricing, and pinpoint GPS coordinates.',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 1: MEDIA & FILES (UPLOADS)
  // ==========================================
  Widget _buildMediaAndHostSection(BuildContext context, bool isDark) {
    return AppCard(
      title: '1. Media & Files (Uploads)',
      subtitle: 'Upload high-resolution property photos and verify host profile picture',
      trailing: Obx(() => Container(
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
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Host Profile Picture Card
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 520;
                final avatarWidget = Obx(() => Stack(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: NetworkImage(controller.hostAvatarUrl.value),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: controller.hostAvatarUrl.value.isEmpty
                          ? const Icon(Icons.person, size: 36, color: AppColors.primary)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ));

                final textDetails = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        const Text(
                          'Host Profile Picture',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Pre-filled from account',
                            style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Obx(() => Text(
                          'Host: ${controller.hostName.value} (Visible to incoming guests)',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        )),
                  ],
                );

                final actionBtn = OutlinedButton.icon(
                  onPressed: () => _showChangeAvatarDialog(context),
                  icon: const Icon(Icons.photo_camera_outlined, size: 16),
                  label: const Text('Change Photo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          avatarWidget,
                          const SizedBox(width: AppDimensions.spaceMd),
                          Expanded(child: textDetails),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),
                      actionBtn,
                    ],
                  );
                }

                return Row(
                  children: [
                    avatarWidget,
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(child: textDetails),
                    actionBtn,
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Property Photos Upload Area
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 500;
              final headerTexts = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Property Photos (images)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Upload clear photos of bedrooms, bathroom, kitchen, and exterior',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                children: [
                  headerTexts,
                  addBtn,
                ],
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
                  height: 140,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.primary),
                        SizedBox(height: 8),
                        Text('No photos uploaded yet', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('Click to upload bedroom, bathroom, kitchen, or exterior photos',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
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
          color: photo.isCover ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
          width: photo.isCover ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Top Badges (Tag & Cover)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getPhotoTagIcon(photo.tag), size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    photo.tag,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
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
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Action Controls
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Set as Cover',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                InkWell(
                  onTap: () => controller.removePhoto(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPhotoTagIcon(String tag) {
    switch (tag.toLowerCase()) {
      case 'bedroom':
        return Icons.bedroom_parent_rounded;
      case 'bathroom':
        return Icons.bathtub_rounded;
      case 'kitchen':
        return Icons.kitchen_rounded;
      case 'exterior':
        return Icons.holiday_village_rounded;
      default:
        return Icons.photo_library_rounded;
    }
  }

  // ==========================================
  // SECTION 2: BASIC INFORMATION
  // ==========================================
  Widget _buildBasicInformationSection(BuildContext context, bool isDark) {
    return AppCard(
      title: '2. Basic Information',
      subtitle: 'Specify accommodation type, title, overview description, and room layout',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stay Type Selector
          const Text(
            'Stay Type (stayType)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Select the category that best represents your property listing',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 12,
                runSpacing: 10,
                children: StayType.values.map((type) {
                  final isSelected = controller.selectedStayType.value == type;
                  return InkWell(
                    onTap: () => controller.selectedStayType.value = type,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryLight
                            : (isDark ? AppColors.darkSurface : Colors.white),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            type.icon,
                            size: 20,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                type.shortLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.primary),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: AppDimensions.spaceLg),

          // Property Title
          AppTextField(
            label: 'Listing Title (title)',
            hint: 'e.g. Modern 1BHK in HSR Layout or Cozy PG for Men',
            controller: controller.titleController,
            validator: Validators.required,
            helperText: 'A catchy, descriptive title increases booking inquiries',
            prefixIcon: const Icon(Icons.title_rounded, size: 18),
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Description
          AppTextField(
            label: 'Overview & Description (description)',
            hint: 'Detailed overview, house rules, curfew, nearby landmarks, public transit access, etc...',
            controller: controller.descriptionController,
            maxLines: 4,
            helperText: 'Describe amenities, rules, timings, and local neighborhood highlights',
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Room Configuration
          const Text(
            'Room Configuration (roomConfiguration)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              '1 BHK',
              '2 BHK',
              'Single Room',
              'Double Sharing',
              'Triple Sharing',
              'Studio Apt',
              'Dorm Bed',
            ].map((cfg) {
              return ActionChip(
                label: Text(cfg, style: const TextStyle(fontSize: 12)),
                backgroundColor: isDark ? AppColors.darkSurface : Colors.grey.shade100,
                side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                onPressed: () {
                  controller.roomConfigController.text = cfg;
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          AppTextField(
            hint: 'e.g. 1 BHK, Single Room, Double Sharing, Studio Apartment',
            controller: controller.roomConfigController,
            prefixIcon: const Icon(Icons.meeting_room_outlined, size: 18),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 3: LOCATION DETAILS & MAP PICKER
  // ==========================================
  Widget _buildLocationSection(BuildContext context, bool isDark) {
    return AppCard(
      title: '3. Location Details',
      subtitle: 'Street address, city, and exact GPS coordinates pinned on Google Maps',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 560;
              final addressField = AppTextField(
                label: 'Street Address (address)',
                hint: 'Full street address, flat number, building/society name',
                controller: controller.addressController,
                validator: Validators.required,
                prefixIcon: const Icon(Icons.home_outlined, size: 18),
              );
              final cityField = AppTextField(
                label: 'City (city)',
                hint: 'e.g. Bengaluru, Guwahati',
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
                label: 'State',
                hint: 'e.g. Karnataka, Assam',
                controller: controller.stateController,
                prefixIcon: const Icon(Icons.map_outlined, size: 18),
              );
              final pincodeField = AppTextField(
                label: 'Pincode',
                hint: 'e.g. 560102, 781001',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.map_rounded, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location Pin / Coordinates (latitude & longitude)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              'Captured via Map Picker widget for guest navigation',
                              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openMapPicker(context),
                      icon: const Icon(Icons.edit_location_alt_rounded, size: 16),
                      label: const Text('Adjust on Map'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMd),

                // Map Pin Details Readout
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.pin_drop_rounded, color: Colors.redAccent, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.locationPinName.value,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded, size: 12, color: AppColors.success),
                                SizedBox(width: 4),
                                Text('PIN LOCKED',
                                    style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
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
      initialAddress: '${controller.addressController.text}, ${controller.cityController.text}',
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
  // SECTION 4: PRICING & AVAILABILITY
  // ==========================================
  Widget _buildPricingAvailabilitySection(BuildContext context, bool isDark) {
    return AppCard(
      title: '4. Pricing & Availability',
      subtitle: 'Set daily rate, optional monthly rental, and total inventory count',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 560;
              final priceNight = AppTextField(
                label: 'Price Per Night (pricePerNight) *',
                hint: 'e.g. 2200',
                controller: controller.pricePerNightController,
                keyboardType: TextInputType.number,
                validator: Validators.numeric,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                helperText: 'Standard daily booking rate',
              );
              final priceMonth = AppTextField(
                label: 'Price Per Month (pricePerMonth)',
                hint: 'e.g. 28000',
                controller: controller.pricePerMonthController,
                keyboardType: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                helperText: 'Optional — Essential for PGs, hostels & flats',
              );

              if (isNarrow) {
                return Column(
                  children: [
                    priceNight,
                    const SizedBox(height: AppDimensions.spaceMd),
                    priceMonth,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: priceNight),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: priceMonth),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Available Units / Rooms
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Units / Rooms (availableRooms)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total count of available rooms or beds ready for booking',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
                Obx(() => Row(
                      children: [
                        IconButton(
                          onPressed: controller.decrementRooms,
                          icon: const Icon(Icons.remove_circle_outline_rounded),
                          color: AppColors.primary,
                          tooltip: 'Decrease Units',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          child: Text(
                            '${controller.availableRooms.value}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.incrementRooms,
                          icon: const Icon(Icons.add_circle_outline_rounded),
                          color: AppColors.primary,
                          tooltip: 'Increase Units',
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 5: AMENITIES & FEATURES
  // ==========================================
  Widget _buildAmenitiesSection(BuildContext context, bool isDark) {
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
        {'name': 'Washing Machine', 'icon': Icons.local_laundry_service_rounded},
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

    return AppCard(
      title: '5. Amenities & Features',
      subtitle: 'Multi-select checkboxes and facility chips to highlight property comforts',
      trailing: Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${controller.selectedAmenities.length} Selected',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: amenityCategories.entries.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.key,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: cat.value.map((item) {
                        final name = item['name'] as String;
                        final icon = item['icon'] as IconData;
                        final isSelected = controller.selectedAmenities.contains(name);

                        return FilterChip(
                          avatar: Icon(
                            icon,
                            size: 16,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                          label: Text(name),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          checkmarkColor: Colors.white,
                          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          onSelected: (_) => controller.toggleAmenity(name),
                        );
                      }).toList(),
                    )),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // ACTION BAR (SUBMISSION)
  // ==========================================
  Widget _buildActionBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 640;
          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() => AppButton(
                      text: 'Submit Property for Approval',
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: controller.isSubmitting.value,
                      onPressed: controller.isSubmitting.value ? null : controller.submitProperty,
                    )),
                const SizedBox(height: AppDimensions.spaceSm),
                Row(
                  children: [
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
                        text: 'Save as Draft',
                        type: AppButtonType.secondary,
                        icon: Icons.save_outlined,
                        onPressed: () {
                          Get.snackbar('Saved Draft', 'Property listing saved to local drafts');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Discard / Cancel',
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
                  onPressed: () {
                    Get.snackbar('Saved Draft', 'Property listing saved to local drafts');
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                flex: 2,
                child: Obx(() => AppButton(
                      text: 'Submit Property for Approval',
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: controller.isSubmitting.value,
                      onPressed: controller.isSubmitting.value ? null : controller.submitProperty,
                    )),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // DIALOGS: ADD PHOTO & CHANGE AVATAR
  // ==========================================
  void _showAddPhotoDialog(BuildContext context) {
    final urlCtrl = TextEditingController(
      text: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800',
    );
    String selectedTag = 'Bedroom';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            title: const Row(
              children: [
                Icon(Icons.add_photo_alternate_rounded, color: AppColors.primary),
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
                  const Text('Select Photo Category (Tag):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Bedroom', 'Bathroom', 'Kitchen', 'Exterior', 'Living Area'].map((tag) {
                      final isSelected = selectedTag == tag;
                      return ChoiceChip(
                        label: Text(tag),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => selectedTag = tag);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  const Text('Image URL:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: urlCtrl,
                    decoration: const InputDecoration(
                      hintText: 'https://images.unsplash.com/...',
                      prefixIcon: Icon(Icons.link_rounded),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Quick Samples:', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      ActionChip(
                        label: const Text('Modern Bedroom', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          urlCtrl.text = 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800';
                          setState(() => selectedTag = 'Bedroom');
                        },
                      ),
                      ActionChip(
                        label: const Text('Clean Bathroom', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          urlCtrl.text = 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800';
                          setState(() => selectedTag = 'Bathroom');
                        },
                      ),
                      ActionChip(
                        label: const Text('Modular Kitchen', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          urlCtrl.text = 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=800';
                          setState(() => selectedTag = 'Kitchen');
                        },
                      ),
                      ActionChip(
                        label: const Text('Building Exterior', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          urlCtrl.text = 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800';
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
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
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
              const Text('Enter Avatar Image URL:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: urlCtrl,
                decoration: const InputDecoration(
                  hintText: 'https://images.unsplash.com/photo-...',
                  prefixIcon: Icon(Icons.image_outlined),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Select Sample Avatar:', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Update Avatar'),
          ),
        ],
      ),
    );
  }
}
