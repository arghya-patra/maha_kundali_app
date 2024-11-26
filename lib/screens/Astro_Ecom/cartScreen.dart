import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> cartItems = [];

  int a = 10;
  String environment = "SANDBOX";
  String appId = "";
  String merchantId = "PGTESTPAYUAT86";
  bool enableLogging = true;
  String checksum = "";
  String saltkey = "96434309-7796-489d-8924-ab56988a6076";
  String saltindex = "1";
  String callbackUrl =
      "https://webhook.site/b5fc8951-42a3-4857-be8a-fdd60dd7a79e";
  String body = "";
  Object? result;
  String apiEndPoint = "/pg/v1/pay";

  String getChecksum() {
    final requestBody = {
      "merchantId": merchantId,
      "merchantTransactionId": "transaction_123",
      "merchantUserId": "90223250",
      "amount": 1000,
      "mobileNumber": "9999999999",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {
        "type": "PAY_PAGE",
      },
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestBody)));
    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltkey)).toString()}###$saltindex';
    return base64Body;
  }

  @override
  void initState() {
    phonePayInit();
    body = getChecksum();
    super.initState();
    _fetchCartData();
  }

  void phonePayInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
      });
    }).catchError((error) {
      handleError(error);
    });
  }

  void handleError(error) {
    setState(() {
      result = {'error': error};
    });
  }

  void startTransaction() async {
    await PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, "")
        .then((response) {
      setState(() {
        if (response != null) {
          String status = response['status'].toString();
          if (status == 'SUCCESS') {
            print('Flow complete');
          } else {
            print("Flow was not complete");
          }
        }
      });
    }).catchError((error) {
      print('Transaction error: $error');
    });
  }

  Future<void> _fetchCartData() async {
    String url = APIData.login;
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'cart',
        'authorizationToken': ServiceManager.tokenID,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed Response: $data');
        if (data['cart_list'] != null && data['cart_list'] is List) {
          setState(() {
            cartItems = List<Map<String, dynamic>>.from(data['cart_list']);
            isLoading = false;
          });
        } else {
          print('cart_list is either null or not a List');
          setState(() {
            cartItems = [];
            isLoading = false;
          });
        }
      } else {
        print('Failed to load cart data. Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeItemFromCart(String productId) async {
    final url = 'https://yourapiendpoint.com/cart/remove'; // Update API URL
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'product_id': productId}),
      );
      if (response.statusCode == 200) {
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
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? ListView.builder(
                    itemCount: 4,
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
                : cartItems.isEmpty
                    ? const Center(child: Text("Cart is Empty!"))
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
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    item['product_photo'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  item['product_title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  'Price: \$${item['sale_price']}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    _removeItemFromCart(item['product_id']);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          cartItems.isEmpty
              ? const SizedBox.shrink()
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
                      startTransaction();
                    },
                    child: Text(
                      'Place Order (Rs.${getTotalPrice().toStringAsFixed(2)})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
