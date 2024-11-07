import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_multi_store/global_variables.dart';
import 'package:vendor_multi_store/models/vendor.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_multi_store/provider/vendor_provider.dart';
import 'package:vendor_multi_store/services/manage_http_response.dart';
import 'package:vendor_multi_store/views/screens/main_vendor_screen.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  Future<void> signUpVendor(
      {required String fullname,
      required String email,
      required String password,
      required context}) async {
    try {
      Vendor vendor = Vendor(
          id: '',
          fullname: fullname,
          email: email,
          state: '',
          city: '',
          locality: '',
          role: 'vendor',
          password: password);
      http.Response response = await http.post(
          Uri.parse("$uri/api/vendor/signup"),
          body: vendor
              .toJson(), //covert the vendor user object to json for the request body
          headers: <String, String>{
            "Content-Type":
                'application/json; charset=UTF-8', //specify the context type as json
          });

      manageHttpRespone(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'tài khoản Vendor đã được tạo');
          });
    } catch (e) {
      showSnackBar(context, 'Đăng ký thất bại: $e');
    }
  }

  //function to consume the backend vendor signin API
  Future<void> signInVendor(
      {required String email,
      required String password,
      required context}) async {
    try {
      http.Response response = await http.post(
          Uri.parse('$uri/api/vendor/signin'),
          body: json.encode({'email': email, 'password': password}),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });

      manageHttpRespone(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            String token = jsonDecode(response.body)['token'];

            preferences.setString('auth_token', token);

            final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);

            providerContainer
                .read(vendorProvider.notifier)
                .setVendor(vendorJson);

            await preferences.setString('vendor', vendorJson);
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return const MainVendorScreen();
            }), (route) => false);
            showSnackBar(context, 'Đăng nhập thành công');
          });
    } catch (e) {
      showSnackBar(context, 'Đăng nhập thất bại: $e');
    }
  }
}
