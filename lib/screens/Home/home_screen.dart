import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerList.dart';
import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerProfileDetail.dart';
import 'package:maha_kundali_app/screens/Home/walletScreen.dart';
import 'package:maha_kundali_app/screens/Horoscope/horoscopeScreen.dart';
import 'package:maha_kundali_app/screens/chats/customerSupportChat.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      'images/profile.jpeg'), // Replace with the user image asset
                ),
                const SizedBox(width: 10),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Name',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      '+91XXXXXXXXXX',
                      style: TextStyle(color: Colors.white, fontSize: 14),
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
              children: [
                _buildDrawerItem(
                  Icons.home,
                  'Home',
                ),
                _buildDrawerItem(Icons.book_online, 'Book a Puja'),
                _buildDrawerItem(Icons.calendar_today, 'Daily Horoscope'),
                _buildDrawerItem(Icons.chat, 'Customer Support Chat'),
                _buildDrawerItem(
                    Icons.account_balance_wallet, 'Wallet Transaction'),
                _buildDrawerItem(Icons.history, 'Order History'),
                _buildDrawerItem(Icons.card_membership, 'Buy Membership'),
                _buildDrawerItem(Icons.shopping_bag, 'Astro Products'),
                _buildDrawerItem(Icons.book, 'Astro Book'),
                _buildDrawerItem(Icons.chat_bubble, 'Chat with Astrologers'),
                _buildDrawerItem(Icons.favorite, 'My Followings'),
                _buildDrawerItem(Icons.star, 'Free Services'),
                _buildDrawerItem(Icons.person_add, 'Sign up as Astrologer'),
                _buildDrawerItem(Icons.settings, 'Settings'),
                _buildDrawerItem(Icons.logout, 'Log Out'),
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
    return ListTile(
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerSupportChat(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundImage:
                  AssetImage('images/cart.png'), // replace with your cart image
            ),
          ),
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
              radius: 18,
              backgroundImage: AssetImage(
                  'images/wallet.png'), // replace with your wallet image
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(
                'images/notification.png'), // replace with your notification image
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
                _buildHorizontalOptions(),
                const SizedBox(height: 8),
                _buildLiveAstrologerSection(context),
                const SizedBox(height: 8),
                _buildChatWithAstrologerSection(context),
                const SizedBox(height: 8),
                _buildLibraDailyHoroscope(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalOptions() {
    final List<Map<String, String>> options = [
      {'title': '2024 \nSpecial', 'image': 'images/year.jpeg'},
      {'title': 'Daily \nHoroscope', 'image': 'images/daily_horoscope.png'},
      {'title': 'Zodiac', 'image': 'images/zodiac.jpeg'},
      {'title': 'Kundali', 'image': 'images/kundali.png'},
      {
        'title': 'Love \nCompatibility',
        'image': 'images/love_compatibility.png'
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HoroscopeScreen(),
                ),
              );

              // Handle navigation to other screen
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
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
                  const SizedBox(height: 8),
                  Text(
                    options[index]['title']!,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveAstrologerSection(BuildContext context) {
    final List<Map<String, String>> astrologers = [
      {'name': 'Astrologer 1', 'image': 'images/astro1.jpg'},
      {'name': 'Astrologer 2', 'image': 'images/astro2.jpg'},
      {'name': 'Astrologer 3', 'image': 'images/astro3.jpg'},
      {'name': 'Astrologer 4', 'image': 'images/astro1.jpg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Live Astrologers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: astrologers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AstrologerProfileScreen(),
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
                            image: AssetImage(astrologers[index]['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          color: Colors.red,
                          child: const Text('Live',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Text(
                          astrologers[index]['name']!,
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
            child:
                const Text('View All', style: TextStyle(color: Colors.orange)),
          ),
        ),
      ],
    );
  }

  Widget _buildChatWithAstrologerSection(BuildContext context) {
    final List<Map<String, String>> astrologers = [
      {'name': 'Astrologer 5', 'image': 'images/astro1.jpg', 'rating': '4.7'},
      {'name': 'Astrologer 6', 'image': 'images/astro2.jpg', 'rating': '4.8'},
      {'name': 'Astrologer 7', 'image': 'images/astro3.jpg', 'rating': '4.6'},
      {'name': 'Astrologer 8', 'image': 'images/astro2.jpg', 'rating': '4.9'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Chat with Astrologers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: astrologers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle navigation to astrologer chat screen
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrangeAccent,
                          image: DecorationImage(
                            image: AssetImage(astrologers[index]['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          color: Colors.green,
                          child: const Row(
                            children: [
                              Icon(Icons.verified,
                                  color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text('Online',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              astrologers[index]['name']!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(astrologers[index]['rating']!,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                const SizedBox(width: 4),
                                const Icon(Icons.star,
                                    color: Colors.yellow, size: 14),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Handle view all navigation
            },
            child:
                const Text('View All', style: TextStyle(color: Colors.orange)),
          ),
        ),
      ],
    );
  }

  Widget _buildLibraDailyHoroscope() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('images/libra.jpeg'),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Libra Daily Horoscope',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Today is a good day to focus on your relationships...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.orange),
        ],
      ),
    );
  }
}
