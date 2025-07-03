import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Astro_remedies/orderREmedies.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class RemedyDetailsScreen extends StatefulWidget {
  final String remedyId;

  const RemedyDetailsScreen({Key? key, required this.remedyId})
      : super(key: key);

  @override
  State<RemedyDetailsScreen> createState() => _RemedyDetailsScreenState();
}

class _RemedyDetailsScreenState extends State<RemedyDetailsScreen> {
  @override
  void initState() {
    super.initState();
    fetchRemedyDetails(widget.remedyId);
  }

  Future<Map<String, dynamic>> fetchRemedyDetails(String remedyId) async {
    String url = APIData.login;
    final response = await http.post(Uri.parse(url), body: {
      'action': 'view-remedies',
      'authorizationToken': ServiceManager.tokenID,
      'name': widget.remedyId
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load remedy details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 235, 192),
      appBar: AppBar(
        title: Text(widget.remedyId),
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
        future: fetchRemedyDetails(widget.remedyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final remedyDetails = snapshot.data!['remediDetails'];
            final similarRemedies = snapshot.data!['similar_remedies_list'];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Remedy Icon and Name
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.red,
                          child: Image.network(
                            remedyDetails['icon'],
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderRemediesFormScreen()),
                              );
                              // Handle order logic
                            },
                            icon: const Icon(Icons.shopping_cart,
                                color: Colors.deepOrange),
                            label: const Text(
                              "Order Now",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              side: const BorderSide(color: Colors.deepOrange),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        remedyDetails['name'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      Text(
                        remedyDetails['short_description'],
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      //const SizedBox(height: 10),

                      // Full Description
                      _buildSectionTitle('Description:'),
                      _buildSectionContent(remedyDetails['description']),
                      //const SizedBox(height: 10),

                      // Features
                      _buildSectionTitle('Features:'),
                      _buildSectionContent(remedyDetails['features']),
                      // const SizedBox(height: 10),

                      // Activities
                      _buildSectionTitle('Activities:'),
                      _buildSectionContent(remedyDetails['activities']),
                      //const SizedBox(height: 10),

                      // Benefits
                      _buildSectionTitle('Benefits:'),
                      _buildSectionContent(remedyDetails['benefits']),
                      //const SizedBox(height: 10),

                      // Similar Remedies
                      _buildSectionTitle('Similar Remedies:'),
                      // const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: similarRemedies.length,
                        itemBuilder: (context, index) {
                          final similarRemedy = similarRemedies[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the remedy details of the similar remedy
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RemedyDetailsScreen(
                                    remedyId: similarRemedy['name'],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 8,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        similarRemedy['icon'],
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            similarRemedy['name'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          Text(
                                            similarRemedy['short_description'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
