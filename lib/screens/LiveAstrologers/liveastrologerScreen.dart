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
      'sortby': 'live'
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
        title: Text('Astrologers'),
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No astrologers available.'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Astrologer Image with Verified and Online icons
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    astrologer['Details']['logo'],
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.green, // Online indicator
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.0),
            // Astrologer Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    astrologer['Details']['name'],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Experience: ${astrologer['Details']['experience']}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                  Text(
                    'Specialization: ${_getSkills(astrologer['skills'])}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                  Text(
                    'Languages: ${_getLanguages(astrologer['langs'])}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8.0),
                  // Chat Button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle chat action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 186, 158, 236), // Chat button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Chat'),
                    ),
                  ),
                ],
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
