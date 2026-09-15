import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<ApiResponse<List<AppNotificationModel>>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mock = [
      AppNotificationModel(
        id: '1',
        title: 'New Stay Booking Confirmed!',
        message: 'Rohan Das has booked Boutique Heritage Villa for 2 nights starting 17 Sep.',
        type: NotificationType.booking,
        isRead: false,
        actionRoute: '/bookings',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      AppNotificationModel(
        id: '2',
        title: 'Service Listing Approved',
        message: 'Your Local Experience "Assam Tea Tasting Tour" has been verified and is now live!',
        type: NotificationType.approval,
        isRead: false,
        actionRoute: '/experiences',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      AppNotificationModel(
        id: '3',
        title: 'Payout Disbursement Processed',
        message: '₹45,000 has been transferred to your SBI account ending in 8901.',
        type: NotificationType.payment,
        isRead: false,
        actionRoute: '/earnings/payouts',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AppNotificationModel(
        id: '4',
        title: 'Platform Maintenance Notice',
        message: 'Scheduled marketplace maintenance will take place on Sunday 2:00 AM - 4:00 AM IST.',
        type: NotificationType.system,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    return ApiResponse.success(data: mock);
  }

  Future<ApiResponse<bool>> markAsRead(String id) async {
    return ApiResponse.success(data: true);
  }
}
