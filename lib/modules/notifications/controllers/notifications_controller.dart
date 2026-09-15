import 'package:get/get.dart';
import '../data/notifications_repository.dart';
import '../models/notification_model.dart';

class NotificationsController extends GetxController {
  final NotificationsRepository _repository = NotificationsRepository();

  final isLoading = true.obs;
  final notifications = <AppNotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final res = await _repository.getNotifications();
      if (res.success && res.data != null) {
        notifications.assignAll(res.data!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = notifications[index];
      notifications[index] = AppNotificationModel(
        id: old.id,
        title: old.title,
        message: old.message,
        type: old.type,
        isRead: true,
        actionRoute: old.actionRoute,
        createdAt: old.createdAt,
      );
      _repository.markAsRead(id);
    }
  }
}
