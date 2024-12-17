import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class PujaBookingListScreen extends StatefulWidget {
  const PujaBookingListScreen({Key? key}) : super(key: key);

  @override
  State<PujaBookingListScreen> createState() => _PujaBookingListScreenState();
}

class _PujaBookingListScreenState extends State<PujaBookingListScreen> {
  late Future<Map<String, dynamic>> _pujaBookingData;

  @override
  void initState() {
    super.initState();
    _pujaBookingData = fetchPujaBookingList();
  }

  static Future<Map<String, dynamic>> fetchPujaBookingList() async {
    String url = APIData.login;
    var response = await http.post(Uri.parse(url), body: {
      'action': 'dashboard-overview',
      'authorizationToken': ServiceManager.tokenID, //8100007581
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load puja booking list');
    }
  }

  void _handleOption(String option, Map<String, dynamic> booking) {
    switch (option) {
      case 'Accept':
        print('Accepting booking ID: ${booking['pooja_id']}');
        break;
      case 'Cancel':
        print('Cancelling booking ID: ${booking['pooja_id']}');
        break;
      case 'View':
        print('Viewing booking ID: ${booking['pooja_id']}');
        break;
      case 'Upload Proof':
        print('Uploading proof for booking ID: ${booking['pooja_id']}');
        break;
      case 'Mark Complete':
        print('Marking booking ID: ${booking['pooja_id']} as complete');
        break;
    }
  }

  List<String> _getOptions(String status) {
    switch (status.trim()) {
      case "Ordered":
        return ['Accept', 'Cancel', 'View'];
      case "In Progress":
        return ['Upload Proof', 'Mark Complete', 'View'];
      case "Complete":
        return ['View'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puja Booking List'),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _pujaBookingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final bookingList = snapshot.data!['pooja_booking_list'] as List;
            return ListView.builder(
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final booking = bookingList[index];
                final options = _getOptions(booking['status']);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      '${booking['pooja_name']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${booking['pooja_id']}'),
                        Text('Date: ${booking['order_date']}'),
                        Text('Customer: ${booking['customer_name']}'),
                        Text('Status: ${booking['status']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepOrange),
                      onPressed: () {
                        showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(200, 200, 0, 0),
                          items: options.map((option) {
                            return PopupMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                        ).then((value) {
                          if (value != null) {
                            _handleOption(value, booking);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
