import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor_multi_store/global_variables.dart';
import 'package:vendor_multi_store/models/order.dart';
import 'package:vendor_multi_store/services/manage_http_response.dart';

class OrderController {
  //method to Get orders by vendorId
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/vendors/$vendorId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      //check if the response is successful
      if (response.statusCode == 200) {
        //parse the json respone body into dynamic List
        //this convert the json data into a format that can be further processed in Dart
        List<dynamic> data = jsonDecode(response.body);
        //Map the dynamic List to a List of Order objects
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();
        return orders;
      }
      {
        throw Exception('Lỗi khi tải đơn hàng');
      }
    } catch (e) {
      throw Exception('Lỗi khi tải đơn hàng: $e');
    }
  }

  //delete order by id
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpRespone(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Đã xoá đơn hàng');
          });
    } catch (e) {
      showSnackBar(context, 'Lỗi khi xoá đơn hàng: $e');
    }
  }

  Future<void> updateDeliveryStatus(
      {required String id, required context}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/delivered'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'delivered': true,
          'processing': false,
        }),
      );
      manageHttpRespone(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Đơn hàng đã được giao');
          });
    } catch (e) {
      showSnackBar(context, 'Lỗi khi cập nhật trạng thái giao hàng: $e');
    }
  }

  Future<void> cancelOrder({required String id, required context}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/processing'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'processing': false,
          'delivered': false,
        }),
      );
      manageHttpRespone(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Đơn hàng đã được xử lý');
          });
    } catch (e) {
      showSnackBar(context, 'Lỗi khi cập nhật trạng thái xử lý: $e');
    }
  }
}
