import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'dart:convert';

import 'package:maha_kundali_app/screens/Astro_Ecom/productDetailScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> cart = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.post(Uri.parse(APIData.login), body: {
      'action': 'shop',
      'authorizationToken': ServiceManager.tokenID,
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products =
            List<Map<String, dynamic>>.from(data['shop_product'].map((product) {
          return {
            'id': product['product_id'],
            'title': product['product_title'],
            'image': product['product_photo'],
            'price': double.parse(product['product_price']),
            'discountedPrice': double.parse(product['sale_price']),
            'rating': 4.5,
            'numRatings': 120,
            'isOffer': double.parse(product['product_price']) >
                double.parse(product['sale_price']),
            'inCart': false, // New field for cart status
          };
        }).toList());
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> toggleCartStatus(Map<String, dynamic> product) async {
    print(["@#@#@#@#@", product['id']]);
    setState(() {
      isLoading = true;
    });
    print(product['inCart']);

    final action =
        product['inCart'] ? 'delete-product-from-cart' : 'add-product-in-cart';

    final response = await http.post(Uri.parse(APIData.login), body: {
      'action': action,
      'authorizationToken': ServiceManager.tokenID,
      'product_id': product['id']
    });
    print(["*&*&", response.body]);

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        product['inCart'] = !product['inCart'];
        if (product['inCart']) {
          cart.add(product);
        } else {
          cart.removeWhere((item) => item['id'] == product['id']);
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      throw Exception('Failed to update cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = products.where((product) {
      return product['title'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Search products...",
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (query) {
            setState(() {
              searchQuery = query;
            });
          },
        ),
        // actions: [
        //   Stack(
        //     children: [
        //       IconButton(
        //         icon: const Icon(Icons.shopping_cart),
        //         onPressed: () {
        //           // Handle cart screen navigation
        //         },
        //       ),
        //       if (cart.isNotEmpty)
        //         Positioned(
        //           right: 4,
        //           top: 4,
        //           child: CircleAvatar(
        //             radius: 8,
        //             backgroundColor: Colors.red,
        //             child: Text(
        //               cart.length.toString(),
        //               style: const TextStyle(fontSize: 12, color: Colors.white),
        //             ),
        //           ),
        //         ),
        //     ],
        //   ),
        // ],
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      height: 150,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            )
          : AnimationLimiter(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 3.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  var product = filteredProducts[index];

                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  productId: product['id'],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                    color: Colors.orange, width: 2)),
                            child: Column(
                              children: [
                                Container(
                                  height: 120,
                                  padding: const EdgeInsets.all(8.0),
                                  width: double.infinity,
                                  child: Image.network(
                                    product["image"],
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 7),
                                  child: Column(
                                    children: [
                                      Text(
                                        product["title"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2, // Limit to 1 line
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "₹${product["discountedPrice"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "₹${product["price"]}",
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              product["inCart"]
                                                  ? Icons.shopping_cart
                                                  : Icons
                                                      .shopping_cart_outlined,
                                              color: product["inCart"]
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            onTap: () {
                                              toggleCartStatus(product);
                                            },
                                          )
                                          // IconButton(
                                          //   icon: Icon(
                                          //     product["inCart"]
                                          //         ? Icons.shopping_cart
                                          //         : Icons
                                          //             .shopping_cart_outlined,
                                          //     color: product["inCart"]
                                          //         ? Colors.green
                                          //         : Colors.grey,
                                          //   ),
                                          //   onPressed: () {
                                          //     toggleCartStatus(product);
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
