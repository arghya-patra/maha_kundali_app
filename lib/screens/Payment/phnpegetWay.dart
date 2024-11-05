import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePay extends StatefulWidget {
  const PhonePay({super.key});

  @override
  State<PhonePay> createState() => _PhonePayState();
}

class _PhonePayState extends State<PhonePay> {
  int a=10;
String environment="SANDBOX";
    String appId="";
    String merchantId="PGTESTPAYUAT86";
    bool enableLogging=true;
    String checksum="";
    String saltkey="96434309-7796-489d-8924-ab56988a6076";
    String saltindex="1";
    String callbackUrl="https://webhook.site/b5fc8951-42a3-4857-be8a-fdd60dd7a79e";
    String body="";
    Object? result;
    String apiEndPoint="/pg/v1/pay";

     getCheksum(){
     final requesBody= {
        "merchantId": merchantId,
        "merchantTransactionId": "transaction_123",
        "merchantUserId": "90223250",
        "amount": 1000,
        "mobileNumber": "9999999999",
        "callbackUrl": "https://webhook.site/callback-url",
        "paymentInstrument": {
          "type": "PAY_PAGE",
         
        },
       
};

String base64body=base64.encode(utf8.encode(json.encode(requesBody)));
checksum='${sha256.convert(utf8.encode(base64body+apiEndPoint+saltkey)).toString()}###${saltindex}';
return base64body;

    }

    @override
  void initState() {
    phonePayInit();
    body=getCheksum().toString();
    super.initState();
  }

  void phonePayInit(){
    	PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void starTrunction()async{
  await  PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, "")
        .then((response) => {
              setState(() {
                if (response != null) {
                  String status = response['status'].toString();
                  String error = response['error'].toString();
                  if (status == 'SUCCESS') {
                    print('Flow complete');
                    
                  } else {
                 print("flow was not complete");  
                }
                } else {
                  // "Flow Incomplete";
                }
              })
            })
        .catchError((error) {
      // handleError(error)
      return <dynamic>{};
    });
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            starTrunction();
            },
             child: Text('Start Transcaction'))),);
  }
  
  void handleError(error) {
    setState(() {
      result={
        'error':error
      };
    });
  }
}