import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:shimmer/shimmer.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isLoading = true;
  TextEditingController _amountController = TextEditingController();

  List<int> _autoAmounts = [200, 500, 1000, 2000];

  // Production Credentials
  String environment = "PRODUCTION"; // Changed to PRODUCTION
  String appId =
      "com.mahakundali.mahakundaliapp"; // Replace with your production App ID
  String merchantId = "M22J3NZTQPCO4"; // Replace with production Merchant ID
  String saltkey =
      "e83473f6-e21c-44ac-b7cc-1cd67d1622f4"; // Replace with production Salt Key
  String saltindex = "1"; // Replace with production Salt Index
  String callbackUrl =
      "https://www.mahakundali.com/payment-callback"; // Replace with production callback URL
  String apiEndPoint = "/pg/v1/pay";
  String checksum = "";
  String body = "";
  Object? result;

  @override
  void initState() {
    super.initState();
    phonePayInit();
    body = getChecksum().toString();
    _loadData();
  }

  void phonePayInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId,
            false) // Logging disabled in production
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
    });
  }

  String getChecksum() {
    final requestBody = {
      "merchantId": merchantId,
      "merchantTransactionId":
          "transaction_${DateTime.now().millisecondsSinceEpoch}",
      "merchantUserId": "User12345", // Replace with actual user ID if needed
      "amount": 100, // Replace with actual amount or dynamic value
      "mobileNumber": "9999999999", // Replace with actual user mobile number
      "callbackUrl": callbackUrl,
      "paymentInstrument": {
        "type": "PAY_PAGE",
      },
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestBody)));
    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltkey)).toString()}###${saltindex}';
    return base64Body;
  }

  void startTransaction() async {
    await PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, "")
        .then((response) => {
              setState(() {
                if (response != null) {
                  String status = response['status'].toString();
                  if (status == 'SUCCESS') {
                    print('Transaction Successful');
                  } else {
                    print('Transaction Failed: ${response['error']}');
                  }
                } else {
                  print("Transaction Incomplete");
                }
              })
            })
        .catchError((error) {
      handleError(error);
    });
  }

  void handleError(error) {
    setState(() {
      result = {'error': error};
    });
    print("Error: $error");
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  void _onAutoAmountSelected(int amount) {
    setState(() {
      _amountController.text = amount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? _buildShimmerEffect()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWalletBalanceSection(),
                    const SizedBox(height: 20.0),
                    _buildAutoAmountSection(),
                    const SizedBox(height: 20.0),
                    _buildAddAmountField(),
                    const SizedBox(height: 20.0),
                    _buildAddButton(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 100.0,
            color: Colors.white,
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 60.0,
            color: Colors.white,
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 50.0,
            color: Colors.white,
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 50.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildWalletBalanceSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Available Balance',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            ServiceManager.balance,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoAmountSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _autoAmounts.map((amount) {
          return GestureDetector(
            onTap: () => _onAutoAmountSelected(amount),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.orange),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '₹ $amount',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Enter Amount',
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_balance_wallet, color: Colors.white),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () {
        if (_amountController.text.isNotEmpty) {
          // print(_amountController.text.)
          startTransaction();
        } else {
          print("Please enter an amount");
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        backgroundColor: Colors.orange,
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      child: const Text(
        "Add Amount",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}











// import 'dart:convert';

// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
// import 'package:shimmer/shimmer.dart';

// class WalletScreen extends StatefulWidget {
//   @override
//   _WalletScreenState createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {
//   bool _isLoading = true;
//   TextEditingController _amountController = TextEditingController();

//   List<int> _autoAmounts = [200, 500, 1000, 2000];
//   //-------------------
//   //int a = 10;
//   String environment = "SANDBOX";
//   String appId = "";
//   String merchantId = "PGTESTPAYUAT86";
//   bool enableLogging = true;
//   String checksum = "";
//   String saltkey = "96434309-7796-489d-8924-ab56988a6076";
//   String saltindex = "1";
//   String callbackUrl =
//       "https://webhook.site/b5fc8951-42a3-4857-be8a-fdd60dd7a79e";
//   String body = "";
//   Object? result;
//   String apiEndPoint = "/pg/v1/pay";

//   getCheksum() {
//     final requesBody = {
//       "merchantId": merchantId,
//       "merchantTransactionId": "transaction_123",
//       "merchantUserId": "90223250",
//       "amount": 100,
//       "mobileNumber": "9999999999",
//       "callbackUrl": "https://webhook.site/callback-url",
//       "paymentInstrument": {
//         "type": "PAY_PAGE",
//       },
//     };

//     String base64body = base64.encode(utf8.encode(json.encode(requesBody)));
//     checksum =
//         '${sha256.convert(utf8.encode(base64body + apiEndPoint + saltkey)).toString()}###${saltindex}';
//     return base64body;
//   }

//   @override
//   void initState() {
//     phonePayInit();
//     body = getCheksum().toString();
//     super.initState();
//     _loadData();
//   }

//   void phonePayInit() {
//     PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
//         .then((val) => {
//               setState(() {
//                 result = 'PhonePe SDK Initialized - $val';
//               })
//             })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }

//   void handleError(error) {
//     setState(() {
//       result = {'error': error};
//     });
//   }

//   void starTrunction() async {
//     await PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, "")
//         .then((response) => {
//               setState(() {
//                 if (response != null) {
//                   String status = response['status'].toString();
//                   String error = response['error'].toString();
//                   if (status == 'SUCCESS') {
//                     print('Flow complete');
//                   } else {
//                     print("flow was not complete");
//                   }
//                 } else {
//                   // "Flow Incomplete";
//                 }
//               })
//             })
//         .catchError((error) {
//       // handleError(error)
//       return <dynamic>{};
//     });
//   }

//   Future<void> _loadData() async {
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _onAutoAmountSelected(int amount) {
//     setState(() {
//       _amountController.text = amount.toString();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wallet'),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.orange, Colors.deepOrange],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.orange, Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: _isLoading
//             ? _buildShimmerEffect()
//             : Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     _buildWalletBalanceSection(),
//                     const SizedBox(height: 20.0),
//                     _buildAutoAmountSection(),
//                     const SizedBox(height: 20.0),
//                     _buildAddAmountField(),
//                     const SizedBox(height: 20.0),
//                     _buildAddButton(),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildShimmerEffect() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Column(
//         children: [
//           Container(
//             height: 100.0,
//             color: Colors.white,
//           ),
//           const SizedBox(height: 20.0),
//           Container(
//             height: 60.0,
//             color: Colors.white,
//           ),
//           const SizedBox(height: 20.0),
//           Container(
//             height: 50.0,
//             color: Colors.white,
//           ),
//           const SizedBox(height: 20.0),
//           Container(
//             height: 50.0,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWalletBalanceSection() {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 3,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: const Column(
//         children: [
//           Text(
//             'Available Balance',
//             style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 10.0),
//           Text(
//             '₹ 12,500',
//             style: TextStyle(
//               fontSize: 32.0,
//               fontWeight: FontWeight.bold,
//               color: Colors.orange,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAutoAmountSection() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: _autoAmounts.map((amount) {
//           return GestureDetector(
//             onTap: () => _onAutoAmountSelected(amount),
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 8.0),
//               padding:
//                   const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30.0),
//                 border: Border.all(color: Colors.orange),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Text(
//                 '₹ $amount',
//                 style: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.orange,
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildAddAmountField() {
//     return TextField(
//       controller: _amountController,
//       keyboardType: TextInputType.number,
//       decoration: const InputDecoration(
//         labelText: 'Enter Amount',
//         labelStyle: TextStyle(color: Colors.white),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.orange),
//         ),
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.account_balance_wallet, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildAddButton() {
//     return ElevatedButton(
//         onPressed: () {
//           if (_amountController.text.isNotEmpty) {
//             starTrunction();
//           }

//           // Handle payment process
//         },
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 14.0),
//           backgroundColor: Colors.orange,
//           textStyle: const TextStyle(fontSize: 18.0),
//         ),
//         child: const Text(
//           " Add Amount",
//           style: TextStyle(
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         )
//         // AnimatedTextKit(
//         //   animatedTexts: [
//         //     WavyAnimatedText(
//         //       'Add Amount',
//         //       textStyle: const TextStyle(
//         //         fontSize: 20.0,
//         //         fontWeight: FontWeight.bold,
//         //         color: Colors.white,
//         //       ),
//         //     ),
//         //   ],
//         //   isRepeatingAnimation: true,
//         // ),
//         );
//   }
// }


