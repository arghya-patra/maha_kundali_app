import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class FestivalScreen extends StatefulWidget {
  const FestivalScreen({Key? key}) : super(key: key);

  @override
  _FestivalScreenState createState() => _FestivalScreenState();
}

class _FestivalScreenState extends State<FestivalScreen> {
  Map<String, dynamic>? apiResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFestivalData();
  }

  Future<void> fetchFestivalData() async {
    String url = APIData.login;
    print(url.toString());

    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'festivals',
        'authorizationToken': ServiceManager.tokenID
      });

      if (response.statusCode == 200) {
        setState(() {
          apiResponse = json.decode(response.body);
          isLoading = false;
          print(["******", apiResponse!['festivals']]);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  final List<List<Color>> monthGradients = [
    [Colors.pink.shade100, Colors.pink.shade300],
    [Colors.orange.shade100, Colors.deepOrange.shade200],
    [Colors.blue.shade100, Colors.blue.shade300],
    [Colors.green.shade100, Colors.green.shade300],
    [Colors.purple.shade100, Colors.purple.shade300],
    [Colors.teal.shade100, Colors.teal.shade300],
    [Colors.indigo.shade100, Colors.indigo.shade300],
    [Colors.amber.shade100, Colors.amber.shade300],
    [Colors.cyan.shade100, Colors.cyan.shade300],
    [Colors.red.shade100, Colors.red.shade300],
    [Colors.brown.shade100, Colors.brown.shade300],
    [Colors.deepPurple.shade100, Colors.deepPurple.shade300],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Festivals'),
        backgroundColor: Colors.amber,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : apiResponse == null
              ? const Center(child: Text('No data available'))
              : buildFestivalList(),
    );
  }

  Widget buildFestivalList() {
    final months = apiResponse?['months'] as List<dynamic>? ?? [];
    final festivals = apiResponse?['festivals'] as Map<String, dynamic>? ?? {};

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 30),
      itemCount: months.length,
      itemBuilder: (context, index) {
        final month = months[index];
        final monthFestivals =
            festivals[month]?['festivals'] as List<dynamic>? ?? [];

        final gradient = monthGradients[index % monthGradients.length];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthHeader(month),
            ...monthFestivals
                .map((festival) => buildFestivalCard(festival, gradient)),
          ],
        );
      },
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF7043), // Deep orange start
              Color.fromARGB(255, 249, 217, 168), // Orange middle
              Colors.white // Transparent end
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            const Icon(Icons.calendar_month, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              month.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFestivalCard(
      Map<String, dynamic> festival, List<Color> gradientColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradientColors.last.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    festival['name'] ?? 'Festival Name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          size: 16, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text(
                        "${festival['start_date']} (${festival['day']})",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: gradientColors.last,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text("View Details"),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => DraggableScrollableSheet(
                            expand: false,
                            builder: (context, scrollController) {
                              return SingleChildScrollView(
                                controller: scrollController,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 40,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      festival['name'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      festival['description'] ??
                                          'No description available.',
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.4,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          // Overlapping image
          Positioned(
            top: 0,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors.first.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.network(
                  festival['pic'] ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 60, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
