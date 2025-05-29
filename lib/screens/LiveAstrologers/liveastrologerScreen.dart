import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerProfileDetail.dart';
import 'dart:convert';

import 'package:maha_kundali_app/service/serviceManager.dart';

class LiveAstrologerListScreen extends StatefulWidget {
  @override
  _LiveAstrologerListScreenState createState() =>
      _LiveAstrologerListScreenState();
}

class _LiveAstrologerListScreenState extends State<LiveAstrologerListScreen> {
  Future<List<dynamic>>? astrologers;

  @override
  void initState() {
    super.initState();
    astrologers = fetchAstrologers();
  }

  Future<List<dynamic>> fetchAstrologers() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'astrologer-list',
      'authorizationToken': ServiceManager.tokenID,
      // 'sortby': 'live'
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(["*****", data['list']]);
      return data['list']; // Return list of astrologers
    } else {
      throw Exception('Failed to load astrologers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrologers'),
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
      body: FutureBuilder<List<dynamic>>(
        future: astrologers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No astrologers available.'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final astrologer = snapshot.data![index];
                return _buildAstrologerCard(astrologer);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildAstrologerCard(Map astrologer) {
    int totalRate = int.tryParse(astrologer['Details']['total_rate']) ??
        0; // Parse the rating string

    return GestureDetector(
      onDoubleTap: () {
        print("&&&^^");

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         AstrologerProfileScreen(id: astrologer['user_id']),
        //   ),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.transparent), // Transparent border
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                astrologer['Details']['logo'],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 0,
                            left: 0,
                            child: Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      // New Star Rating
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < totalRate ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
                      ),
                      Text(
                        '(${astrologer['Details']['total_review']} Reviews)',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          astrologer['Details']['name'],
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Experience: ${astrologer['Details']['experience']} years',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'Specialization: ${_getSkills(astrologer['skills'])}',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'Languages: ${_getLanguages(astrologer['langs'])}',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${astrologer['Details']['call_rate']}/min',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle chat action
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: const Color(0xFFE0F7EF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        icon: const Icon(
                          Icons.chat,
                          color: Color(0xFF07A91E),
                        ),
                        label: const Text(
                          'Chat',
                          style: TextStyle(
                            color: Color(0xFF07A91E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle call action
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: const Color(0xFFE0F7EF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        icon: const Icon(
                          Icons.phone,
                          color: Color(0xFF07A91E),
                        ),
                        label: const Text(
                          'Call',
                          style: TextStyle(
                            color: Color(0xFF07A91E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper function to format skills
  String _getSkills(List<dynamic> skills) {
    return skills.map((skill) => skill['name']).join(', ');
  }

// Helper function to format languages
  String _getLanguages(List<dynamic> langs) {
    return langs.map((lang) => lang['name']).join(', ');
  }
}
