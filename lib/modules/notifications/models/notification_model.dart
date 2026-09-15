enum NotificationType {
  booking('Booking Alert'),
  approval('Service Approval'),
  payment('Payment & Payout'),
  system('Platform Notice'),
  vendor('Account Update');

  final String label;
  const NotificationType(this.label);

  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'booking':
        return NotificationType.booking;
      case 'approval':
        return NotificationType.approval;
      case 'payment':
      case 'payout':
        return NotificationType.payment;
      case 'vendor':
        return NotificationType.vendor;
      case 'system':
      default:
        return NotificationType.system;
    }
  }
}

class AppNotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final String? actionRoute;
  final DateTime createdAt;

  AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.actionRoute,
    required this.createdAt,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: NotificationType.fromString(json['type'] ?? 'system'),
      isRead: json['is_read'] ?? false,
      actionRoute: json['action_route'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}
