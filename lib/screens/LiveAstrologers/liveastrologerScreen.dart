import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0), // Card border
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            // Astrologer details (Name, Experience, etc.)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Astrologer Image with Verified and Online icons
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black, width: 2.0), // Image border
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
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    const Positioned(
                      top: 0,
                      left: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.green, // Online indicator
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10.0),
                // Astrologer Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        astrologer['Details']['name'],
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Exp: ${astrologer['Details']['experience']}',
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                      ),
                      Text(
                        'Specialization: ${_getSkills(astrologer['skills'])}',
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                      ),
                      Text(
                        'Languages: ${_getLanguages(astrologer['langs'])}',
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Chat Button positioned in the top right corner
            Positioned(
              top: 0,
              right: 0,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Handle chat action
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black), // Black border
                  backgroundColor: Colors.transparent, // Transparent background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                icon: const Icon(
                  Icons.chat,
                  color: Colors.black, // Icon color
                ),
                label: const Text(
                  'Chat',
                  style: TextStyle(
                    color: Colors.black, // Text color
                  ),
                ),
              ),
            ),
          ],
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
