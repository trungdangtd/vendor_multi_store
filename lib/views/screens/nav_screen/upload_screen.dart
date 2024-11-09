import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_multi_store/controllers/category_controller.dart';
import 'package:vendor_multi_store/controllers/product_controller.dart';
import 'package:vendor_multi_store/controllers/subcategory_controller.dart';
import 'package:vendor_multi_store/models/category.dart';
import 'package:vendor_multi_store/models/subcategory.dart';
import 'package:vendor_multi_store/provider/vendor_provider.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubCategories;
  Category? selectedCategory;
  Subcategory? selectedSubCategory;
  late String productName;
  late double productPrice;
  late int quantity;
  late String description;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategoriess();
  }

  final ImagePicker picker = ImagePicker();

  List<File> images = [];

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      // ignore: avoid_print
      print('Không chọn ảnh');
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  getSubCategoryByCategory(value) {
    futureSubCategories =
        SubcategoryController().getSubCategoriesByCategoryName(value.name);
    selectedSubCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: images.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              return index == 0
                  ? Center(
                      child: IconButton(
                        onPressed: () {
                          chooseImage();
                        },
                        icon: const Icon(Icons.add),
                      ),
                    )
                  : SizedBox(
                      height: 50,
                      width: 40,
                      child: Image.file(
                        images[index - 1],
                        fit: BoxFit.cover,
                      ),
                    );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    onChanged: (value) {
                      productName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nhập tên sản phẩm';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Nhập tên sản phẩm',
                        hintText: 'Nhập tên sản phẩm',
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    onChanged: (value) {
                      productPrice = double.parse(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nhập giá sản phẩm';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Nhập giá sản phẩm',
                        hintText: 'Nhập giá sản phẩm',
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    onChanged: (value) {
                      quantity = int.parse(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nhập số lượng sản phẩm';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Nhập số lượng sản phẩm',
                        hintText: 'Nhập số lượng sản phẩm',
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  child: FutureBuilder<List<Category>>(
                      future: futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Lỗi: ${snapshot.error}"),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("Không có danh mục nào"),
                          );
                        } else {
                          return DropdownButton<Category>(
                              value: selectedCategory,
                              hint: const Text('Chọn loại sản phẩm'),
                              items: snapshot.data!.map((Category category) {
                                return DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                                getSubCategoryByCategory(selectedCategory);
                              });
                        }
                      }),
                ),
                SizedBox(
                  width: 200,
                  child: FutureBuilder<List<Subcategory>>(
                      future: futureSubCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Lỗi: ${snapshot.error}"),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("Không có danh mục con nào"),
                          );
                        } else {
                          return DropdownButton<Subcategory>(
                              value: selectedSubCategory,
                              hint: const Text('Chọn loại sản phẩm'),
                              items:
                                  snapshot.data!.map((Subcategory subcategory) {
                                return DropdownMenuItem(
                                    value: subcategory,
                                    child: Text(subcategory.subCategoryName));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSubCategory = value;
                                });
                              });
                        }
                      }),
                ),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    onChanged: (value) {
                      description = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nhập chi tiết sản phẩm';
                      } else {
                        return null;
                      }
                    },
                    maxLines: 3,
                    maxLength: 500,
                    decoration: const InputDecoration(
                        labelText: 'Nhập chi tiết sản phẩm',
                        hintText: 'Nhập chi tiết sản phẩm',
                        border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () async {
                final fullName = ref.read(vendorProvider)!.fullname;
                final vendorId = ref.read(vendorProvider)!.id;
                if (_formKey.currentState!.validate()) {
                  _productController.uploadProduct(
                      productName: productName,
                      productPrice: productPrice,
                      quantity: quantity,
                      description: description,
                      category: selectedCategory!.name,
                      vendorId: vendorId,
                      fullName: fullName,
                      subCategory: selectedSubCategory!.subCategoryName,
                      pickedImages: images,
                      context: context);
                }
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('Đăng sản phẩm',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 1.7)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
