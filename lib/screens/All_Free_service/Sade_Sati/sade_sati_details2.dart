import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class SadeSatiScreen extends StatefulWidget {
  String? name;
  String? dob;
  String? tob;
  String? pob;
  String? lat;
  String? lon;
  String? language;
  String? gender;

  SadeSatiScreen({
    required this.name,
    required this.dob,
    required this.tob,
    required this.pob,
    required this.lat,
    required this.lon,
    required this.language,
    required this.gender,
  });

  @override
  _SadeSatiScreenState createState() => _SadeSatiScreenState();
}

class _SadeSatiScreenState extends State<SadeSatiScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> sadeSatiData = [];
  Map<String, dynamic>? currentSadeSati;
  bool isLoading = true;
  bool isCurrentLoading = true;

  @override
  void initState() {
    print("agshjgdhgd");
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchSadeSatiData();
    fetchCurrentSadeSati();
  }

  fetchSadeSatiData() async {
    String url = APIData.login;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'free-service-type',
        'authorizationToken': ServiceManager.tokenID,
        'type': 'sade-sati',
        'name': widget.name ?? "",
        'dob': widget.dob ?? "",
        'tob': widget.tob ?? "",
        'pob': widget.pob ?? "",
        'lang': widget.language == "English" ? 'en' : 'hi',
        'gender': widget.gender == "Male" ? 'm' : 'f',
        'lat': widget.lat ?? "",
        'lon': widget.lon ?? "",
        'page': 'sade-sati-table'
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('content') &&
            responseData['content'].containsKey('response') &&
            responseData['content']['response'] is List) {
          if (mounted) {
            setState(() {
              isLoading = false;
              sadeSatiData = responseData['content']['response'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
              sadeSatiData = [];
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  fetchCurrentSadeSati() async {
    String url = APIData.login;

    setState(() {
      isCurrentLoading = true;
    });

    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'free-service-type',
        'authorizationToken': ServiceManager.tokenID,
        'type': 'sade-sati',
        'name': widget.name ?? "",
        'dob': widget.dob ?? "",
        'tob': widget.tob ?? "",
        'pob': widget.pob ?? "",
        'lang': widget.language == "English" ? 'en' : 'hi',
        'gender': widget.gender == "Male" ? 'm' : 'f',
        'lat': widget.lat ?? "",
        'lon': widget.lon ?? "",
        'page': 'current-sade-sati'
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            isCurrentLoading = false;
            currentSadeSati = responseData['content']['response'] ?? {};
            print(["ssd", responseData['content']['response']]);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isCurrentLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isCurrentLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Sade Sati Details"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: "Sade Sati Table"),
            const Tab(text: "Current Sade Sati"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : sadeSatiData.isNotEmpty
                  ? ListView.builder(
                      itemCount: sadeSatiData.length,
                      itemBuilder: (context, index) {
                        var item = sadeSatiData[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Colors.amber.shade700, width: 2),
                          ),
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber.shade300,
                                  Colors.amber.shade700
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow2(
                                    Icons.star, "Zodiac", item['zodiac']),
                                _buildInfoRow2(
                                    Icons.category, "Type", item['type']),
                                _buildInfoRow2(
                                    Icons.timelapse, "Dhaiya", item['dhaiya']),
                                _buildInfoRow2(Icons.explore, "Direction",
                                    item['direction']),
                                _buildInfoRow2(Icons.calendar_today,
                                    "Start Date", item['start_date']),
                                _buildInfoRow2(
                                    Icons.event, "End Date", item['end_date']),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No Sade Sati data available."),
                    ),
          isCurrentLoading
              ? const Center(child: CircularProgressIndicator())
              : currentSadeSati != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: Colors.amber.shade700, width: 2),
                        ),
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade300,
                                Colors.amber.shade700
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow("Date Considered",
                                    currentSadeSati!['date_considered']),
                                _buildInfoRow(
                                    "Shani Period Type",
                                    currentSadeSati!['shani_period_type']
                                        .toString()),
                                _buildInfoRow("Conclusion",
                                    currentSadeSati!['bot_response']),
                                _buildInfoRow("Description",
                                    currentSadeSati!['description']),
                                _buildInfoRow(
                                    "Saturn Retrograde",
                                    currentSadeSati!['bot_response']
                                        .toString()),
                                _buildInfoRow(
                                    "Age", currentSadeSati!['age'].toString()),
                                _buildInfoRow("Remedies",
                                    currentSadeSati!['bot_response']),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: Text("No Current Sade Sati data available."),
                    ),
        ],
      ),
    );
  }

  // Helper Function for Better Readability
  Widget _buildInfoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.star, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.white),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value ?? "N/A",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow2(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.white),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value ?? "N/A",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
