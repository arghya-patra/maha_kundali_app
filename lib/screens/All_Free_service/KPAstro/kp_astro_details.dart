import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KPAstrologyScreen extends StatefulWidget {
  String? name;
  String? dob;
  String? tob;
  String? pob;
  String? lat;
  String? lon;
  String? language;
  String? screen;
  String? gender;
  KPAstrologyScreen(
      {required this.name,
      required this.dob,
      required this.tob,
      required this.pob,
      required this.lat,
      required this.lon,
      required this.language,
      required this.screen,
      required this.gender});
  @override
  _KPAstrologyScreenState createState() => _KPAstrologyScreenState();
}

class _KPAstrologyScreenState extends State<KPAstrologyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? kpHouseData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
    fetchKPPlanets();
  }

  Future<void> fetchData() async {
    try {
      var data = await fetchKPHouseData();
      setState(() {
        kpHouseData = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> fetchKPPlanets() async {
    String url = APIData.login;
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'free-service-type',
        'authorizationToken': ServiceManager.tokenID,
        'type': 'kp-astrolology',
        'name': widget.name,
        'dob': widget.dob,
        'tob': widget.tob,
        'pob': widget.pob,
        'lang': widget.language == "English" ? 'en' : 'hi',
        'gender': widget.gender == "Male" ? 'm' : 'f',
        'lat': widget.lat,
        'lon': widget.lon,
        'page': 'kp-planets'
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load KP House data");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<Map<String, dynamic>> fetchKPHouseData() async {
    String url = APIData.login;
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'free-service-type',
        'authorizationToken': ServiceManager.tokenID,
        'type': 'kp-astrolology',
        'name': widget.name,
        'dob': widget.dob,
        'tob': widget.tob,
        'pob': widget.pob,
        'lang': widget.language == "English" ? 'en' : 'hi',
        'gender': widget.gender == "Male" ? 'm' : 'f',
        'lat': widget.lat,
        'lon': widget.lon,
        'page': 'kp-houses'
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load KP House data");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KP Astrology Details"),
        backgroundColor: Colors.orange,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(text: "KP House"),
            const Tab(text: "KP Planets"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isLoading ? _buildShimmerEffect() : _buildKPHouseTab(),
          _buildKPPlanetsTab(),
        ],
      ),
    );
  }

  /// KP House Tab - Displays dynamic data
  Widget _buildKPHouseTab() {
    List<dynamic> houses = kpHouseData?["content"]["response"] ?? [];
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: houses.length,
      itemBuilder: (context, index) {
        var house = houses[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.amber.shade100, Colors.amber.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "House ${house['house']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildRow("Start Rasi", house["start_rasi"]),
                  _buildRow("End Rasi", house["end_rasi"]),
                  _buildRow("End Rasi Lord", house["end_rasi_lord"]),
                  _buildRow("Bhav Madhya", house["bhavmadhya"].toString()),
                  _buildRow("Cusp Sub Lord", house["cusp_sub_lord"]),
                  _buildRow("Cusp Sub-Sub Lord", house["cusp_sub_sub_lord"]),
                  if (house["planets"].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          "Planets in House:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        for (var planet in house["planets"])
                          Text(
                            "• ${planet['full_name']} (${planet['name']})",
                            style: TextStyle(
                              color: Colors.black87.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Shimmer Effect for Loading State
  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(height: 100, margin: const EdgeInsets.all(10)),
          ),
        );
      },
    );
  }

  /// KP Planets Tab (Dummy for Now)
  Widget _buildKPPlanetsTab() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchKPPlanets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(
            child: Text(
              "Error loading KP Planets data",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          );
        }

        final planetsData =
            snapshot.data!['content']['response'] as Map<String, dynamic>;

        return ListView.builder(
          itemCount: planetsData.length - 3,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final planet = planetsData[index.toString()];

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade100, Colors.amber.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.amber.shade400,
                          child: Text(
                            planet['name'] ?? '',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              planet['full_name'] ?? '',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Zodiac: ${planet['zodiac']}",
                              style: TextStyle(
                                  color: Colors.black87.withOpacity(0.7)),
                            ),
                            Text(
                              "House: ${planet['house']}",
                              style: TextStyle(
                                  color: Colors.black87.withOpacity(0.7)),
                            ),
                            Text(
                              "Nakshatra: ${planet['pseudo_nakshatra']}",
                              style: TextStyle(
                                  color: Colors.black87.withOpacity(0.7)),
                            ),
                            Text(
                              "Sub Lord: ${planet['sub_lord']}",
                              style: TextStyle(
                                  color: Colors.black87.withOpacity(0.7)),
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
        );
      },
    );
  }

  /// Helper Method to Build Key-Value Rows
  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
