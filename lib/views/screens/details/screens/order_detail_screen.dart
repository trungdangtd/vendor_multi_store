import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_multi_store/controllers/order_controller.dart';
import 'package:vendor_multi_store/models/order.dart';
import 'package:vendor_multi_store/provider/order_provider.dart';
import 'package:vendor_multi_store/views/screens/currency_formatter.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    final updateOrder = orders.firstWhere(
      (element) => element.id == widget.order.id,
      orElse: () => widget.order,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.order.productName,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
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
                                      widget.order.image,
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
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              widget.order.productName,
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              widget.order.category,
                                              style: GoogleFonts.montserrat(
                                                color: const Color(
                                                  0xff7f808c,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              CurrencyFormatter.formatToVND(
                                                widget.order.productPrice,
                                              ),
                                              style: GoogleFonts.montserrat(
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
                              width: updateOrder.delivered == true ? 100 : 80,
                              height: 25,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: updateOrder.delivered == true
                                    ? const Color(
                                        0xff3c55ef,
                                      )
                                    : updateOrder.processing == true
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
                                      updateOrder.delivered == true
                                          ? "Đã giao hàng"
                                          : updateOrder.processing == true
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Container(
              width: 336,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(
                    0xffeff0f2,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                      8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông tin đơn hàng',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${widget.order.state} | ${widget.order.city} | ${widget.order.locality}",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Tới: ${widget.order.fullName}",
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Mã đơn hàng: ${widget.order.id}",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: updateOrder.delivered == true ||
                                updateOrder.processing == false
                            ? null
                            : () async {
                                await orderController
                                    .updateDeliveryStatus(
                                  id: widget.order.id,
                                  context: context,
                                )
                                    .whenComplete(() {
                                  ref
                                      .read(orderProvider.notifier)
                                      .updateOrderStatus(
                                        widget.order.id,
                                        delivered: true,
                                      );
                                });
                              },
                        child: Text(
                          updateOrder.delivered == true
                              ? 'Đã giao hàng'
                              : 'Đánh dấu đã giao hàng?',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: updateOrder.processing == false ||
                                updateOrder.delivered == true
                            ? null
                            : () async {
                                await orderController
                                    .cancelOrder(
                                  id: widget.order.id,
                                  context: context,
                                )
                                    .whenComplete(() {
                                  ref
                                      .read(orderProvider.notifier)
                                      .updateOrderStatus(
                                        widget.order.id,
                                        processing: false,
                                      );
                                });
                              },
                        child: Text(
                          updateOrder.processing == false ? 'Đã huỷ' : 'Huỷ',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
