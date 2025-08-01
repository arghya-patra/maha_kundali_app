// ignore_for_file: dead_code

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Festivals/festivalsScreen.dart';
import 'package:maha_kundali_app/screens/All_Free_service/KPAstro/kp_astro_form.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Lal%20Kitab/LalkitabResultScreen.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Lal%20Kitab/lalkitabForm.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Sade_Sati/sade_sati_form.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Weekly_Horoscope/weekly_horoscope_form.dart';
import 'package:maha_kundali_app/screens/All_Free_service/learn_astrology/learn_astrology_screen.dart';
import 'package:maha_kundali_app/screens/All_Free_service/match_Making/matchMakingBoy.dart';
import 'package:maha_kundali_app/screens/Astro_remedies/astroRemediesList.dart';
import 'package:maha_kundali_app/screens/Astro_remedies/remidies_details.dart';
import 'package:maha_kundali_app/screens/Authentication/login.dart';
import 'package:maha_kundali_app/screens/Blog/blog_screen.dart';
import 'dart:convert';

import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/my_order.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/productListScreen.dart';
import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerProfileDetail.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Birth%20Chart/birthChartForm.dart';
import 'package:maha_kundali_app/screens/Book%20Puja/all_puja.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Dosha/dosha_from.dart';
import 'package:maha_kundali_app/screens/Favourite_Astrolgers/favAstro.dart';
import 'package:maha_kundali_app/screens/Home/test_purpose/vdo_pl.dart';
import 'package:maha_kundali_app/screens/Home/walletScreen.dart';
import 'package:maha_kundali_app/screens/Horoscope/horoscopeScreen.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Kundli/kundliScreen.dart';
import 'package:maha_kundali_app/screens/LiveAstrologers/liveastrologerScreen.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Numerology/numerology_form.dart';
import 'package:maha_kundali_app/screens/Service-Report/all_service_report.dart';
import 'package:maha_kundali_app/screens/chats/callHistory.dart';
import 'package:maha_kundali_app/screens/All_Free_service/panchang/panchangForm.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsScreen.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsSection/contactUs.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  Map<String, dynamic> apiData = {};
  List<String> _banners = [];
  bool showAllVideos = false;
  bool _showAllAstrologers = false;
  bool _showAllStories = false;
  bool _showAllBlogs = false;
  bool _showAllRemidies = false;
  bool isLoading = false;
  String? balance = '';

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    debugPrint("Fetching user-dashboard data...");
    setState(() => isLoading = true);

    try {
      final url = APIData.login;
      final response = await http.post(Uri.parse(url), body: {
        'action': 'user-dashboard',
        'authorizationToken': ServiceManager.tokenID,
      });

      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['status'] == 201 &&
            decodedData['isSuccess'] == 'false' &&
            decodedData['error'] == "Token does not exist!") {
          ServiceManager().removeAll();
          _showLogoutPopup();
          return;
        }
        final userDetails = decodedData['userDetails'];

        // Update state with fetched data
        setState(() {
          apiData = decodedData;
          balance = userDetails['balance'].toString();
          _banners = List<String>.from(
            decodedData['home_sliders']
                .map((item) => item['background'].toString()),
          );
        });

        // Save balance to ServiceManager
        ServiceManager().setBalance(balance!);
        ServiceManager().getBalance();
      } else {
        debugPrint("Failed to load data - Status: ${response.statusCode}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint("Error in fetchData: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showLogoutPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            'Session Expired',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Your session has expired. Please login again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                ServiceManager().removeAll();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchData2() async {
    print("Fetching user dashboard...");
    setState(() => isLoading = true);

    final url = APIData.login;

    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'user-dashboard',
        'authorizationToken': ServiceManager.tokenID,
      });

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle token expiry or invalid session
        if (data['status'] == 201 &&
            data['isSuccess'] == 'false' &&
            data['error'] == "Token does not exist!") {
          ServiceManager().removeAll();
          _showLogoutPopup();
          return;
        }

        // Simulate loading delay (optional)
        await Future.delayed(const Duration(seconds: 1));

        final userDetails = data['userDetails'];
        final freeServices = data['free_services'];
        final blogItem = data['our_blog'][0];
        final sliders = data['home_sliders'];

        print("Free Services: $freeServices");
        print("Blog Item: $blogItem");

        // final balanceString = userDetails['balance'].toString();
        ServiceManager().setBalance('${apiData['userDetails']['balance']}');
        ServiceManager().getBalance();

        setState(() {
          apiData = data;
          balance = apiData['userDetails']['balance'].toString();
          ;
          _banners = sliders
              .map<String>((slider) => slider['background'].toString())
              .toList();
          isLoading = false;
        });

        print("Banners: $_banners");
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching dashboard: $e");
      toastMessage(message: 'Something went wrong!');
      setState(() => isLoading = false);
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 150.0, // Adjust the height as needed
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 40.0, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ServiceManager.profileURL == 'https://mahakundali.com/'
                          ? const CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  AssetImage('images/profile.jpeg'),
                              backgroundColor: Colors.transparent,
                            )
                          : CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  NetworkImage(ServiceManager.profileURL),
                            ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ServiceManager.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ServiceManager.userMobile,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // IconButton(
                      //   icon: const Icon(Icons.close, color: Colors.white),
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 5, // Position the wallet section at the bottom left
              //   right: 12,
              //   child: Row(
              //     children: [
              //       const Icon(
              //         Icons.account_balance_wallet_outlined,
              //         color: Colors.white,
              //         size: 29,
              //       ),
              //       const SizedBox(width: 8),
              //       Column(
              //         children: [
              //           const Text(
              //             "Balance",
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 12,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //           Text(
              //             ServiceManager
              //                 .balance, // Replace with the wallet balance variable
              //             style: const TextStyle(
              //               color: Colors.white,
              //               fontSize: 12,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  Icons.home,
                  'Home',
                ),
                _buildDrawerItem(Icons.book_online, 'Book a Pooja',
                    route: PujaScreen()),
                // _buildDrawerItem(Icons.book, 'Check Lal Kitab',
                //     route: LalKitabFormScreen()),
                _buildDrawerItem(Icons.report_rounded, 'Book a Report',
                    route: AllServiceReportScreen()),
                _buildDrawerItem(
                    Icons.account_balance_wallet, 'Wallet Transaction',
                    route: WalletScreen()),
                _buildDrawerItem(Icons.history, 'Order History',
                    route: OrderHistoryScreen()),
                _buildDrawerItem(Icons.chat_bubble, 'Chat with Astrologers',
                    route: LiveAstrologerListScreen(
                      isChat: true,
                    )),
                _buildDrawerItem(
                    Icons.favorite_border_rounded, 'Favourite Astrologers',
                    route: FavoriteAstrologersScreen()),
                _buildDrawerItem(Icons.calendar_today, 'Daily Horoscope',
                    route: HoroscopeScreen()),
                _buildDrawerItem(Icons.login, 'Sign up as Astrologer',
                    route: WebViewScreen(
                        url: 'https://mahakundali.com/astrologer-reg')),
                _buildDrawerItem(Icons.abc, 'Astro remedies',
                    route: RemediesScreen()),
                _buildDrawerItem(Icons.chat, 'Call History',
                    route: CallListHistory()),
                _buildDrawerItem(Icons.shopping_bag, 'Astro Products',
                    route: ShoppingScreen()),
                _buildDrawerItem(Icons.settings, 'My Account',
                    route: SettingsScreen()),
                _buildDrawerItem(Icons.contact_mail, 'Contact us',
                    route: ContactUsScreen()),
              ],
            ),
          ),
          // const Divider(),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Column(
          //     children: [
          //       const Text('Also available on'),
          //       const SizedBox(height: 8),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           IconButton(
          //               icon: const Icon(Icons.facebook), onPressed: () {}),
          //           IconButton(
          //               icon: const Icon(Icons.linked_camera),
          //               onPressed: () {}),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {route}) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0.0),
      dense: true,
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
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
    );
  }

