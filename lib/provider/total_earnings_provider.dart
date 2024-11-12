import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_multi_store/models/order.dart';

class TotalEarningsProvider extends StateNotifier<Map<String, dynamic>> {
  TotalEarningsProvider() : super({'totalEarnings': 0, 'totalOrderCounts': 0});

  void calculateTotalEarnings(List<Order> orders) {
    int earnings = 0;
    int orderCount = 0;

    for (Order order in orders) {
      if (order.delivered) {
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
    }

    state = {
      'totalEarnings': earnings,
      'totalOrderCounts': orderCount,
    };
  }
}

final totalEarningsProvider =
    StateNotifierProvider<TotalEarningsProvider, Map<String, dynamic>>((ref) {
  return TotalEarningsProvider();
});
