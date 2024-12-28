import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/service/serviceManager.dart';

class AstrologerPayoutScreen extends StatefulWidget {
  @override
  _AstrologerPayoutScreenState createState() => _AstrologerPayoutScreenState();
}

class _AstrologerPayoutScreenState extends State<AstrologerPayoutScreen> {
  final TextEditingController amountController = TextEditingController();
  double availableBalance = 10005.00; // Example balance from response
  List<dynamic> transactions = []; // To hold transactions data from API

  @override
  void initState() {
    super.initState();
    fetchPayoutData(); // Simulate API call to fetch data
  }

  Future<void> fetchPayoutData() async {
    String url = APIData.login;

    try {
      var response = await http.post(Uri.parse(url), body: {
        'action': 'request-payout',
        'authorizationToken': ServiceManager.tokenID, //8100007581
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          availableBalance = double.parse(data["available_balance"]
              .replaceAll("Rs.", "")
              .replaceAll(",", ""));
          transactions = data["list"];
        });
      } else {
        // Handle non-200 responses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to fetch data: ${response.statusCode}")),
        );
      }
    } catch (error) {
      // Handle errors like network issues
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $error")),
      );
    }
  }

  void handleWithdraw() {
    final amount = double.tryParse(amountController.text) ?? 0;
    if (amount <= 0 || amount > availableBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid withdrawal amount")),
      );
    } else {
      sendWithdrawRequest(amount);
      setState(() {
        amountController.clear();
      });

      // Implement API call for withdrawal
    }
  }

  Future<void> sendWithdrawRequest(amount) async {
    String url = APIData.login;

    try {
      var response = await http.post(Uri.parse(url), body: {
        'action': 'request-widthdraw',
        'authorizationToken': ServiceManager.tokenID, //8100007581
        'amount': amount.toString()
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Withdrawal request submitted")),
        );
      } else {
        // Handle non-200 responses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to fetch data: ${response.statusCode}")),
        );
      }
    } catch (error) {
      // Handle errors like network issues
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $error")),
      );
    }
  }

  Widget buildTransactionCard(Map<String, dynamic> transaction) {
    final paymentDetails = transaction["payment_details"];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Requested Date: ${transaction["Requested Date"]}"),
            Text("Gross Amount: ${transaction["Gross Amount"]}"),
            Text("TDS: ${transaction["TDS"]}"),
            Text("Net Amount: ${transaction["Net Amount"]}"),
            Text(
                "Status: ${transaction["Status"] == "Y" ? "Paid" : "Pending"}"),
            Text("Pay Date: ${transaction["Pay Date"]}"),
            if (paymentDetails != null && paymentDetails.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              ExpansionTile(
                title: const Text("Payment Details"),
                children: [
                  Text("Date: ${paymentDetails["date"]}"),
                  Text("Remark: ${paymentDetails["remark"]}"),
                  Text("Bank: ${paymentDetails["bank"]}"),
                  Text("Transaction ID: ${paymentDetails["trans_id"]}"),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Payout"),
        centerTitle: true,
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
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blueGrey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Balance: Rs.${availableBalance.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter Amount",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: handleWithdraw,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                      ),
                      child: const Text("Withdraw"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // Transaction List
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return buildTransactionCard(transactions[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
