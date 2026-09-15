import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Formatters {
  Formatters._();

  static String currency(num amount, {String symbol = AppConstants.currencySymbol}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '$symbol ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String date(DateTime? dateTime, {String format = 'dd MMM yyyy'}) {
    if (dateTime == null) return '-';
    return DateFormat(format).format(dateTime);
  }

  static String time(DateTime? dateTime, {String format = 'hh:mm a'}) {
    if (dateTime == null) return '-';
    return DateFormat(format).format(dateTime);
  }

  static String dateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  static String compactNumber(num number) {
    return NumberFormat.compact(locale: 'en_IN').format(number);
  }
}
