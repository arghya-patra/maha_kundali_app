import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maha_kundali_app/screens/Blog/blog_screen.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/headerText.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/my_order.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/productListScreen.dart';
import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerList.dart';
import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerProfileDetail.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Birth%20Chart/birthChartForm.dart';
import 'package:maha_kundali_app/screens/Book%20Puja/all_puja.dart';
import 'package:maha_kundali_app/screens/Favourite_Astrolgers/favAstro.dart';
import 'package:maha_kundali_app/screens/Home/walletScreen.dart';
import 'package:maha_kundali_app/screens/Horoscope/horoscopeDetails.dart';
import 'package:maha_kundali_app/screens/Horoscope/horoscopeScreen.dart';
import 'package:maha_kundali_app/screens/LiveAstrologers/liveastrologerScreen.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Numerology/numerology_form.dart';
import 'package:maha_kundali_app/screens/Personal%20Horoscope/personal_horoscope_form.dart';
import 'package:maha_kundali_app/screens/Service-Report/all_service_report.dart';
import 'package:maha_kundali_app/screens/chats/callHistory.dart';
import 'package:maha_kundali_app/screens/chats/chatListScreen.dart';
import 'package:maha_kundali_app/screens/chats/chatMessageScreen.dart';
import 'package:maha_kundali_app/screens/chats/customerSupportChat.dart';
import 'package:maha_kundali_app/screens/All_Free_service/match_Making/kundliMatching.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Kundli/kundliScreen.dart';
import 'package:maha_kundali_app/screens/All_Free_service/panchang/panchangForm.dart';
import 'package:maha_kundali_app/screens/profileContent/buyMembershipScreen.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _banners = [];
  bool showAll = false;
  List<dynamic> _astrologers = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _banners = [
      'images/banner1.png',
      'images/banner2.jpg',
      'images/banner3.jpeg',
    ];
    _fetchAstrologers();
  }

  Future<void> _fetchAstrologers() async {
    try {
      String url = APIData.login;
      print(url.toString());
      final response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-list',
        'authorizationToken': ServiceManager.tokenID
      });
      print("sss");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // If API response contains the "list" key, store it in _astrologers
        if (data['list'] != null) {
          setState(() {
            _astrologers = data['list'];
            _isLoading = false;
          });
        } else {
          print("Error: Missing 'list' key in API response");
        }
      } else {
        print("Error: Failed to fetch astrologers");
      }
    } catch (error) {
      print("Error: $error");
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
                    // IconButton(
                    //     icon: const Icon(Icons.tw), onPressed: () {}),
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
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalletScreen(),
                ),
              );
            },
            child: const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(
                  'images/wallet_icon.png'), // replace with your wallet image
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(
                  'images/notification.png'), // replace with your notification image
            ),
          ),
          const SizedBox(width: 10),
        ],
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 251, 242, 228),
              Color.fromARGB(255, 246, 206, 146),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                animatedGradientText(
                  text: 'Free Service',
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Color.fromARGB(255, 202, 121, 0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  fontSize: 28.0,
                  duration: const Duration(seconds: 3),
                ),
                const SizedBox(height: 8),
                _buildOptionsGrid(),
                const SizedBox(height: 8),
                _buildLiveAstrologerSection(context),
                _isLoading
                    ? const SizedBox(height: 140)
                    : const SizedBox(height: 8),
                // const SizedBox(height: 8),
                // _buildChatWithAstrologerSection(context),
                // const SizedBox(height: 8),
                // _buildLibraDailyHoroscope(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsGrid() {
    final List<Map<String, dynamic>> options = [
      // {
      //   'title': '2024 \nSpecial',
      //   'image': 'images/year.jpeg',
      //   'route': AllServiceReportScreen()
      // },
      {
        'title': 'Panchang',
        'image': 'images/panchang_icon.webp',
        'route': PanchangFormScreen()
      },
      {
        'title': 'Daily\nHoroscope',
        'image': 'images/daily_horoscope.png',
        'route': HoroscopeScreen()
      },
      {
        'title': 'Numerology',
        'image': 'images/zodiac.jpeg',
        'route': NumerologyFormScreen()
      },
      {
        'title': 'Kundali',
        'image': 'images/kundali.png',
        'route': KundliScreen()
      },
      {
        'title': 'Kundali \nMatching',
        'image': 'images/love_compatibility.png',
        // 'route': KundliMatchingScreen()
      },
      {
        'title': 'Personal\nHoroscope',
        'image': 'images/daily_horoscope.png',
        'route': PersonalHoroscopeFormScreen()
      },
      {
        'title': 'Birth Chart',
        'image': 'images/panchang_icon.webp',
        'route': BirthChartFormScreen()
      },
    ];
    int itemCount = showAll ? options.length : 6;

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns in the grid
            crossAxisSpacing: 5.0, // Horizontal space between the grid items
            mainAxisSpacing: 5.0, // Vertical space between the grid items
            childAspectRatio: 1.0, // Aspect ratio for each grid item
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => options[index]['route'],
                  ),
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30, // Adjust size if needed
                    backgroundImage: AssetImage(options[index]['image']!),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    options[index]['title']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 2),
        // Show All / Show Less button
        if (options.length > 5)
          TextButton(
            onPressed: () {
              setState(() {
                showAll = !showAll;
              });
            },
            child: Text(showAll ? 'Show Less' : 'Show All'),
          ),
      ],
    );
  }

  Widget _buildLiveAstrologerSection(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Our Astrologers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AstrologerListScreen(),
                    ),
                  );
                  // Handle view all navigation
                },
                child: const Text('View All',
                    style: TextStyle(color: Colors.orange)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _astrologers.length,
            itemBuilder: (context, index) {
              final astrologer = _astrologers[index];
              final details = astrologer['Details'];
              final logoUrl = details['logo'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AstrologerProfileScreen(
                        id: details['user_id'],
                      ),
                    ),
                  );
                  // Handle navigation to astrologer screen
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Colors.yellow, Colors.orange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(logoUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: 8,
                      //   left: 8,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 8, vertical: 2),
                      //     color: Colors.red,
                      //     child: const Text('Live',
                      //         style:
                      //             TextStyle(color: Colors.white, fontSize: 12)),
                      //   ),
                      // ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Text(
                          details['name'],
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget _buildChatWithAstrologerSection(BuildContext context) {
  //   final List<Map<String, String>> astrologers = [
  //     {'name': 'Astrologer 5', 'image': 'images/astro3.jpg', 'rating': '4.7'},
  //     {'name': 'Astrologer 6', 'image': 'images/astro1.jpg', 'rating': '4.8'},
  //     {'name': 'Astrologer 7', 'image': 'images/astro2.jpg', 'rating': '4.6'},
  //     {'name': 'Astrologer 8', 'image': 'images/astro3.jpg', 'rating': '4.9'},
  //   ];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text('Chat with Astrologers',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //       const SizedBox(height: 8),
  //       SizedBox(
  //         height: 150,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: astrologers.length,
  //           itemBuilder: (context, index) {
  //             return GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => ChatScreen(chatId: "1"),
  //                   ),
  //                 );
  //                 // Handle navigation to astrologer chat screen
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                 child: Stack(
  //                   children: [
  //                     Container(
  //                       width: 120,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                         color: Colors.deepOrangeAccent,
  //                         image: DecorationImage(
  //                           image: AssetImage(astrologers[index]['image']!),
  //                           fit: BoxFit.cover,
  //                         ),
  //                       ),
  //                     ),
  //                     Positioned(
  //                       top: 8,
  //                       left: 8,
  //                       child: Container(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 8, vertical: 2),
  //                         color: Colors.green,
  //                         child: const Row(
  //                           children: [
  //                             Icon(Icons.verified,
  //                                 color: Colors.white, size: 12),
  //                             SizedBox(width: 4),
  //                             Text('Online',
  //                                 style: TextStyle(
  //                                     color: Colors.white, fontSize: 12)),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Positioned(
  //                       bottom: 8,
  //                       left: 8,
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             astrologers[index]['name']!,
  //                             style: const TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           Row(
  //                             children: [
  //                               Text(astrologers[index]['rating']!,
  //                                   style:
  //                                       const TextStyle(color: Colors.white)),
  //                               const SizedBox(width: 4),
  //                               const Icon(Icons.star,
  //                                   color: Colors.yellow, size: 14),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //       Align(
  //         alignment: Alignment.centerRight,
  //         child: TextButton(
  //           onPressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ChatListScreen(),
  //               ),
  //             );
  //             // Handle view all navigation
  //           },
  //           child:
  //               const Text('View All', style: TextStyle(color: Colors.orange)),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildLibraDailyHoroscope() {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => HoroscopeDetailsScreen(
  //             zodiac: 'libra',
  //           ),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: const [
  //           BoxShadow(
  //             color: Colors.black12,
  //             blurRadius: 10,
  //             spreadRadius: 5,
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           const CircleAvatar(
  //             radius: 30,
  //             backgroundImage: AssetImage('images/libra.jpeg'),
  //             backgroundColor: Colors.transparent,
  //           ),
  //           const SizedBox(width: 16),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text('Libra Daily Horoscope',
  //                     style:
  //                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   'Today is a good day to focus on your relationships...',
  //                   style: TextStyle(color: Colors.grey[600]),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const Icon(Icons.arrow_forward_ios, color: Colors.orange),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