//youtube player
  // void _playVideo1(String videoUrl) {
  //   print(videoUrl);
  //   final videoId = YoutubePlayer.convertUrlToId(videoUrl);

  //   if (videoId != null) {
  //     YoutubePlayerController _controller = YoutubePlayerController(
  //       initialVideoId: videoId,
  //       flags: const YoutubePlayerFlags(
  //         autoPlay: true,
  //         mute: false,
  //       ),
  //     );

  //     // Show YouTube player in a dialog
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         print("dialog");
  //         return AlertDialog(
  //           contentPadding: EdgeInsets.zero,
  //           content: YoutubePlayer(
  //             controller: _controller,
  //             showVideoProgressIndicator: true,
  //           ),
  //         );
  //       },
  //     );
  //   } else {
  //     // Handle the case when the video URL is invalid
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Invalid video URL')),
  //     );
  //   }
  // }

//video player
  void _playVideo2(String videoUrl) {
    print(videoUrl);

    // Declare the controller first
    VideoPlayerController controller = VideoPlayerController.network(
        "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4");

    // Initialize the controller and handle the video player in the dialog
    controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized
      controller.play();

      // Show video player in a dialog
      showDialog(
        context: context,
        builder: (context) {
          print("dialog");
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Stop the video when closing the dialog
                  controller.pause();
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      print("***************");
      print(error.toString());
      print("***************");
      // Handle any errors in video initialization
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading video')),
      );
    });
  }

