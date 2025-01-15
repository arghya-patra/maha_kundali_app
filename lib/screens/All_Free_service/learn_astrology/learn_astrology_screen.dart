import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'dart:convert';

import 'package:maha_kundali_app/service/serviceManager.dart';

class LearnAstrologyScreen extends StatefulWidget {
  @override
  _LearnAstrologyScreenState createState() => _LearnAstrologyScreenState();
}

class _LearnAstrologyScreenState extends State<LearnAstrologyScreen> {
  bool isLoading = true;
  Map<String, dynamic> astrologyData = {};

  @override
  void initState() {
    super.initState();
    fetchAstrologyData();
  }

  // Function to fetch data from API
  Future<void> fetchAstrologyData() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'learn-astrology',
      'authorizationToken': ServiceManager.tokenID
    });

    if (response.statusCode == 200) {
      setState(() {
        astrologyData = json.decode(response.body);
        print(astrologyData);
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Astrology'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading Indicator
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Categories Section
                  _buildCategoriesSection(),
                  const Divider(thickness: 1, color: Colors.grey),
                  // Courses Section
                  _buildCoursesSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: astrologyData['categories'].length,
              itemBuilder: (context, index) {
                var category = astrologyData['categories'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildCategoryItem(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build individual category item
  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.network(category['icon'], height: 60, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(
            category['cat_name'] ?? 'Category',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Courses Section
  Widget _buildCoursesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Courses Available',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          Divider(),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: astrologyData['category_wise_courses'].length,
            itemBuilder: (context, categoryIndex) {
              var categoryName = astrologyData['category_wise_courses']
                  .keys
                  .toList()[categoryIndex];
              var courses = astrologyData['category_wise_courses'][categoryName]
                  ['course'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(courses.length, (courseIndex) {
                      var course = courses[courseIndex];
                      return _buildCourseCard(course);
                    }),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Build individual course card
  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade300,
            Colors.orange.shade800
          ], // Orange gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2), // Black border
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: Colors.transparent,
        elevation:
            0, // Remove card's default shadow since we're using custom shadow
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course['name'] ?? 'Course Name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ExpansionTile(
                title: const Text(
                  'Course Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      course['description'] ?? 'No description available.',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Duration: ${course['duration']} ${course['unit']}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: ${course['rate']}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.amber,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     padding: const EdgeInsets.symmetric(vertical: 12),
              //   ),
              //   onPressed: () {
              //     // Handle course enrollment
              //   },
              //   child: const Text('Enroll Now',
              //       style: TextStyle(color: Colors.black)),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
