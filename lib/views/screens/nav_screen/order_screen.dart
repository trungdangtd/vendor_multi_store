import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_multi_store/controllers/order_controller.dart';
import 'package:vendor_multi_store/provider/order_provider.dart';
import 'package:vendor_multi_store/provider/vendor_provider.dart';
import 'package:vendor_multi_store/views/screens/currency_formatter.dart';
import 'package:vendor_multi_store/views/screens/details/screens/order_detail_screen.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
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
      } catch (e) {
        // ignore: avoid_print
        print('Lỗi khi fetching order: $e');
      }
    }
  }

  Future<void> deleteOrder(String orderId) async {
    final OrderController orderController = OrderController();
    try {
      await orderController.deleteOrder(id: orderId, context: context);
      _fetchOrders();
    } catch (e) {
      // ignore: avoid_print
      print('Lỗi khi xóa đơn hàng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/cartb.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 60,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icons/cart.png',
                      width: 35,
                      height: 35,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            orders.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 61,
                top: 65,
                child: Text(
                  'Đơn đặt hàng của bạn',
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'Không tìm thấy đơn đặt hàng nào',
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 25,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return OrderDetailScreen(order: order);
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 335,
                      height: 153,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 336,
                                height: 154,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(
                                      0xffeff0f2,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    9,
                                  ),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: 13,
                                      top: 9,
                                      child: Container(
                                        width: 78,
                                        height: 78,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xffbcc5ff,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 10,
                                              top: 5,
                                              child: Image.network(
                                                order.image,
                                                width: 58,
                                                height: 67,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 101,
                                      top: 14,
                                      child: SizedBox(
                                        width: 216,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        order.productName,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        order.category,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: const Color(
                                                            0xff7f808c,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        CurrencyFormatter
                                                            .formatToVND(
                                                          order.productPrice,
                                                        ),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: const Color(
                                                            0xff0b0c1e,
                                                          ),
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 13,
                                      top: 113,
                                      child: Container(
                                        width:
                                            order.delivered == true ? 100 : 80,
                                        height: 25,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: order.delivered == true
                                              ? const Color(
                                                  0xff3c55ef,
                                                )
                                              : order.processing == true
                                                  ? Colors.purple
                                                  : Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 5,
                                              top: 2,
                                              child: Text(
                                                order.delivered == true
                                                    ? "Đã giao hàng"
                                                    : order.processing == true
                                                        ? "Đang xử lý"
                                                        : "Đã hủy",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    order.processing == true
                                        ? Positioned(
                                            top: 115,
                                            left: 298,
                                            child: InkWell(
                                              onTap: () {
                                                deleteOrder(order.id);
                                              },
                                              child: Image.asset(
                                                'assets/icons/delete.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
