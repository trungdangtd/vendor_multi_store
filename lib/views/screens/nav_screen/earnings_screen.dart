import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_multi_store/controllers/order_controller.dart';
import 'package:vendor_multi_store/provider/order_provider.dart';
import 'package:vendor_multi_store/provider/total_earnings_provider.dart';
import 'package:vendor_multi_store/provider/vendor_provider.dart';
import 'package:vendor_multi_store/views/screens/currency_formatter.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    //get orders from the server
    final user = ref.read(vendorProvider);
    if (user != null) {
      final OrderController orderController = OrderController();
      try {
        final orders = await orderController.loadOrders(vendorId: user.id);
        ref.read(orderProvider.notifier).setOrders(orders);
        ref.read(totalEarningsProvider.notifier).calculateTotalEarnings(orders);
      } catch (e) {
        // ignore: avoid_print
        print('Lỗi khi fetching order: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final totalEarnings = ref.watch(totalEarningsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                vendor!.fullname[0].toUpperCase(),
                style: GoogleFonts.montserrat(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 200,
              child: Text(
                'Xin chào, ${vendor.fullname}',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tổng Đơn hàng',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '${totalEarnings['totalOrderCounts']}',
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Tổng thu nhập',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                CurrencyFormatter.formatToVND(
                  totalEarnings['totalEarnings'],
                ),
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
