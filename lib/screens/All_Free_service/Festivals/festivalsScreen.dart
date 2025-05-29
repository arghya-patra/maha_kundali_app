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
      itemCount: months.length,
      itemBuilder: (context, index) {
        final month = months[index];
        final monthFestivals =
            festivals[month]?['festivals'] as List<dynamic>? ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.deepOrange, width: 2),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    month,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: monthFestivals.map((festival) {
                return buildFestivalCard(festival);
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget buildFestivalCard(Map<String, dynamic> festival) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade100, Colors.deepOrange.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 2,
          color: Colors.deepOrange,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Image.network(
              festival['pic'] ?? '',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 50, color: Colors.red),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    festival['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        "Date: ${festival['start_date']} (${festival['day']})",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () {
                        // Open dialog with description
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Text(festival['name'] ?? 'Festival'),
                              content: SingleChildScrollView(
                                child: Text(
                                  festival['description'] ??
                                      'No description available.',
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepOrange,
                        side: const BorderSide(color: Colors.deepOrange),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Read More',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
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
