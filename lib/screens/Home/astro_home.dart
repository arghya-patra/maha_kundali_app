// ignore_for_file: dead_code

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/my_order.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/productListScreen.dart';
import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerProfileDetail.dart';
import 'package:maha_kundali_app/screens/Birth%20Chart/birthChartForm.dart';
import 'package:maha_kundali_app/screens/Book%20Puja/all_puja.dart';
import 'package:maha_kundali_app/screens/Favourite_Astrolgers/favAstro.dart';
import 'package:maha_kundali_app/screens/Home/walletScreen.dart';
import 'package:maha_kundali_app/screens/Horoscope/horoscopeScreen.dart';
import 'package:maha_kundali_app/screens/Kundli/kundliScreen.dart';
import 'package:maha_kundali_app/screens/LiveAstrologers/liveastrologerScreen.dart';
import 'package:maha_kundali_app/screens/Numerology/numerology_form.dart';
import 'package:maha_kundali_app/screens/Personal%20Horoscope/personal_horoscope_form.dart';
import 'package:maha_kundali_app/screens/Service-Report/all_service_report.dart';
import 'package:maha_kundali_app/screens/chats/callHistory.dart';
import 'package:maha_kundali_app/screens/match_Making/kundliMatching.dart';
import 'package:maha_kundali_app/screens/panchang/panchangForm.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AstrologerDashboard extends StatefulWidget {
  @override
  _AstrologerDashboardState createState() => _AstrologerDashboardState();
}

class _AstrologerDashboardState extends State<AstrologerDashboard> {
  Map<String, dynamic> apiData = {};
  List<String> _banners = [];
  bool showAllVideos = false;

  @override
  void initState() {
    _banners = [
      'images/banner1.png',
      'images/banner2.jpg',
      'images/banner3.jpeg',
    ];
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
        apiData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ServiceManager.profileURL == 'https://mahakundali.com/'
                    ? const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('images/profile.jpeg'),
                        backgroundColor: Colors.transparent,
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(ServiceManager
                            .profileURL), // Replace with the user image asset
                      ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ServiceManager.userName,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      ServiceManager.userMobile,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  Icons.home,
                  'Home',
                ),
                _buildDrawerItem(Icons.book_online, 'Book a Puja',
                    route: PujaScreen()),
                _buildDrawerItem(Icons.report_rounded, 'Book a Report',
                    route: AllServiceReportScreen()),
                _buildDrawerItem(
                    Icons.account_balance_wallet, 'Wallet Transaction',
                    route: WalletScreen()),
                _buildDrawerItem(Icons.history, 'Order History',
                    route: OrderHistoryScreen()),
                _buildDrawerItem(Icons.chat_bubble, 'Chat with Astrologers',
                    route: LiveAstrologerListScreen()),
                _buildDrawerItem(
                    Icons.favorite_border_rounded, 'Favourite Astrologers',
                    route: FavoriteAstrologersScreen()),

                _buildDrawerItem(Icons.calendar_today, 'Daily Horoscope',
                    route: HoroscopeScreen()),

                _buildDrawerItem(Icons.chat, 'Call History',
                    route: CallListHistory()),

                // _buildDrawerItem(Icons.card_membership, 'Buy Membership',
                //     route: BuyMembershipScreen()),
                _buildDrawerItem(Icons.shopping_bag, 'Astro Products',
                    route: ShoppingScreen()),
                //_buildDrawerItem(Icons.book, 'Astro Book'),

