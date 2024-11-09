import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor_multi_store/global_variables.dart';
import 'package:vendor_multi_store/models/subcategory.dart';

class SubcategoryController {
  Future<List<Subcategory>> getSubCategoriesByCategoryName(
      String categoryName) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/category/$categoryName/subcategories'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
        }else{
          // ignore: avoid_print
          print('không tìm thấy danh mục con nào');
          return [];
        }
      }else if(response.statusCode ==404){
        // ignore: avoid_print
        print('không tìm thấy danh mục con nào');
        return [];
      }else{
        // ignore: avoid_print
        print('lỗi khi load danh mục con');
        return [];
      }
    } catch (e) {
      // ignore: avoid_print
      print('lỗi khi load danh mục con: $e');
      return [];
    }
  }
}
