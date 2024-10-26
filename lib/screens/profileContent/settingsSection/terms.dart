import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  String? action;
  TermsAndConditionsScreen({required this.action});
  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  Future<Map<String, dynamic>>? _termsData;

  @override
  void initState() {
    super.initState();
    _termsData = fetchTermsAndConditions();
  }

  Future<Map<String, dynamic>> fetchTermsAndConditions() async {
    String url = APIData.login;
    var response = await http.post(Uri.parse(url), body: {
      'action': widget.action,
    });

    if (response.statusCode == 200) {
      print(response.body);
      // If the server returns a 200 OK response, parse the JSON.
      return json.decode(response.body);
    } else {
      // If the server returns an error response, throw an exception.
      throw Exception('Failed to load terms and conditions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Settings'),
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _termsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var terms = snapshot.data!['list'];
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    terms['title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(height: 16),
                  // terms['title'] == 'About Us'
                  //     ? Image.network(terms['img'],
                  //         height: 200, fit: BoxFit.contain)
                  //     : Container(),
                  SizedBox(height: 0),
                  Html(data: terms['contents']),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
