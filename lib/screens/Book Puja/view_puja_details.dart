import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Book%20Puja/select_astrologer.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class PujaDetailsScreen extends StatefulWidget {
  String name;
  PujaDetailsScreen({required this.name});
  @override
  _PujaDetailsScreenState createState() => _PujaDetailsScreenState();
}

class _PujaDetailsScreenState extends State<PujaDetailsScreen>
    with SingleTickerProviderStateMixin {
  Future<Map<String, dynamic>>? _pujaDetailsFuture;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _pujaDetailsFuture = fetchPujaDetails();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeInAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  Future<Map<String, dynamic>> fetchPujaDetails() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'view-puja',
      'authorizationToken': ServiceManager.tokenID,
      'name': widget.name
    });
    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Puja details');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puja Details"),
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _pujaDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final pujaDetails = snapshot.data!['pujaDetails'];
            final similarPujaList = snapshot.data!['similar_puja_list'];

            return FadeTransition(
              opacity: _fadeInAnimation,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(pujaDetails['icon'],
                          height: 200, fit: BoxFit.cover),
                      SizedBox(height: 16),
                      Text(
                        pujaDetails['name'],
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectAstrologerListScreen(
                                pujaName: pujaDetails['name'],
                              ),
                            ),
                          );
                          // Navigate to Select Astrologer Screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Select Astrologer"),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Price: ₹${pujaDetails['price']}',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        pujaDetails['short_description'],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Description:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        pujaDetails['description'],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Benefits:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        pujaDetails['benefits'],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Similar Pujas:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: similarPujaList.length,
                          itemBuilder: (context, index) {
                            final puja = similarPujaList[index];
                            return _buildSimilarPujaItem(puja);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: Text('No Data Found'));
          }
        },
      ),
    );
  }

  // Shimmer Loading Effect
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 200, color: Colors.white),
            SizedBox(height: 16),
            Container(height: 24, color: Colors.white, width: double.infinity),
            SizedBox(height: 16),
            Container(height: 18, color: Colors.white, width: double.infinity),
            SizedBox(height: 16),
            Container(height: 18, color: Colors.white, width: double.infinity),
            SizedBox(height: 16),
            Container(height: 18, color: Colors.white, width: double.infinity),
            SizedBox(height: 24),
            Container(height: 18, color: Colors.white, width: double.infinity),
            SizedBox(height: 8),
            Container(height: 150, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // Similar Puja Item Widget
  Widget _buildSimilarPujaItem(Map<String, dynamic> puja) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(right: 16),
      child: Container(
        width: 160,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(puja['icon'], height: 100, fit: BoxFit.cover),
            SizedBox(height: 8),
            Text(
              puja['name'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            // SizedBox(height: 4),
            // Text(
            //   '₹${puja['price']}',
            //   style: TextStyle(fontSize: 14, color: Colors.green),
            // ),
            SizedBox(height: 2),
            ElevatedButton(
              onPressed: () {
                // Navigate to Puja Booking Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Book Now"),
            ),
          ],
        ),
      ),
    );
  }
}
