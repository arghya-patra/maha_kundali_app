import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class EarningsScreen extends StatefulWidget {
  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? data;
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    fetchData();
  }

  Future<void> fetchData() async {
    String url = APIData.login;
    var response = await http.post(Uri.parse(url), body: {
      'action': 'astrologer-earnings',
      'authorizationToken': ServiceManager.tokenID,
    });

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Earnings Overview'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Chat'),
            Tab(text: 'Pooja'),
            Tab(text: 'Shop'),
            Tab(
              text: 'Call',
            ),
            Tab(
              text: 'Report',
            )
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
              ? const Center(child: Text('No Data Available'))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    buildEarningsOverview(),
                    buildChatList(),
                    buildPoojaBookingList(),
                    buildProductBookingList(),
                    buildCallList(),
                    buildReportList(),
                  ],
                ),
    );
  }

  Widget buildEarningsOverview() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Earnings Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...data!['my_earning_overview'].map<Widget>((item) {
              String key = item.keys.first;
              String value = item[key]?.toString() ?? 'N/A';
              return ListTile(
                title: Text(key),
                trailing: Text(value,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget buildReportList() {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Report Earnings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              (data != null && data!['report_booking_list'].isNotEmpty)
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data!['report_booking_list'].length,
                      itemBuilder: (context, index) {
                        final report = data!['report_booking_list'][index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Icon(Icons.report, color: Colors.white),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(report['report_name'] ?? 'Anonymous'),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Date: ${report['date']}\nStatus: ${report['status']}'),
                              Text(
                                '\$${report['amount']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.download,
                                    color: Colors.black),
                                onPressed: () {
                                  _downloadFile(report['download']);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No Report earnings to display.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  /// Function to open the download URL
  void _downloadFile(String url) async {
    if (url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } else {
      debugPrint('Invalid download URL');
    }
  }

  Widget buildChatList() {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chat Earnings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data!['chat_list'].length,
                itemBuilder: (context, index) {
                  final chat = data!['chat_list'][index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.chat, color: Colors.white),
                    ),
                    title: Text(chat['customer_name'] ?? 'Anonymous'),
                    subtitle: Text(
                        'Rate: ${chat['rate_per_minutes']}/min\nDuration: ${chat['duration']} mins'),
                    trailing: Text('\$${chat['amount']}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCallList() {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Call Earnings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              (data != null && data!['call_list'].isNotEmpty)
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data!['call_list'].length,
                      itemBuilder: (context, index) {
                        final chat = data!['call_list'][index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Icon(Icons.call, color: Colors.white),
                          ),
                          title: Text(chat['customer_name'] ?? 'Anonymous'),
                          subtitle: Text(
                              'Rate: ${chat['rate_per_minutes']}/min\nDuration: ${chat['duration']} mins'),
                          trailing: Text('\$${chat['amount']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      },
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No call earnings to display.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPoojaBookingList() {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pooja Bookings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ...data!['pooja_booking_list'].map<Widget>((pooja) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    child: Icon(Icons.book, color: Colors.white),
                  ),
                  title: Text(pooja['pooja_name']),
                  subtitle: Text(
                      'Customer: ${pooja['customer_name']}\nStatus: ${pooja['status']}'),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductBookingList() {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Product Bookings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ...data!['product_booking_list'].map<Widget>((product) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                  title: Text(product['product_name']),
                  subtitle: Text(
                      'Customer: ${product['customer_name']}\nAmount: \$${product['amount']}'),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
