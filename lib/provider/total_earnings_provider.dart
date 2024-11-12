import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_multi_store/models/order.dart';

class TotalEarningsProvider extends StateNotifier<int> {
  TotalEarningsProvider() : super(0);

  void calculateTotalEarnings(List<Order> orders) {
    int earning = 0;

    for(Order order in orders){
      if(order.delivered){
        earning += order.productPrice * order.quantity;
      }
    }

    state = earning;
  }
}

final totalEarningsProvider = StateNotifierProvider<TotalEarningsProvider, int>((ref) {
  return TotalEarningsProvider();
});
