import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/HomeAstrologers/Upload_Product/editProduct.dart';
import 'package:maha_kundali_app/screens/HomeAstrologers/Upload_Product/productUpload.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;

class SupplierProductListScreen extends StatefulWidget {
  const SupplierProductListScreen({Key? key}) : super(key: key);

  @override
  _SupplierProductListScreenState createState() =>
      _SupplierProductListScreenState();
}

class _SupplierProductListScreenState extends State<SupplierProductListScreen> {
  List<dynamic> productList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductList();
  }

  Future<void> fetchProductList() async {
    // Simulating API call
    setState(() {
      isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-product-list',
        'authorizationToken': ServiceManager.tokenID,
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) {
          setState(() {
            productList = data['my_product'] ?? [];
            isLoading = false;
          });
        }
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

  Future<void> deleteProductFromList(id) async {
    print(id);
    setState(() {
      isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-product',
        'authorizationToken': ServiceManager.tokenID,
        'mode': 'delete',
        'product_id': id
      });
      print(['^^^^^^', response.body]);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
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

  void deleteProduct(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              deleteProductFromList(productId);
              fetchProductList();
              // setState(() {
              //   productList.removeWhere(
              //       (product) => product['product_id'] == productId);
              // });
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          )
        ],
      ),
    );
  }

  void editProduct(String productId) {
    // Handle edit product functionality
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Edit Product: $productId")),
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductEditScreen(
                id: productId,
              )
          // WalletScreen(),
          ),
    );
  }

  void addProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductUploadScreen()
          // WalletScreen(),
          ),
    );
    // Handle add product functionality
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Add Product functionality")),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supplier Product List"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: addProduct,
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(product['product_photo']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['product_title'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Category: ${product['cat_name']}",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Price: ₹${product['sale_price']}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Status: ${product['status']}",
                              style: TextStyle(
                                color: product['status'] == "Approved"
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => editProduct(product['product_id']),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () =>
                                deleteProduct(product['product_id']),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
