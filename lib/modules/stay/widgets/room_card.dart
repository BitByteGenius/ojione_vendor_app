import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../controllers/stay_controller.dart';
import '../models/room_model.dart';

class RoomCard extends StatelessWidget {
  final RoomModel room;
  final VoidCallback? onEdit;

  const RoomCard({super.key, required this.room, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StayController>();
    final isAvailable = room.isAvailable;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.75,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppColors.stayServiceBg
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isAvailable
                          ? AppColors.stayService.withAlpha(40)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Icon(
                    Icons.king_bed_rounded,
                    color: isAvailable ? AppColors.stayService : Colors.grey,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              room.name,
                              style: AppTextStyles.h4.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isAvailable
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? const Color(0xFFECFDF5)
                                  : const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isAvailable
                                    ? const Color(0xFFA7F3D0)
                                    : const Color(0xFFFECACA),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              isAvailable ? 'AVAILABLE' : 'DEACTIVATED',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isAvailable
                                    ? const Color(0xFF047857)
                                    : const Color(0xFFDC2626),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${room.roomType} • Max ${room.maxOccupancy} Guests • ${room.totalRooms} Unit${room.totalRooms > 1 ? 's' : ''}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${Formatters.currency(room.basePricePerNight)} / night',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isAvailable
                              ? AppColors.stayService
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 28,
                      child: Switch.adaptive(
                        value: isAvailable,
                        activeTrackColor: AppColors.stayService,
                        onChanged: (_) {
                          controller.toggleRoomStatus(room.id);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAvailable ? 'Active for Booking' : 'Deactivated',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isAvailable
                            ? AppColors.stayService
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      tooltip: 'Edit Room',
                      onPressed:
                          onEdit ??
                          () {
                            Get.snackbar(
                              'Edit Room',
                              'Room editing settings for ${room.name}',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                        size: 18,
                      ),
                      tooltip: 'Delete Room',
                      onPressed: () =>
                          _confirmDeleteRoom(context, controller, room),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteRoom(
    BuildContext context,
    StayController controller,
    RoomModel r,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Room Unit'),
        content: Text(
          'Are you sure you want to delete "${r.name}"? This unit will be removed from inventory.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteRoom(r.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
