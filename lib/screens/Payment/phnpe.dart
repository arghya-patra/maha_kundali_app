import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/buttons.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:maha_kundali_app/theme/style.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class CheckoutScreen extends StatefulWidget {
  String? amount;
  // String? appoId;
  CheckoutScreen({super.key, this.amount});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  double _totalAmount = 1000.0; // Example total amount
  double _gst = 18.0; // GST percentage
  double _discount = 0.0;

  //static String environmentValue = "PRODUCTION"; // Change to your desired environment
  static String environmentValue = "SANDBOX"; //testing
  //static String merchantId = "M17H35LOYHQ4"; //live
  static String merchantId = "PGTESTPAYUAT"; //testing
  static String appId = "";
  //static String saltKey = "b0221ecd-6398-40ca-a3cb-103f1ecf2e47"; //live
  static String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399"; //testkey
  static bool enableLogging = false;
  //static String callback = "https://bharatvumi.com/ ";
  static String checksum = "";
  static String apiEndPoint = "/pg/v1/pay"; // Your API endpoint
  static String packageName =
      "com.example.astro_app"; //"com.example.phone_pe_demo";// "com.phonepe.simulator"; // Replace with the package name of the UPI app
  //static String packageName = "com.phonepe.app";
  static String callbackUrl =
      "https://webhook.site/d09572c0-ac0d-4b7f-9dd5-df603ec6fd5e ";

  void _applyCoupon() {
    setState(() {
      // Apply coupon logic here, for example:
      if (_couponController.text == 'DISCOUNT10') {
        // _discount = widget.amount! * 0.1; // 10% discount
      } else {
        _discount = 0.0;
      }
    });
  }

  void _pay() {
    // Start PhonePe payment process here
    // You would typically use an SDK or API provided by PhonePe for this
    print('Starting PhonePe payment process...');
  }

  @override
  void initState() {
    super.initState();

    ///PhonePe UI
    //  getCheckSum();
    initializePhonePeSDK();
    // getInstalledUpiAppsForAndroid();
    // getCODCharges();
    generateCode();

    // NotificationApi.init(initScheduled: true);
  }

  @override
  Widget build(BuildContext context) {
    // double gstAmount = _totalAmount-(_totalAmount*100)/118;//(_totalAmount - _discount) * (_gst / 100);
    String? finalAmount = (widget.amount); // - _discount) + gstAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text('Appointment Id: ${widget.appoId}',
            //     style: TextStyle(fontSize: 18)),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$${widget.amount}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(height: 32),
                    // const Text('GST (18%)', style: TextStyle(fontSize: 18)),
                    // const SizedBox(height: 4),
                    // Text('\$${gstAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    // const Divider(height: 32),
                    const Text('Discount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$${_discount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(height: 32),
                    const Text('Final Amount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$${finalAmount}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _couponController,
              decoration: InputDecoration(
                labelText: 'Enter Coupon Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon:
                    const Icon(Icons.local_offer, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _applyCoupon,
              icon:
                  const Icon(FontAwesomeIcons.checkCircle, color: Colors.white),
              label: const Text('Apply Coupon',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                    shape: bottomSheetRoundedDesign(),
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Payment Method',
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    LoginButton(
                                      title: 'Cash On Delivery',
                                      //  image: 'images/cash.png',
                                      onClick: () {
                                        checkout(
                                          context: context,
                                          paymentType: 'Cash On Delivery',
                                          paymentStatus: 'Unpaid',
                                          paymentId: '',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    LoginButton(
                                      title: 'Online Payment',
                                      // image: 'images/online.png',
                                      onClick: () {
                                        getCheckSum(100, packageName);
                                        // getWebCheckSum(grandTotal*100);

                                        // generateCode();
                                        // makePhonePePayment(context, 100);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40.0),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              },
              icon:
                  const Icon(FontAwesomeIcons.creditCard, color: Colors.white),
              label: const Text('Pay with PhonePe',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
      //-------------------
    );
  }

  String base64Body = '';

  void getCheckSum(num grandTotal, String selectedPackageName) {
    Map<String, dynamic> body = {
      "merchantId": merchantId,
      "merchantTransactionId": "MT${generatedCode}",
      "merchantUserId": "MU${ServiceManager.userID}",
      "amount": 100,
      "mobileNumber": '7003630457',
      "callbackUrl":
          "https://webhook.site/d09572c0-ac0d-4b7f-9dd5-df603ec6fd5e ", //"https://webhook.site/18b97022-5593-4007-8853-a0db128b43dc ",
      "paymentInstrument": {
        "type": "PAY_PAGE",
        //"targetApp": selectedPackageName,
      },
      // "deviceContext": {
      //   "deviceOS": "ANDROID"
      // }
    };

    print(body);

    String jsonData = jsonEncode(body);
    base64Body = base64Encode(utf8.encode(jsonData));
    String combinedData = base64Body + apiEndPoint + saltKey;
    String sha256Bytes = sha256.convert(utf8.encode(combinedData)).toString();
    setState(() {
      checksum = "$sha256Bytes###1";
    });

    startPGTransaction(selectedPackageName);
    print(base64Body);
    print(checksum);
  }

  void startPGTransaction(String selectedPackageName) {
    print('starting Payment');
    try {
      PhonePePaymentSdk.startTransaction(
              base64Body,
              callbackUrl,
              // callback,
              checksum,
              selectedPackageName)
          .then((response) => {
                print("Text phn pe"),
                print("***********"),
                print(response),
                print("*********"),
                setState(() {
                  if (response != null) {
                    String status = response['status'].toString();
                    String error = response['error'].toString();
                    if (status == 'SUCCESS') {
                      result = "Flow Completed - Status: Success!";
                    } else {
                      result =
                          "Flow Completed - Status: $status and Error: $error";
                    }
                  } else {
                    result = "Flow Incomplete";
                  }
                }),
                if ('${response!.values}' == '(SUCCESS)')
                  {
                    //  loadingPopUp(context),
                    // checkout(
                    //   context: context,
                    //   paymentType: 'PhonePe',
                    //   paymentStatus: 'Paid',
                    //   paymentId: '${response}',
                    // ),
                  },
              });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(dynamic error) {
    setState(() {
      result = 'Error: $error';
    });
  }

  Future<void> phonePeCallback(context) async {
    String merchantId = "M17H35LOYHQ4"; //live
    // String merchantId = "PGTESTPAYUAT"; //test
    const saltKey = 'b0221ecd-6398-40ca-a3cb-103f1ecf2e47'; //live
    // const saltKey = '099eb0cd-02cf-4e2a-8aca-3e6c6aff0399'; //test
    const saltIndex = 1;
    final finalXHeader =
        '${sha256.convert(utf8.encode('/pg/v1/status/$merchantId/$generatedCode$saltKey')).toString()}###$saltIndex';

    print('finalXHeader: $finalXHeader');

    final response = await http.get(
      // Uri.parse('https://api-preprod.phonepe.com/apis/merchant-simulator/pg/v1/status/$merchantId/$generatedCode' ),
      Uri.parse(
          'https://api.phonepe.com/apis/hermes/pg/v1/status/$merchantId/$generatedCode'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'X-VERIFY': finalXHeader,
        'X-MERCHANT-ID': merchantId,
        // 'X-APP-ID': '47513cc56a3e4c2e9b92bca8127133ce',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final decodedResponse = json.decode(responseBody);
      print('Status Code: ${response.statusCode}');
      print(decodedResponse);

      if (decodedResponse['code'] == 'PAYMENT_SUCCESS') {
        toastMessage(message: 'PAYMENT SUCCESS');
        // checkout(
        //   context: context,
        //   paymentType: 'PhonePe',
        //   paymentStatus: 'Paid',
        //   paymentId: '${decodedResponse['data']['transactionId']}',
        // );
      } else {
        toastMessage(message: 'PAYMENT FAILED');
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
      }
      // Handle the response data as needed.
      // flash(translate('Your order has been placed successfully. Please submit payment information from purchase history'))->success();
      // return redirect()->route('order_confirmed');
    } else {
      // Handle the error here
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    // final responseData = json.decode(response.body);
    // print(responseData);
    // Handle the response data as needed in your Flutter app.
  }

  String generatedCode = '';
  void generateCode() {
    var rng = Random();
    var code = rng.nextInt(9000) + 1000;
    setState(() {
      generatedCode = '$code';
    });
  }

  Future<void> makePhonePePayment(context, num grandTotal) async {
    // String merchantId = "M17H35LOYHQ4"; //live
    String merchantId = "PGTESTPAYUAT"; //testing
    double amount = grandTotal.toDouble(); // Set your amount here
    const url =
        'https://api-preprod.phonepe.com/apis/merchant-simulator/pg/v1/pay'; //test
    //const url = 'https://api.phonepe.com/apis/hermes/pg/v1/pay' ; //live
    //const saltKey = "b0221ecd-6398-40ca-a3cb-103f1ecf2e47"; //live
    const saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399"; //testkey
    const saltIndex = 1;

    final data = {
      'merchantId': merchantId,
      'merchantTransactionId': generatedCode,
      'merchantUserId': ServiceManager.userID,
      'amount': amount * 100,
      'redirectMode': 'POST',
      'callbackUrl': 'https://bharatvumi.com/',
      'mobileNumber': '7003630456', //ServiceManager.mobile,
      'paymentInstrument': {'type': 'PAY_PAGE'},
    };

    final encodedData = base64.encode(utf8.encode(json.encode(data)));
    final string = '$encodedData/pg/v1/pay$saltKey';
    final sha256Bytes = sha256.convert(utf8.encode(string)).toString();
    final finalXHeader = '$sha256Bytes###$saltIndex';

    print('payload : ${json.encode({'request': encodedData})}');
    print('finalXHeader : $finalXHeader');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-VERIFY': finalXHeader,
      },
      body: json.encode({'request': encodedData}),
    );

    print(response.statusCode);
    final rData = json.decode(response.body);

    if (rData.containsKey('data') &&
        rData['data'].containsKey('instrumentResponse') &&
        rData['data']['instrumentResponse'].containsKey('redirectInfo') &&
        rData['data']['instrumentResponse']['redirectInfo']
            .containsKey('url')) {
      final redirectUrl =
          rData['data']['instrumentResponse']['redirectInfo']['url'];

      _launchCustomTab(context, redirectUrl);
    } else {
      print('Invalid response structure');
    }

    // Redirect to the PhonePe payment page
    // You'll need to implement navigation logic here based on your Flutter app structure.
  }

  bool isLoading = false;

  void _launchCustomTab(context, String redirectUrl) async {
    try {
      await launch(
        redirectUrl,
        customTabsOption: CustomTabsOption(
          toolbarColor: Colors.deepPurple, // Change the toolbar color
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          // animation: CustomTabsAnimation.slideIn(),
          extraCustomTabs: const <String>[
            'org.mozilla.firefox',
            'org.mozilla.firefox_beta',
          ],
        ),
      );

      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              body: Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: containerDesign(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/app_logo.png',
                        width: MediaQuery.of(context).size.width * 0.5),
                    Text(
                      "Please don't close the app or press the back button. Check Status after the payment.",
                      textAlign: TextAlign.center,
                      style: kHeaderStyle(),
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: isLoading != true
                  ? KButton(
                      title: 'Check Status',
                      onClick: () {
                        setState(() {
                          isLoading = true;
                        });
                        phonePeCallback(context);
                      },
                    )
                  : LoadingButton(),
            );
          });
        },
      );
    } catch (e) {
      // Handle exceptions, if any
      print(e);
    }
  }

  Future<String> checkout({
    context,
    required String paymentType,
    required String paymentStatus,
    required String paymentId,
  }) async {
    String url = '${APIData.baseURL}api/checkout';
    var res = await http.post(Uri.parse(url), body: {
      'user_id': ServiceManager.userID,
      'payment_method': paymentType,
      'shipping_id': ServiceManager.addressID,
      // 'promo_code': couponCode.text,
      // 'promoDiscount': '$promoDiscount',
      // 'payment_status': paymentStatus,
      // 'totalgst': '$totalGST',
      // 'txnid': paymentId,
      // 'message': message.text,
      // 'wrapping_items': '$giftWrapList',
      // 'wrapping_price': '$wrappingPrice',
      // 'subscription_discount': subscriptionDiscount.toStringAsFixed(2),
      // 'grand_total': grandTotal.toStringAsFixed(2),
    });
    if (res.statusCode == 200) {
      print(res.body);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      //     builder: (context) => OrderSuccessfully()), (route) => false);
    } else {
      // toastMessage(message: 'Something went wrong', colors: Colors.red);
      toastMessage(message: 'Error ${res.statusCode}', colors: Colors.red);
      print(res.body);
    }
    return 'Success';
  }

  String result = "";
  void initializePhonePeSDK() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
        .then((val) {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
      });
      print(result);
    }).catchError((error) {
      print(error);
      handleError(error);
    });
  }
}
