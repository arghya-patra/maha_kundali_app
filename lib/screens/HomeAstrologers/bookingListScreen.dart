import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  Map<String, dynamic>? _bookingData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchBookingData();
  }

  Future<void> _fetchBookingData() async {
    // Replace with your actual API endpoint
    String url = APIData.login;

    try {
      var res = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-booking-list',
        'authorizationToken': ServiceManager.tokenID, //8100007581
      });
      var data = jsonDecode(res.body);
      print(["******", data]);

      if (res.statusCode == 200) {
        setState(() {
          _bookingData = json.decode(res.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(width: 50, height: 50, color: Colors.white),
            title: Container(
                width: double.infinity, height: 16, color: Colors.white),
            subtitle: Container(
                width: double.infinity, height: 16, color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildPoojaBookingList() {
    if (_bookingData == null || _bookingData!['pooja_booking_list'] == null) {
      return Center(child: Text('No Pooja Bookings found.'));
    }

    final poojaBookingList =
        _bookingData!['pooja_booking_list'] as List<dynamic>;

    return ListView.builder(
      itemCount: poojaBookingList.length,
      itemBuilder: (context, index) {
        final booking = poojaBookingList[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: Icon(Icons.book, color: Colors.deepOrange),
            title: Text(booking['pooja_name'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: ${booking['customer_name']}'),
                Text('Order Date: ${booking['order_date']}'),
                Text('Status: ${booking['status']}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductBookingList() {
    if (_bookingData == null || _bookingData!['product_booking_list'] == null) {
      return Center(child: Text('No Product Bookings found.'));
    }

    final productBookingList =
        _bookingData!['product_booking_list'] as List<dynamic>;

    return ListView.builder(
      itemCount: productBookingList.length,
      itemBuilder: (context, index) {
        final booking = productBookingList[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: Icon(Icons.shopping_bag, color: Colors.deepOrange),
            title: Text(booking['product_name'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: ${booking['customer_name']}'),
                Text('Order Date: ${booking['order_date']}'),
                Text('Status: ${booking['status']}'),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pooja Booking'),
            Tab(text: 'Product Booking'),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingShimmer()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPoojaBookingList(),
                _buildProductBookingList(),
              ],
            ),
    );
  }
}
