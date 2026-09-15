import '../../../shared/enums/service_type.dart';
import 'booking_status_model.dart';

class BookingFilterModel {
  ServiceType? serviceType;
  BookingStatus? status;
  DateTime? fromDate;
  DateTime? toDate;
  String? searchQuery;

  BookingFilterModel({
    this.serviceType,
    this.status,
    this.fromDate,
    this.toDate,
    this.searchQuery,
  });

  bool get hasActiveFilters =>
      serviceType != null ||
      status != null ||
      fromDate != null ||
      toDate != null ||
      (searchQuery != null && searchQuery!.isNotEmpty);

  void reset() {
    serviceType = null;
    status = null;
    fromDate = null;
    toDate = null;
    searchQuery = null;
  }
}
