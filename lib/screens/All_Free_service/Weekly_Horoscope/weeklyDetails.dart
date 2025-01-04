import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class WeeklyHoroscopeScreen extends StatefulWidget {
  String? name;
  String? dob;
  String? language;
  WeeklyHoroscopeScreen(
      {required this.name, required this.dob, required this.language});

  @override
  _WeeklyHoroscopeScreenState createState() => _WeeklyHoroscopeScreenState();
}

class _WeeklyHoroscopeScreenState extends State<WeeklyHoroscopeScreen> {
  late var horoscopeData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    horoscopeData = fetchHoroscope();
  }

  Future<Map<String, dynamic>> fetchHoroscope() async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'free-service-type',
      'authorizationToken': ServiceManager.tokenID,
      'type': 'weekly-horoscope',
      'name': widget.dob,
      'dob': widget.dob,
      'lang': widget.language == "English" ? 'en' : 'hi'
    });
    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load horoscope data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Horoscope'),
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
        future: horoscopeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            final userDetails = data['userDetails'];
            final content = data['content'];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Center(
                    child: Column(
                      children: [
                        // CircleAvatar(
                        //   backgroundImage: NetworkImage(userDetails['logo']),
                        //   radius: 50,
                        // ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   userDetails['name'],
                        //   style: const TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        Text(
                          content['zodiac'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Horoscope Image
                  Center(
                    child: Image.network(
                      data['picture'],
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    data['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Horoscope Details
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                            'Total Score', '${content['total_score']}'),
                        _buildInfoRow('Lucky Color', content['lucky_color']),
                        _buildInfoRow(
                            'Lucky Number', content['lucky_number'].join(', ')),
                        const Divider(),
                        _buildInfoRow('Finances', '${content['finances']}%'),
                        _buildInfoRow(
                            'Relationship', '${content['relationship']}%'),
                        _buildInfoRow('Career', '${content['career']}%'),
                        _buildInfoRow('Travel', '${content['travel']}%'),
                        _buildInfoRow('Family', '${content['family']}%'),
                        _buildInfoRow('Friends', '${content['friends']}%'),
                        _buildInfoRow('Health', '${content['health']}%'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bot Response

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orangeAccent, width: 2),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Summary",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          content['bot_response'],
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const SizedBox(height: 20),
                  // Zodiac Info
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 32, vertical: 16),
                  //       backgroundColor: Colors.deepPurple,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       // Action for button
                  //     },
                  //     child: const Text(
                  //       'Know More About Leo',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
