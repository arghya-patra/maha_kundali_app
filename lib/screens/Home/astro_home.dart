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

class AstrologerDashboard extends StatefulWidget {
  @override
  _AstrologerDashboardState createState() => _AstrologerDashboardState();
}

class _AstrologerDashboardState extends State<AstrologerDashboard> {
  Map<String, dynamic> apiData = {};
  List<String> _banners = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrologer Dashboard'),
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
                    options: CarouselOptions(height: 150.0, autoPlay: true),
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
                  const SizedBox(height: 10),

                  // Top Astrologers
                  buildSectionTitle('Top Astrologers'),
                  buildTopAstrologers(),
                  const SizedBox(height: 10),

                  // Customer Stories
                  buildSectionTitle('Customer Stories'),
                  buildCustomerStories(),
                  const SizedBox(height: 10),

                  // Blogs
                  buildSectionTitle('Our Blog'),
                  buildBlogs(),
                  const SizedBox(height: 10),

                  // Astro Remedies
                  buildSectionTitle('Astro Remedies'),
                  buildAstroRemedies(),
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
            height: 150, // Slightly increased height for a balanced layout
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiData['free_services'].length,
              itemBuilder: (context, index) {
                final service = apiData['free_services'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade400, Colors.red.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 4), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag:
                                service['thumb'], // Optional tag for animations
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                service['thumb'],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            service['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white, // White text for contrast
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
                  ),
                );
              },
            ),
          )
        : Container();
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
                      SizedBox(
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
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 252, 233),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
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
              SizedBox(width: 10), // Space between image and details

              // Astrologer Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      astrologer['Details']['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Experience: ${astrologer['Details']['experience']} years',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 5),
                        Text(
                          '${astrologer['Details']['rating']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Call and Chat Buttons
                    // Row(
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () {},
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.blueAccent,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(20),
                    //         ),
                    //       ),
                    //       child: Text('Call'),
                    //     ),
                    //     SizedBox(width: 10),
                    //     ElevatedButton(
                    //       onPressed: () {},
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.greenAccent,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(20),
                    //         ),
                    //       ),
                    //       child: Text('Chat'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomerStories() {
    return apiData['customer_stories'] != null
        ? Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiData['customer_stories'].length,
              itemBuilder: (context, index) {
                final story = apiData['customer_stories'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      bool showFullFeedback = false;

                      return Container(
                        width: 280, // Adjust width for card size
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 236, 253, 255),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            // Add border here
                            color: Colors.blue, // Set the border color
                            width: 2, // Set the border width
                          ),
                          boxShadow: [
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
                              padding: const EdgeInsets.all(8.0),
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
                                width: 10), // Space between image and text
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
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Customer City
                                    Text(
                                      story['city'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Feedback with ellipsis
                                    Text(
                                      // showFullFeedback
                                      //     ? story['feedback']
                                      //     :
                                      story['feedback'],
                                      maxLines: showFullFeedback ? null : 3,
                                      overflow: showFullFeedback
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Read More button
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     setState(() {
                                    //       showFullFeedback = !showFullFeedback;
                                    //     });
                                    //   },
                                    //   child: Text(
                                    //     showFullFeedback
                                    //         ? "Read Less"
                                    //         : "Read More",
                                    //     style: TextStyle(
                                    //       color: Colors.blue,
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        : Container();
  }

  Widget buildBlogs() {
    return apiData['our_blog'] != null
        ? Container(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiData['our_blog'].length,
              itemBuilder: (context, index) {
                final blog = apiData['our_blog'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 120, // Set a fixed width for the blog card
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
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
                            height: 80,
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
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
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
                      boxShadow: [
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
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
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
}