                // _buildDrawerItem(Icons.newspaper, 'Blog',
                //     route: AstrologyBlogScreen()),
                // _buildDrawerItem(Icons.star, 'Free Services'),
                //  _buildDrawerItem(Icons.person_add, 'Sign up as Astrologer'),
                _buildDrawerItem(Icons.settings, 'Settings',
                    route: SettingsScreen()),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Also available on'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.facebook), onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.facebook), onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.linked_camera),
                        onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {route}) {
    return Container(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          if (title == 'Home') {
            Navigator.of(context).pop();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => route,
              ),
            );
          }

          // Handle navigation here
        },
      ),
    );
  }

  void _playVideo(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    if (videoId != null) {
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );

      // Show YouTube player in a dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
          );
        },
      );
    } else {
      // Handle the case when the video URL is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid video URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
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
      drawer: _buildDrawer(),
      body: apiData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Home Slider
                  const SizedBox(height: 10),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: 150.0, autoPlay: true, viewportFraction: 1.0),
                    items: _banners.map((banner) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: AssetImage(banner),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  //  buildHomeSlider(),
                  const SizedBox(height: 10),

                  // Free Services
                  buildSectionTitle('Free Services'),
                  buildFreeServices(),

                  // Top Astrologers
                  buildSectionTitle('Top Astrologers'),
                  buildTopAstrologers(),
                  const SizedBox(height: 10),

                  // Customer Stories
                  buildSectionTitle('Customer Stories'),
                  buildCustomerStories(context),
                  const SizedBox(height: 10),

                  // Blogs
                  buildSectionTitle('Our Blog'),
                  buildBlogs(context),
                  const SizedBox(height: 10),

                  // Astro Remedies
                  buildSectionTitle('Astro Remedies'),
                  buildAstroRemedies(),
                  const SizedBox(height: 10),
                  buildSectionTitle('Watch Videos'),
                  buildWatchVideos(),
                  buildWhyMahaKundali()
                  //buildWhyMahakundaliSection()
                ],
              ),
            ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildHomeSlider() {
    return apiData['home_sliders'] != null
        ? Container(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiData['home_sliders'].length,
              itemBuilder: (context, index) {
                final slider = apiData['home_sliders'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.network(
                    slider['background'],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                );
              },
            ),
          )
        : Container();
  }

  List<dynamic> routes = [
    BirthChartFormScreen(),
    KundliScreen(),
    KundliScreen(),
    KundliMatchingScreen(),
    NumerologyFormScreen(),
    PanchangFormScreen(),
    PersonalHoroscopeFormScreen(),
    PersonalHoroscopeFormScreen()
  ];
  Widget buildFreeServices() {
    return apiData['free_services'] != null
        ? Container(
            height: 130, // Slightly increased height for a balanced layout
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiData['free_services'].length,
              itemBuilder: (context, index) {
                final service = apiData['free_services'][index];
                String serviceName = service['name'];
                List<String> words = serviceName.split(' ');
                String formattedServiceName = words.length > 1
                    ? '${words[0]}\n${words.sublist(1).join(' ')}'
                    : serviceName;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => routes[index],
                        ),
                      );
                      // Action for tapping the service (optional)
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: service['thumb'], // Optional tag for animations
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape
                                  .circle, // Make the container circular
                              border: Border.all(
                                color: const Color.fromARGB(
                                    255, 255, 241, 111), // Border color
                                width: 10, // Border width
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                service['thumb'],
                                height: 50, // Height of the circular image
                                width: 50, // Width of the circular image
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedServiceName,
                          textAlign: TextAlign.center,
                          maxLines: 2, // Allow a maximum of 2 lines
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis if the text exceeds 2 lines
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black, // White text for contrast
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 2,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }

  Widget buildWatchVideos() {
    final watchVideos = apiData['watch_video'] ?? [];

    // If no videos are available, return an empty container
    if (watchVideos.isEmpty) {
      return Container();
    }

    // Determine how many videos to display based on whether "View More" is clicked
    int visibleItemCount = showAllVideos ? watchVideos.length : 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Display in 1 column
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio:
                  1.6, // Adjusted aspect ratio for a more compact card
            ),
            itemCount:
                visibleItemCount, // Show limited videos or all based on toggle
            itemBuilder: (context, index) {
              final video = watchVideos[index];
              return GestureDetector(
                onTap: () => _playVideo(video['file'] ?? ''),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize:
                        MainAxisSize.min, // Take only necessary height
                    children: [
                      // Thumbnail with reduced height
                      Container(
                        height: 180, // Adjusted height for the image container
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(video['file'] ?? '')}/0.jpg',
                            ),
                            fit: BoxFit
                                .cover, // Changed to cover for better fitting
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0), // Reduced padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Astrologer ID
                              Text(
                                'Astrologer ID: ${video['astrologer_id']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                  height: 2), // Reduced space between texts
                              // Video ID
                              Text(
                                'Video ID: ${video['id']}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // "View More" or "View Less" button
        if (watchVideos.length > 3)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showAllVideos =
                      !showAllVideos; // Toggle between showing all or limited
                });
              },
              child: Text(
                showAllVideos ? 'View Less' : 'View More',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildTopAstrologers() {
    return apiData['home_top_astrologer'] != null
        ? Container(
            height: 250, // Adjust the height to fit two astrologers vertically
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (apiData['home_top_astrologer'].length / 2).ceil(),
              itemBuilder: (context, index) {
                // We will take two astrologers per column (index * 2 and index * 2 + 1)
                final astrologer1 = apiData['home_top_astrologer'][index * 2];
                final astrologer2 =
                    index * 2 + 1 < apiData['home_top_astrologer'].length
                        ? apiData['home_top_astrologer'][index * 2 + 1]
                        : null;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      // First Astrologer in the Column
                      buildAstrologerCard(astrologer1),
                      const SizedBox(
                          height: 20), // Spacing between the two astrologers
                      // Second Astrologer in the Column (if available)
                      if (astrologer2 != null) buildAstrologerCard(astrologer2),
                    ],
                  ),
                );
              },
            ),
          )
        : Container();
  }

