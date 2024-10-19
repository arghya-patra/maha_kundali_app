import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Astro_remedies/remidies_details.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class RemediesScreen extends StatefulWidget {
  @override
  _RemediesScreenState createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  List<dynamic> remedies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRemedies();
  }

  Future<void> fetchRemedies() async {
    String url = APIData.login;
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'all-remedies',
        'authorizationToken': ServiceManager.tokenID
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          remedies = data['all_remedies_list'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load remedies');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astro Remedies'),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : remedies.isEmpty
              ? Center(child: Text('No Remedies Available'))
              : ListView.builder(
                  itemCount: remedies.length,
                  itemBuilder: (context, index) {
                    final remedy = remedies[index];
                    return buildRemedyCard(remedy);
                  },
                ),
    );
  }

  Widget buildRemedyCard(dynamic remedy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image on top with a gradient overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    remedy['icon'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay for better text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Remedy Information Section
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Remedy Title
                  Text(
                    remedy['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Remedy Description
                  Text(
                    remedy['short_description'],
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),

                  // SEO URL and Read More Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Text(
                      //   'SEO URL: ${remedy['seo_url']}',
                      //   style: const TextStyle(
                      //     color: Colors.blueAccent,
                      //     fontSize: 13,
                      //     fontStyle: FontStyle.italic,
                      //   ),
                      // ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RemedyDetailsScreen(remedyId: remedy['name']),
                            ),
                          );
                          // Action for reading more, like navigating to details
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Read More',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
