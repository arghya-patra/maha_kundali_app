import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;

class AstrologerDashboard2 extends StatefulWidget {
  @override
  State<AstrologerDashboard2> createState() => _AstrologerDashboard2State();
}

class _AstrologerDashboard2State extends State<AstrologerDashboard2> {
  Map<String, dynamic> apiResponse = {}; // API response
  @override
  void initState() {
    // _banners = [
    //   'images/banner1.png',
    //   'images/banner2.jpg',
    //   'images/banner3.jpeg',
    // ];
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'user-dashboard',
      'authorizationToken': ServiceManager.tokenID
    });
    if (response.statusCode == 200) {
      setState(() {
        apiResponse = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Astrologer Dashboard"),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search services or astrologers...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // Free Services Section
            _buildSectionHeader('Free Services'),
            _buildFreeServices(apiResponse['free_services']),

            // Top Astrologers Section
            _buildSectionHeader('Top Astrologers'),
            _buildTopAstrologers(apiResponse['home_top_astrologer']),

            // Customer Stories Section
            _buildSectionHeader('Customer Stories'),
            _buildCustomerStories(apiResponse['customer_stories']),

            // Blog Section
            _buildSectionHeader('Our Blog'),
            _buildBlogs(apiResponse['our_blog']),

            // Astro Remedies Section
            _buildSectionHeader('Astro Remedies'),
            _buildAstroRemedies(apiResponse['astro_remedy']),

            // Watch Videos Section
            _buildSectionHeader('Watch Videos'),
            _buildVideos(apiResponse['watch_video']),

            // Why Mahakundali Section
            _buildSectionHeader('Why Mahakundali'),
            _buildWhyMahakundali(apiResponse['why_mahakundali']),
          ],
        ),
      ),
    );
  }

  // Section header widget
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Free Services Horizontal Scroll
  Widget _buildFreeServices(List services) {
    return Container(
      height: 120.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildFreeServiceItem(service);
        },
      ),
    );
  }

  Widget _buildFreeServiceItem(Map<String, dynamic> service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: service['thumb'],
            height: 80.0,
            width: 80.0,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 5.0),
          Text(
            service['name'],
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  // Top Astrologers Section
  Widget _buildTopAstrologers(List astrologers) {
    return Column(
      children: List.generate(astrologers.length, (index) {
        final astrologer = astrologers[index]['Details'];
        return _buildAstrologerCard(astrologer);
      }),
    );
  }

  Widget _buildAstrologerCard(Map<String, dynamic> astrologer) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: astrologer['logo'],
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
          title: Text(astrologer['name']),
          subtitle: Text('${astrologer['experience']} Experience'),
          trailing: Column(
            children: [
              Text("Call Rate: \$${astrologer['call_rate']}"),
              Text("Chat Rate: \$${astrologer['chat_rate']}"),
            ],
          ),
        ),
      ),
    );
  }

  // Customer Stories Section
  Widget _buildCustomerStories(List stories) {
    return Column(
      children: List.generate(stories.length, (index) {
        final story = stories[index];
        return _buildCustomerStoryCard(story);
      }),
    );
  }

  Widget _buildCustomerStoryCard(Map<String, dynamic> story) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: story['pic'],
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
          title: Text(story['name']),
          subtitle: Text(story['feedback']),
          trailing: Text(story['rating']),
        ),
      ),
    );
  }

  // Blogs Section
  Widget _buildBlogs(List blogs) {
    return Column(
      children: List.generate(blogs.length, (index) {
        final blog = blogs[index];
        return _buildBlogCard(blog);
      }),
    );
  }

  Widget _buildBlogCard(Map<String, dynamic> blog) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: blog['pic'],
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
          title: Text(blog['title']),
          subtitle: Text('By ${blog['author']} - ${blog['date']}'),
        ),
      ),
    );
  }

  // Astro Remedies Section
  Widget _buildAstroRemedies(List remedies) {
    return Container(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: remedies.length,
        itemBuilder: (context, index) {
          final remedy = remedies[index];
          return _buildRemedyItem(remedy);
        },
      ),
    );
  }

  Widget _buildRemedyItem(Map<String, dynamic> remedy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: remedy['icon'],
            height: 60.0,
            width: 60.0,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 5.0),
          Text(remedy['name'], style: TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }

  // Watch Videos Section
  Widget _buildVideos(List videos) {
    return Column(
      children: List.generate(videos.length, (index) {
        final video = videos[index];
        return video['file'] != null ? _buildVideoCard(video) : SizedBox();
      }),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Text('Watch Video'),
          trailing: Icon(Icons.play_circle_fill),
          onTap: () {
            // Open video in the YouTube player
            // Navigator.push(...);
          },
        ),
      ),
    );
  }

  // Why Mahakundali Section
  Widget _buildWhyMahakundali(List reasons) {
    return Column(
      children: List.generate(reasons.length, (index) {
        final reason = reasons[index];
        return _buildWhyMahakundaliCard(reason);
      }),
    );
  }

  Widget _buildWhyMahakundaliCard(Map<String, dynamic> reason) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: reason['img'],
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
          title: Text(reason['title']),
          subtitle: Text(reason['contents']),
        ),
      ),
    );
  }
}
