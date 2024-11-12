import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatToVND(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(amount);
  }
}
