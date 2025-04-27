import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Book%20Puja/view_puja_details.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';

class PujaScreen extends StatefulWidget {
  @override
  _PujaScreenState createState() => _PujaScreenState();
}

class _PujaScreenState extends State<PujaScreen> {
  List pujaList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPujaList();
  }

  Future<void> fetchPujaList() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'all-puja',
      'authorizationToken': ServiceManager.tokenID,
    });
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        pujaList = data['all_puja_list'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Puja List');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Best Pooja Services'),
        centerTitle: true,
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
      body: isLoading ? _buildShimmerEffect() : _buildPujaGrid(),
    );
  }

  Widget _buildShimmerEffect() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: 8, // Placeholder item count for shimmer effect
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildPujaGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: 0.8,
      ),
      itemCount: pujaList.length,
      itemBuilder: (context, index) {
        final puja = pujaList[index];
        return _buildPujaItem(puja);
      },
    );
  }

  Widget _buildPujaItem(Map puja) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PujaDetailsScreen(name: puja['name'], id: puja['name']),
          ),
        );
      },
      child: Card(
        elevation: 6.0, // Increased for a more prominent shadow effect
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16.0), // Softer, larger corner radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Ensures central alignment
          children: [
            const SizedBox(height: 2), // Added some padding for better spacing

            // Puja Image
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(12.0), // More rounded for a softer look
              child: FadeInImage.assetNetwork(
                placeholder: 'images/placeholder.png',
                image: puja['icon'],
                height: 130, // Slightly increased height for a better visual
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Spacing between image and text
            const SizedBox(height: 2),

            // Puja Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                puja['name'],
                maxLines: 1, // Limits the text to 1 line
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight:
                      FontWeight.w600, // Medium weight for better readability
                  fontSize: 14.0, // Larger font size for better emphasis
                  color: Colors.black87, // Darker color for more visibility
                ),
              ),
            ),

            // Spacing between text and button
            const SizedBox(height: 2),

            // "Book Now" Button
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PujaDetailsScreen(
                      name: puja['name'],
                      id: puja['id'],
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color:
                      Colors.deepOrangeAccent, // Border color for the outline
                  width: 2.0, // Border width for the outline
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal:
                      10.0, // Reduced horizontal padding for a smaller button
                  vertical:
                      1.0, // Reduced vertical padding for a more compact button
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Softer button edges
                ),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 12.0, // Smaller font size for a more compact look
                  color:
                      Colors.deepOrangeAccent, // Text color to match the border
                  fontWeight: FontWeight.w500, // Slightly bold for emphasis
                ),
              ),
            ),

            const SizedBox(height: 8), // Bottom padding for a balanced layout
          ],
        ),
      ),
    );
  }
}
