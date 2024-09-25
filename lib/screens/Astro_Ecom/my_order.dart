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
    setState(() {
      _isLoading = true;
    });
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'orderhistory',
      'authorizationToken': ServiceManager.tokenID,
    });
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load order history');
    }
  }

  Widget _buildOverviewTable() {
    if (_data == null) return Container();

    final overview = _data!['my_order_overview'] as List<dynamic>;

    return DataTable(
      columns: [
        DataColumn(label: Text('Order Type')),
        DataColumn(label: Text('Total')),
      ],
      rows: overview.map<DataRow>((item) {
        final key = item.keys.first;
        final value = item[key] ?? 'N/A';
        return DataRow(
          cells: [
            DataCell(Text(key)),
            DataCell(Text(value.toString())),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTabContent(List<dynamic> items, String type) {
    if (_isLoading) {
      return _buildShimmer();
    }

    if (items.isEmpty) {
      return Center(
          child: Text('No orders to show',
              style: TextStyle(fontSize: 18, color: Colors.grey)));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: const Color.fromARGB(255, 255, 211, 153),
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type == 'call')
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text('Call Order #${item['call_id']}',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                if (type == 'chat')
                  Row(
                    children: [
                      Icon(Icons.chat, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text('Chat with ${item['astrologer_name']}',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                if (type == 'puja')
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.purple),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text('Puja Booking #${item['booking_id']}',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                if (type == 'report')
                  Row(
                    children: [
                      Icon(Icons.report, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text('Report #${item['booking_id']}',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      IconButton(
                        icon: Icon(Icons.download, color: Colors.blue),
                        onPressed: () {
                          downloadFile(item['download']);
                        },
                      ),
                    ],
                  ),
                SizedBox(height: 8),
                Text('Date: ${item['date']}',
                    style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 4),
                if (type == 'chat' || type == 'puja')
                  Text('Amount: ${item['amount']}',
                      style: TextStyle(color: Colors.grey[600])),
                if (type == 'puja')
                  Text('Puja: ${item['puja_name']}',
                      style: TextStyle(color: Colors.grey[600])),
                if (type == 'report')
                  Text('Report: ${item['report_name'] ?? 'N/A'}',
                      style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 4),
                if (type == 'chat')
                  Text('Duration: ${item['duration']}',
                      style: TextStyle(color: Colors.grey[600])),
                if (type == 'puja')
                  Text('Astrologer: ${item['astrologer_name']}',
                      style: TextStyle(color: Colors.grey[600])),
                if (type == 'report')
                  Text('Amount: ${item['total'] ?? 'N/A'}',
                      style: TextStyle(color: Colors.grey[600])),
                if (type == 'report')
                  Text('Status: ${item['status'] ?? 'N/A'}',
                      style: TextStyle(color: Colors.grey[600])),
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
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.blueGrey,
          child: Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Overview',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                Expanded(
                  child: _buildOverviewTable(),
                ),
              ],
            ),
          ),
          Container(),
          SizedBox(
            height: 180,
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Calls'),
              Tab(text: 'Chats'),
              Tab(text: 'Puja'),
              Tab(text: 'Reports'),
            ],
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
