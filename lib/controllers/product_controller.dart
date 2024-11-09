import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:vendor_multi_store/global_variables.dart';
import 'package:vendor_multi_store/models/product.dart';
import 'package:vendor_multi_store/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class ProductController {
  void uploadProduct({
    required String productName,
    required double productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
    required context,
  }) async {
    if (pickedImages != null) {
      //upload images
      final cloudinary = CloudinaryPublic("dprtd493w", "fvsclpi9");
      //upload product
      List<String> images = [];
      for (var i = 0; i < pickedImages.length; i++) {
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
        );

        images.add(cloudinaryResponse.secureUrl);
      }
      if (category.isNotEmpty && subCategory.isNotEmpty) {
        final Product product = Product(
            id: '',
            productName: productName,
            productPrice: productPrice,
            quantity: quantity,
            description: description,
            category: category,
            vendorId: vendorId,
            fullName: fullName,
            subCategory: subCategory,
            images: images);
        http.Response response = await http.post(
          Uri.parse('$uri/api/add-product'),
          body: product.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        manageHttpRespone(
            response: response,
            context: context,
            onSuccess: () {
              showSnackBar(context, 'Sản phẩm đã được tải lên');
            });
      } else {
        showSnackBar(context, 'Vui lòng chọn danh mục và danh mục con');
      }
    } else {
      showSnackBar(context, 'Vui lòng chọn hình ảnh');
    }
  }
}
