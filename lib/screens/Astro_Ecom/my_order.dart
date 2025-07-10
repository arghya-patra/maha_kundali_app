import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, dynamic>? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchOrderHistory();
  }

  Future<void> _fetchOrderHistory() async {
    setState(() => _isLoading = true);
    final response = await http.post(Uri.parse(APIData.login), body: {
      'action': 'orderhistory',
      'authorizationToken': ServiceManager.tokenID,
    });

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      throw Exception('Failed to load order history');
    }
  }

  Widget _buildOverviewTable() {
    if (_data == null) return Container();
    final overview = _data!['my_order_overview'] as List<dynamic>;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Overview',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          const SizedBox(height: 10),
          ...overview.map((item) {
            final key = item.keys.first;
            final value = item[key] ?? 'N/A';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(key,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  Text(value.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
            );
          }).toList()
        ],
      ),
    );
  }

  Widget _buildTabContent(List<dynamic> items, String type) {
    if (_isLoading) return _buildShimmer();

    if (items.isEmpty) {
      return const Center(
        child: Text('No orders to show',
            style: TextStyle(fontSize: 18, color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.only(bottom: 70),
      itemBuilder: (context, index) {
        final item = items[index];
        Icon icon;
        Color color;

        switch (type) {
          case 'call':
            icon = const Icon(Icons.phone, color: Colors.blue);
            break;
          case 'chat':
            icon = const Icon(Icons.chat, color: Colors.green);
            break;
          case 'puja':
            icon = const Icon(Icons.calendar_today, color: Colors.purple);
            break;
          case 'report':
            icon = const Icon(Icons.report, color: Colors.red);
            break;
          default:
            icon = const Icon(Icons.info, color: Colors.grey);
        }

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  icon,
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      type == 'call'
                          ? 'Call Order #${item['call_id']}'
                          : type == 'chat'
                              ? 'Chat with ${item['astrologer_name']}'
                              : type == 'puja'
                                  ? 'Puja Booking #${item['booking_id']}'
                                  : 'Report #${item['booking_id']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (type == 'report')
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.blue),
                      onPressed: () => downloadFile(item['download']),
                    )
                ]),
                const SizedBox(height: 10),
                Text('Date: ${item['date'] ?? ''}',
                    style: const TextStyle(color: Colors.grey)),
                if (type == 'chat' || type == 'puja')
                  Text('Amount: ${item['amount']}',
                      style: const TextStyle(color: Colors.black87)),
                if (type == 'puja')
                  Text('Puja: ${item['puja_name']}',
                      style: const TextStyle(color: Colors.black87)),
                if (type == 'report') ...[
                  Text('Report: ${item['report_name'] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.black87)),
                  Text('Amount: ${item['total'] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.black87)),
                  Text('Status: ${item['status'] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.black87)),
                ],
                if (type == 'chat')
                  Text('Duration: ${item['duration']}',
                      style: const TextStyle(color: Colors.black87)),
                if (type == 'puja')
                  Text('Astrologer: ${item['astrologer_name']}',
                      style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> downloadFile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Order History'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildOverviewTable(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black54,
              indicator: BoxDecoration(
                color: Colors.orange.shade100,
                // borderRadius: BorderRadius.circular(50),
              ),
              tabs: const [
                Tab(text: 'Calls'),
                Tab(text: 'Chats'),
                Tab(text: 'Puja'),
                Tab(text: 'Reports'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(_data?['call_list'] ?? [], 'call'),
                _buildTabContent(_data?['chat_list'] ?? [], 'chat'),
                _buildTabContent(_data?['pooja_booking_list'] ?? [], 'puja'),
                _buildTabContent(_data?['report_booking_list'] ?? [], 'report'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