// Function to build each astrologer card
  Widget buildAstrologerCard(Map astrologer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AstrologerProfileScreen(
                id: astrologer['Details']['user_id'],
              ),
            ),
          );
        },
        child: Container(
          width: 300, // Adjust width for the horizontal card layout
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 8, 52, 87), // Border color
              width: 2, // Border width
            ),
            color:
                Colors.transparent, // const Color.fromARGB(255, 255, 252, 233),
            borderRadius: BorderRadius.circular(15),
            // boxShadow: const [
            //   BoxShadow(
            //     color: Colors.black12,
            //     blurRadius: 6,
            //     offset: Offset(0, 4),
            //   ),
            // ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Astrologer Image
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  astrologer['Details']['logo'],
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10), // Space between image and details

              // Astrologer Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      astrologer['Details']['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Experience: ${astrologer['Details']['experience']} years',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          '${astrologer['Details']['rating']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(), // Spacer to push chat button to the right
                        // Circular button with icon and text
                        Material(
                          color: const Color.fromARGB(255, 186, 244,
                              143), // Background color of the button
                          borderRadius: BorderRadius.circular(
                              20), // Adjusted radius for a rounded rectangle
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                20), // Match the button's shape
                            onTap: () {
                              // Implement chat functionality here
                              print(
                                  'Chat with ${astrologer['Details']['name']}');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical:
                                      6), // Adjusted padding for an oval shape
                              child: const Row(
                                mainAxisSize:
                                    MainAxisSize.min, // Adjusts to content size
                                children: [
                                  Icon(Icons.chat,
                                      color: Colors.white,
                                      size: 16), // Chat icon
                                  SizedBox(
                                      width: 4), // Space between icon and text
                                  Text(
                                    'Chat',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(
                                            255, 1, 33, 60)), // Text color
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //  const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomerStories(BuildContext context) {
    return apiData['customer_stories'] != null
        ? Container(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiData['customer_stories'].length,
              itemBuilder: (context, index) {
                final story = apiData['customer_stories'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 280, // Adjust width for card size
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 253, 255),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.blue, // Set the border color
                        width: 2, // Set the border width
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Image
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              story['pic'],
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 2), // Space between image and text
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Customer Name
                                Text(
                                  story['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 0),
                                // Customer City
                                Text(
                                  story['city'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Feedback with ellipsis
                                Text(
                                  story['feedback'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Read More button (opens popup)
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        bool showFullFeedback = false;
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    20.0), // More rounded corners
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start, // Align content to the start
                                                  children: [
                                                    // Close button at the top-right corner

                                                    const Text(
                                                      "Customer Feedback", // Title to make it more contextual
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      story['feedback'],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        height:
                                                            1.5, // Increased line height for readability
                                                        color: Colors
                                                            .black54, // Softer color for text
                                                      ),
                                                    ), // Spacing before the bottom action
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Read More",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }

  Widget buildBlogs(BuildContext context) {
    return apiData['our_blog'] != null
        ? Container(
            height: 175, // Adjust height to accommodate the "More" button
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiData['our_blog'].length,
              itemBuilder: (context, index) {
                final blog = apiData['our_blog'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 180, // Increase the width for more content space
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners for image
                          child: Image.network(
                            blog['pic'],
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            blog['title'],
                            maxLines: 2, // Limit the title to 2 lines
                            overflow:
                                TextOverflow.ellipsis, // Ellipsis for overflow
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8.0, top: 5.0),
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              onTap: () {
                                _showBlogDetails(context, blog);
                              },
                            ),
                          ],
                        ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     onPressed: () {
                        //       _showBlogDetails(context, blog);
                        //     },
                        //     child: const Text(
                        //       'More',
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         color: Colors.blue,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }

// Function to show the full blog details in a popup
  void _showBlogDetails(BuildContext context, Map<String, dynamic> blog) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding:
                const EdgeInsets.only(top: 6, left: 16, right: 16, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close icon at the top right corner
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                // Blog image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    blog['pic'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                // Blog title
                Text(
                  blog['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Blog content (assuming `content` key holds the full blog text)
                Text(
                  blog['content'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAstroRemedies() {
    return apiData['astro_remedy'] != null
        ? Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiData['astro_remedy'].length,
              itemBuilder: (context, index) {
                final remedy = apiData['astro_remedy'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 100, // Width for each remedy card
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.tealAccent.shade100,
                          Colors.blueAccent.shade100,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display the remedy icon
                        ClipOval(
                          child: Image.network(
                            remedy['icon'],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Display the remedy name with styling
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            remedy['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }

  Widget buildWhyMahaKundali() {
    final whyMahaKundali = apiData['why_mahakundali'] ?? [];
    final contents = ['3+', '1+', '35+'];
    final titles = [
      'Qualified\nAstrologers',
      'Trust By\nMillion Clients',
      'Year\nExperience'
    ];

    // If no data is available, return an empty container
    if (whyMahaKundali.isEmpty) {
      return Container();
    }

    return Container(
      color: const Color.fromARGB(255, 255, 245, 214),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header with the title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text(
              "Why Mahakundali",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Row for displaying the items with even spacing
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Distribute items evenly
            children: List.generate(whyMahaKundali.length, (index) {
              final item = whyMahaKundali[index];

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display the image
                    Image.network(
                      item['img'],
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    // Display content (like "3+")
                    Text(
                      contents[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                    ),

                    // Title text, allowing for multiple lines
                    Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      maxLines: 3, // Allows up to 3 lines
                      overflow: TextOverflow
                          .ellipsis, // Adds ellipsis if text overflows
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        color: Color.fromARGB(221, 69, 69, 69),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildWhyMahakundaliSection() {
    return apiData['why_mahakundali'] != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scroll within the column
                itemCount: apiData['why_mahakundali'].length,
                itemBuilder: (context, index) {
                  final whyMahakundaliData = apiData['why_mahakundali'][index];
                  print(whyMahakundaliData);
                  return Card(
                    child: ListTile(
                      leading: Image.network(whyMahakundaliData[index]['img'],
                          width: 50, height: 50),
                      title: Text(whyMahakundaliData[index]['title']),
                      subtitle: Text(whyMahakundaliData[index]['contents']),
                    ),
                  );
                },
              ),
            ],
          )
        : Container();
  }
}
