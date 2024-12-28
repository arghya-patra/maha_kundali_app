import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/HomeAstrologers/Upload_Product/productList.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class ProductUploadScreen extends StatefulWidget {
  @override
  _ProductUploadScreenState createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _productTitleController = TextEditingController();
  final TextEditingController _catIdController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productStockController = TextEditingController();
  final TextEditingController _productWeightController =
      TextEditingController();
  final TextEditingController _productSizeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _productPhoto;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  List<dynamic> _categories = [];
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    // Simulating API call
    setState(() {
      isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'shop-categories',
      });
      print(['^^^^^^', response.body]);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _categories = data['categories'];
          print(_categories[0]);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching products: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _productPhoto = File(pickedFile.path);
      });
    }
  }

  void _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _productPhoto = File(pickedFile.path);
      });
    }
  }

  void _generateProductId() {
    final productId =
        (1000 + DateTime.now().millisecondsSinceEpoch % 9000).toString();
    _productIdController.text = productId;
  }

  Future<void> _uploadProduct() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      final response = await uploadProduct(
          productId: "0",
          productTitle: _productTitleController.text,
          catId: _selectedCategoryId.toString(), // _catIdController.text,
          salePrice: _salePriceController.text,
          productPrice: _productPriceController.text,
          description: _descriptionController.text,
          productPhoto: _productPhoto,
          size: _productSizeController.text,
          weight: _productWeightController.text,
          stock: _productStockController.text);

      print(["%%%%%%", response!.body]);

      if (response != null && response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product uploaded successfully')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SupplierProductListScreen()),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload product')));
      }
    }
  }

  Future<http.Response?> uploadProduct({
    required String productId,
    required String productTitle,
    required String catId,
    required String salePrice,
    required String productPrice,
    required String description,
    required String size,
    required String weight,
    required String stock,
    required File? productPhoto,
  }) async {
    try {
      String url = APIData.login;
      var uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri);
      request.fields['action'] = 'astrologer-product';
      request.fields['authorizationToken'] = ServiceManager.tokenID;
      request.fields['mode'] = 'add';

      request.fields['product_id'] = '0';
      request.fields['product_title'] = productTitle;
      request.fields['cat_id'] = catId;
      request.fields['sale_price'] = salePrice;
      request.fields['product_price'] = productPrice;
      request.fields['description'] = description;
      request.fields['size'] = size;
      request.fields['weight'] = weight;
      request.fields['stock'] = stock;

      if (productPhoto != null) {
        var stream = http.ByteStream(productPhoto.openRead());
        var length = await productPhoto.length();
        var multipartFile = http.MultipartFile(
          'product_photo',
          stream,
          length,
          filename: productPhoto.uri.pathSegments.last,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      return http.Response.fromStream(response);
    } catch (e) {
      print('Error uploading product: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Products',
            style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: isLoading
          ? Center(child: const CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // _buildTextField(
                      //   controller: _productIdController,
                      //   label: 'Product ID',
                      //   isReadOnly: true,
                      //   suffixIcon: IconButton(
                      //     icon: const Icon(Icons.refresh),
                      //     onPressed: _generateProductId,
                      //     color: Colors.deepPurple,
                      //   ),
                      // ),
                      //  const SizedBox(height: 16),
                      _buildTextField(
                        controller: _productTitleController,
                        label: 'Product Title',
                        hint: 'Enter product title',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // Rounded corners
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Rounded corners for enabled state
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Rounded corners for focused state
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['cat_id'],
                            child: Text(category['cat_name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                            _selectedCategoryName = _categories.firstWhere(
                                (category) =>
                                    category['cat_id'] == value)['cat_name'];
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // if (_selectedCategoryId != null)
                      //   Text(
                      //     'Selected Category ID: $_selectedCategoryId\nSelected Category Name: $_selectedCategoryName',
                      //     textAlign: TextAlign.center,
                      //   ),
                      // _buildTextField(
                      //   controller: _catIdController,
                      //   label: 'Category ID',
                      //   hint: 'Enter category ID',
                      // ),
                      // const SizedBox(height: 16),
                      _buildTextField(
                        controller: _salePriceController,
                        label: 'Sale Price',
                        hint: 'Enter sale price',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _productPriceController,
                        label: 'Product Price',
                        hint: 'Enter product price',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _productStockController,
                        label: 'Stocks',
                        hint: 'Enter Stock number',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _productWeightController,
                        label: 'Weight',
                        hint: 'Enter Weight',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _productSizeController,
                        label: 'Size',
                        hint: 'Enter Size',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Enter product description',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),
                      _buildImagePicker(),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _uploadProduct,
                          child: const Text(
                            'Upload Product',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool isReadOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: suffixIcon,
      ),
      readOnly: isReadOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        _productPhoto == null
            ? Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Center(
                  child: Text(
                    'No Image Selected',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            : Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(_productPhoto!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text(
                'Pick Image',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _captureImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text(
                'Capture Image',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
