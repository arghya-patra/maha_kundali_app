import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/cartScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailsScreen extends StatefulWidget {
  String productId;
  ProductDetailsScreen({super.key, required this.productId});
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  Map<String, dynamic>? productData;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int cartCount = 4;
  bool isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  Future<void> fetchProductDetails() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'view-product',
      'authorizationToken': ServiceManager.tokenID,
      'product_id': widget.productId
    });
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        productData = json.decode(response.body);
        print(["&*&*&*", productData!]);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<void> addToCart() async {
    String url = APIData.login;
    print(widget.productId);
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'add-product-in-cart',
      'authorizationToken': ServiceManager.tokenID,
      'product_id': widget.productId
    });
    var data = json.decode(response.body);
    print([response.body, "**"]);
    if (data['status'] == 200) {
      setState(() {
        print(["&*&*&*"]);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<void> removeFromCart() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'delete-product-from-cart',
      'authorizationToken': ServiceManager.tokenID,
      'product_id': widget.productId
    });
    var data = json.decode(response.body);
    print(response.body);
    if (data['status'] == 200) {
      setState(() {
        print(["&*&*&*"]);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Product Details'),
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
          // Stack(
          //   children: [
          //     IconButton(
          //       icon: const Icon(Icons.shopping_cart),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => ShoppingCartScreen()
          //               // WalletScreen(),
          //               ),
          //         );
          //       },
          //     ),
          //     //if (cart.isNotEmpty)
          //     Positioned(
          //       right: 4,
          //       top: 4,
          //       child: CircleAvatar(
          //         radius: 8,
          //         backgroundColor: Colors.white,
          //         child: Text(
          //           cartCount.toString(),
          //           style: const TextStyle(fontSize: 12, color: Colors.black),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCartScreen()
                    // WalletScreen(),
                    ),
              );
              // Navigate to the cart screen or perform any action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          isLoading ? buildShimmerEffect() : buildProductDetails(),
          buildFloatingButtons(),
        ],
      ),
    );
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            height: 200,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildProductDetails() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image.network(
            productData!['productDetails']['product_photo'],
            height: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Text(
            productData!['productDetails']['product_title'],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Price: ₹${NumberFormat('#,##0.##').format(double.parse(productData!['productDetails']['sale_price']))}',
            style: const TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
          Text(
            'Price: ₹${NumberFormat('#,##0.##').format(double.parse(productData!['productDetails']['product_price']))}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.redAccent,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            productData!['productDetails']['description']
                .replaceAll('&lt;', '<')
                .replaceAll('&gt;', '>')
                .replaceAll('&amp;', '&'),
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16),
          const Text(
            'Similar Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          buildSimilarProducts(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildSimilarProducts() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.5; // 50% of screen width
    final imageHeight = cardWidth * 0.7; // image aspect ratio

    return SizedBox(
      height: imageHeight + 120, // total height to accommodate text
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productData!['similar_product_list'].length,
        itemBuilder: (context, index) {
          var product = productData!['similar_product_list'][index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      productId: product['product_id'],
                    ),
                  ),
                );
              },
              child: Container(
                width: cardWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        product['product_photo'],
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['product_title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: screenWidth < 350 ? 13 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${NumberFormat('#,##0.##').format(double.parse(product['sale_price']))}',
                            style: TextStyle(
                              fontSize: screenWidth < 350 ? 14 : 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildFloatingButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAddedToCart = !isAddedToCart;
                    if (!isAddedToCart) {
                      removeFromCart();
                      cartCount--;
                      toastMessage(message: 'Item Removed from cart');
                    } else {
                      addToCart();
                      toastMessage(message: 'Item Added to cart');
                      cartCount++;
                    }
                  });

                  // Add to Cart action
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isAddedToCart ? "Remove from cart" : 'Add to Cart',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShoppingCartScreen()
                        // WalletScreen(),
                        ),
                  );
                  // Buy Now action
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
