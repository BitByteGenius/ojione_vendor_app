class StayPricingModel {
  final String id;
  final String propertyId;
  final String? roomId;
  final double weekdayBasePrice;
  final double weekendBasePrice;
  final double extraAdultPrice;
  final double extraChildPrice;
  final double cleaningFee;
  final double taxPercentage;
  final double discountWeekly;
  final double discountMonthly;

  StayPricingModel({
    required this.id,
    required this.propertyId,
    this.roomId,
    required this.weekdayBasePrice,
    required this.weekendBasePrice,
    required this.extraAdultPrice,
    required this.extraChildPrice,
    required this.cleaningFee,
    required this.taxPercentage,
    this.discountWeekly = 10.0,
    this.discountMonthly = 25.0,
  });

  factory StayPricingModel.fromJson(Map<String, dynamic> json) {
    return StayPricingModel(
      id: json['id'] ?? '',
      propertyId: json['property_id'] ?? '',
      roomId: json['room_id'],
      weekdayBasePrice: (json['weekday_base_price'] ?? 0).toDouble(),
      weekendBasePrice: (json['weekend_base_price'] ?? 0).toDouble(),
      extraAdultPrice: (json['extra_adult_price'] ?? 0).toDouble(),
      extraChildPrice: (json['extra_child_price'] ?? 0).toDouble(),
      cleaningFee: (json['cleaning_fee'] ?? 0).toDouble(),
      taxPercentage: (json['tax_percentage'] ?? 12.0).toDouble(),
      discountWeekly: (json['discount_weekly'] ?? 10.0).toDouble(),
      discountMonthly: (json['discount_monthly'] ?? 25.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'room_id': roomId,
      'weekday_base_price': weekdayBasePrice,
      'weekend_base_price': weekendBasePrice,
      'extra_adult_price': extraAdultPrice,
      'extra_child_price': extraChildPrice,
      'cleaning_fee': cleaningFee,
      'tax_percentage': taxPercentage,
      'discount_weekly': discountWeekly,
      'discount_monthly': discountMonthly,
    };
  }
}