//webview player
  void _playVideo3(BuildContext context, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => YouTubeVideoPlayer(videoUrl: videoUrl)),
    );

    // final videoId = Uri.parse(videoUrl).queryParameters['v'];

    // if (videoId != null) {
    //   // Show the video in a dialog with WebView
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         contentPadding: EdgeInsets.zero,
    //         content: SizedBox(
    //           width: double.maxFinite,
    //           height: 300, // You can set your desired height
    //           child: WebView(
    //             initialUrl: 'https://www.youtube.com/embed/$videoId',
    //             javascriptMode: JavascriptMode.unrestricted,
    //           ),
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text('Close'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // } else {
    //   // Handle invalid YouTube URL case
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Invalid YouTube URL')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Mahakundali'),
        actions: const [
          SizedBox(width: 10),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => WalletScreen()),
          //     );
          //   },
          //   child: SizedBox(
          //     width: 90,
          //     height: 40,
          //     child: Stack(
          //       children: [
          //         // Wallet Icon
          //         const Positioned(
          //           left: 0,
          //           child: Icon(
          //             Icons.account_balance_wallet_outlined,
          //             color: Colors.white,
          //             size: 45,
          //           ),
          //         ),
          //         // Rectangle Icon with Text
          //         Positioned(
          //           left: 36, // Adjust this value to overlap icons perfectly
          //           child: Stack(
          //             alignment: Alignment.center,
          //             children: [
          //               const Icon(
          //                 Icons.rectangle_outlined,
          //                 color: Colors.white,
          //                 size: 45,
          //               ),
          //               // Amount Text
          //               SizedBox(
          //                 width: 40, // Width to match the rectangle's size
          //                 child: FittedBox(
          //                   fit: BoxFit.scaleDown, // Ensures text scales to fit
          //                   child: Text(
          //                     balance!,
          //                     // "₹${apiData['userDetails']['balance'].toString()}",
          //                     style: const TextStyle(
          //                       color: Colors.black,
          //                       fontSize: 12, // Base size
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                     textAlign: TextAlign.center,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(width: 10),
        ],
      ),
      drawer: _buildDrawer(),
      body: apiData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Home Slider
                      //const SizedBox(height: 10),
                      CarouselSlider(
                        options: CarouselOptions(
                            height: 150.0,
                            autoPlay: true,
                            viewportFraction: 1.0),
                        items: _banners.map((banner) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(banner),
                                    fit: BoxFit.contain,
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
                      buildSectionTitle('Free Services', false, () {}),
                      buildFreeServices(),

                      // Top Astrologers
                      buildSectionTitle('Top Astrologers', _showAllAstrologers,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LiveAstrologerListScreen(
                              isChat: false,
                            ),
                          ),
                        );

                        // setState(() {
                        //   _showAllAstrologers =
                        //       !_showAllAstrologers; // Toggle astrologer visibility
                        // });
                      }),
                      buildTopAstrologers(),
                      const SizedBox(height: 10),

                      // Customer Stories
                      buildSectionTitle('Customer Stories', _showAllStories,
                          () {
                        setState(() {
                          _showAllStories = !_showAllStories;
                        });
                      }),
                      buildCustomerStories(context),
                      const SizedBox(height: 10),

                      // Astro Remedies
                      buildSectionTitle('Astro Remedies', _showAllRemidies, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RemediesScreen(),
                          ),
                        );
                        // setState(() {
                        //   _showAllRemidies = !_showAllRemidies;
                        // });
                      }),
                      buildAstroRemedies(),
                      const SizedBox(height: 10),
                      // Blogs
                      buildSectionTitle('Our Blog', _showAllBlogs, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogListScreen(),
                          ),
                        );

                        // setState(() {
                        //   _showAllBlogs = !_showAllBlogs;
                        // });
                      }),
                      buildBlogs(context),
                      const SizedBox(height: 10),
                      // buildSectionTitle('Watch Videos', false, () {}),
                      // buildWatchVideos(),
                      buildWhyMahaKundali(),
                      // const SizedBox(height: 20),
                      //buildWhyMahakundaliSection()
                    ],
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity, // Take full width of the screen
        padding: const EdgeInsets.symmetric(
            horizontal: 6.0, vertical: 16.0), // Add padding around the buttons
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the buttons horizontally
          children: [
            // Chat Button
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveAstrologerListScreen(
                      isChat: true,
                    ),
                  ),
                );
              },
              label: const Row(
                children: [
                  Icon(
                    Icons.chat,
                    size: 20, // Adjust icon size
                    color: Colors.black, // Match the style of the text
                  ),
                  SizedBox(width: 2), // Space between icon and text
                  Column(
                    mainAxisSize: MainAxisSize.min, // Keep the text tight
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 16, // Larger font size for "Chat"
                          fontWeight: FontWeight
                              .bold, // Highlight "Chat" with bold text
                          color: Colors.black, // Highlight color for "Chat"
                        ),
                      ),
                      Text(
                        'with astrologers',
                        style: TextStyle(
                          fontSize:
                              12, // Smaller font size for "with astrologers"
                          color: Colors
                              .black87, // Slightly muted color for secondary text
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              backgroundColor: const Color.fromARGB(255, 255, 242, 129),
              heroTag: 'chatButton', // Unique hero tag
            ),
            const SizedBox(width: 16), // Space between the two buttons
            // Call Button
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveAstrologerListScreen(
                      isChat: true,
                    ),
                  ),
                );
              },
              label: const Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 20, // Adjust icon size
                    color: Colors.black, // Match the style of the text
                  ),
                  SizedBox(width: 2), // Space between icon and text
                  Column(
                    mainAxisSize: MainAxisSize.min, // Keep the text tight
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Call',
                        style: TextStyle(
                          fontSize: 16, // Larger font size for "Call"
                          fontWeight: FontWeight
                              .bold, // Highlight "Call" with bold text
                          color: Colors.black, // Highlight color for "Call"
                        ),
                      ),
                      Text(
                        'with astrologers',
                        style: TextStyle(
                          fontSize:
                              12, // Smaller font size for "with astrologers"
                          color: Colors
                              .black87, // Slightly muted color for secondary text
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              backgroundColor: const Color.fromARGB(255, 255, 242, 129),
              heroTag: 'callButton', // Unique hero tag
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title, bool showAll, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          title == "Watch Videos" || title == "Free Services"
              ? Container()
              : GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    showAll
                        ? 'View Less'
                        : 'View All', // Change text based on the state
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
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
    HoroscopeScreen(),
    BirthChartFormScreen(),
    KundliScreen(),
    NumerologyFormScreen(),
    MatchmakingBoy(),
    DoshaFormScreen(),
    PanchangFormScreen(),
    AllServiceReportScreen(),
    ShoppingScreen(),
    LalKitabFormScreen(),
    LearnAstrologyScreen(),
    const FestivalScreen(),
    KpAstroForm(),
    SateSatiForm(
      isDasha: false,
    ),
    const FestivalScreen(),
    const FestivalScreen(),
    const FestivalScreen(),

    // BirthChartFormScreen(),

    //KundliMatchingScreen(),
    // PersonalHoroscopeFormScreen(),
    //WeeklyHorosFormScreen()
  ];
  Widget buildFreeServices() {
    return apiData['free_services'] != null
        ? Container(
            padding: const EdgeInsets.all(0.0),
            //height: 360, // Adjust height as per your design
            child: GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Disable GridView scrolling
              shrinkWrap: true,
              itemCount: apiData['free_services'].length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of items in a row
                crossAxisSpacing: 10, // Horizontal spacing between grid items
                mainAxisSpacing: 0, // Vertical spacing between grid items
                childAspectRatio: 1.1, // Adjust this for layout balance
              ),
              itemBuilder: (context, index) {
                // if (index == 6) return const SizedBox.shrink();
                final service = apiData['free_services'][index];
                String serviceName = service['name'];
                List<String> words = serviceName.split(' ');
                String formattedServiceName = words.length > 1
                    ? '${words[0]} ${words.sublist(1).join(' ')}'
                    : serviceName;
                return GestureDetector(
                  onTap: () {
                    print(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            routes[index], //== 7 ? index - 1 : index],
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: service['thumb'], // Optional tag for animations
                        child: Container(
                          decoration: BoxDecoration(
                            shape:
                                BoxShape.circle, // Make the container circular
                            border: Border.all(
                              color: Colors.amber, // Border color
                              width: 4, // Border width
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              service['thumb'],
                              height: 60, // Height of the circular image
                              width: 60, // Width of the circular image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formattedServiceName.startsWith("Personal")
                            ? "Horoscope"
                            : formattedServiceName,
                        textAlign: TextAlign.center,
                        maxLines: 2, // Allow a maximum of 2 lines
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
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
    int visibleItemCount = showAllVideos ? watchVideos.length : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10.0, right: 8),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Display in 1 column
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio:
                  1.55, // Adjusted aspect ratio for a more compact card
            ),
            itemCount:
                visibleItemCount, // Show limited videos or all based on toggle
            itemBuilder: (context, index) {
              final video = watchVideos[index];
              return GestureDetector(
                onTap: () => _playVideo2(video['file'] ?? ''),
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
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://mahakundali.com/uploads/site_background/1721502023_0.png', //  'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(video['file'] ?? '')}/0.jpg',
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
                                'Astrologer Name: ${video['astrologer_name']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  color: Colors.black87,
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
        ? SizedBox(
            height: 140, // Adjusted height to fit astrologer cards
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _showAllAstrologers
                  ? apiData['home_top_astrologer'].length
                  : 4, // Show only 4 astrologers initially
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final astrologer = apiData['home_top_astrologer'][index];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: buildAstrologerCard(astrologer),
                );
              },
            ),
          )
        : Container();
  }

// Function to build each astrologer card
  Widget buildAstrologerCard(Map astrologer) {
    return GestureDetector(
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
        width: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Astrologer Image with Green Dot
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(astrologer['Details']['logo']),
                ),
                if (astrologer['Details']['is_live'] == "Yes")
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Astrologer Name
            Text(
              astrologer['Details']['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(String rating) {
    // Convert the string rating to an integer
    int rateValue = int.tryParse(rating) ?? 0; // Default to 0 if parsing fails
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          i <= rateValue ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        ),
      );
    }
    return Row(
      children: stars,
    );
  }

  Widget buildCustomerStories(BuildContext context) {
    // Determine how many customer stories to show (4 initially, or all if "View All" is clicked)
    int storiesCount = _showAllStories ? apiData['customer_stories'].length : 4;

    return apiData['customer_stories'] != null
        ? Container(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: storiesCount,
              itemBuilder: (context, index) {
                final story = apiData['customer_stories'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 253, 255),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue, width: 2),
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
                        Column(
                          children: [
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
                            _buildStarRating(story['rating'].toString()),
                          ],
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  story['city'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
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
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Header Section
                                              Container(
                                                width: double.infinity,
                                                decoration: const BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    topRight:
                                                        Radius.circular(20.0),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: const Center(
                                                  child: Text(
                                                    "Customer Feedback",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Body Section
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Circular Image, Name, and Rating
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Image.network(
                                                            story['pic'],
                                                            height: 60,
                                                            width: 60,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                story['name'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .orangeAccent,
                                                                    size: 16,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 4),
                                                                  Text(
                                                                    story['rating']
                                                                        .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),

                                                    // Feedback Text
                                                    const Text(
                                                      "Feedback:",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      story['feedback'],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Close Button Section
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 20.0,
                                                    bottom: 16.0,
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close dialog
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 20.0,
                                                          vertical: 10.0,
                                                        ),
                                                        backgroundColor:
                                                            Colors.orangeAccent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "Close",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
    int blogsCount = _showAllBlogs ? apiData['our_blog'].length : 3;
    return apiData['our_blog'] != null
        ? Container(
            height: 175, // Adjust height to accommodate the "More" button
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: blogsCount, // apiData['our_blog'].length,
              itemBuilder: (context, index) {
                final blog = apiData['our_blog'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      _showBlogDetails(context, blog);
                    },
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              blog['title'],
                              maxLines: 2, // Limit the title to 2 lines
                              overflow: TextOverflow
                                  .ellipsis, // Ellipsis for overflow
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
                                  padding:
                                      EdgeInsets.only(right: 8.0, top: 5.0),
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
                  ),
                );
              },
            ),
          )
        : Container();
  }

// Function to show the full blog details in a popup
  void _showBlogDetails(BuildContext context, Map<String, dynamic> blog) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amber,
              title: const Text('Blog Details'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Blog content (assuming `content` key holds the full blog text)
                  Text(
                    blog['description'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAstroRemedies() {
    int remidiesCount = _showAllRemidies ? apiData['astro_remedy'].length : 3;
    return apiData['astro_remedy'] != null
        ? Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: remidiesCount, // apiData['astro_remedy'].length,
              itemBuilder: (context, index) {
                final remedy = apiData['astro_remedy'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RemedyDetailsScreen(remedyId: remedy['name']),
                        ),
                      );
                    },
                    child: Container(
                      width: 150, // Width for each remedy card
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
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
          SizedBox(
            height: 100,
          )
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
                  //    print(whyMahakundaliData);
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
