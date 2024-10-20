import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  // Fetch cart data from API
  Future<void> _fetchCartData() async {
    String url = APIData.login;
    print(url.toString());

    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'cart',
        'authorizationToken': ServiceManager.tokenID,
      });
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          cartItems = List<Map<String, dynamic>>.from(data['cart_list']);
          isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to load cart data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to remove item from cart
  Future<void> _removeItemFromCart(String productId) async {
    final url =
        'https://yourapiendpoint.com/cart/remove'; // Replace with your API URL
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'product_id': productId}),
      );
      if (response.statusCode == 200) {
        // If successful, remove the item locally
        setState(() {
          cartItems.removeWhere((item) => item['product_id'] == productId);
        });
      } else {
        print('Failed to remove item from cart');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Calculate total price of cart items
  double getTotalPrice() {
    return cartItems.fold(0, (total, item) {
      return total + double.parse(item['total'].replaceAll(',', ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.orange,
        centerTitle: true,
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? ListView.builder(
                    itemCount: 4, // Show shimmer effect for a few items
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            color: Colors.white,
                          ),
                          title: Container(
                            width: double.infinity,
                            height: 20,
                            color: Colors.white,
                          ),
                          subtitle: Container(
                            width: 100,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  )
                : cartItems.length <= 0
                    ? Center(
                        child: Text("Cart is Empty!"),
                      )
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Dismissible(
                            key: Key(item['product_id']),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _removeItemFromCart(item['product_id']);
                            },
                            child: Container(
                              height: 100,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset:
                                        const Offset(0, 3), // Shadow position
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3)),
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(item['product_photo'],
                                      width: 50, height: 50, fit: BoxFit.cover),
                                ),
                                title: Text(
                                  item['product_title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                  ),
                                  maxLines:
                                      2, // Limit to 2 lines to prevent overflow
                                  overflow: TextOverflow
                                      .ellipsis, // Add ellipsis if the text is too long
                                ),
                                subtitle: Text(
                                  'Price: \$${item['sale_price']}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                  maxLines:
                                      1, // Prevent price text from overflowing
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {}

                                    // => _removeItemFromCart(
                                    //     index), // Adjust this to your API call
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          cartItems.isEmpty
              ? Container()
              : Container(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // Place order action
                    },
                    child: Text(
                      'Place Order (Rs.${getTotalPrice().toStringAsFixed(2)})',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
