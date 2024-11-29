import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Authentication/login.dart';
import 'package:maha_kundali_app/screens/HomeAstrologers/productUpload.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:maha_kundali_app/theme/style.dart';

class HomeAstroScreen extends StatefulWidget {
  @override
  _HomeAstroScreenState createState() => _HomeAstroScreenState();
}

class _HomeAstroScreenState extends State<HomeAstroScreen> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
    // if (dashboardData == null) {
    //   ServiceManager().removeAll();
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginScreen()),
    //       (route) => false);
    // }
  }

  Future<void> fetchDashboardData() async {
    String url = APIData.login;
    var res = await http.post(Uri.parse(url), body: {
      'action': 'dashboard-overview',
      'authorizationToken': ServiceManager.tokenID, //8100007581
    });
    var data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        dashboardData = json.decode(res.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Astrologer Dashboard'),
      ),
      drawer: _buildDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHorizontalCards(),
                  const SizedBox(height: 20),
                  _buildRecentChatRequests(),
                  const SizedBox(height: 20),
                  _buildRecentReviews(),
                ],
              ),
            ),
    );
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
                              radius: 30,
                              backgroundImage:
                                  AssetImage('images/profile.jpeg'),
                              backgroundColor: Colors.transparent,
                            )
                          : CircleAvatar(
                              radius: 30,
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
                              fontSize: 18,
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
              const Positioned(
                bottom: 5, // Position the wallet section at the bottom left
                right: 12,
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                      size: 29,
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                          "Balance",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '₹ 0.00', // Replace with the wallet balance variable
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                _buildDrawerItem(Icons.upload, 'Product Upload',
                    route: ProductUploadScreen()),
                GestureDetector(
                  onTap: () {
                    logoutBuilder(context, onClickYes: () {
                      try {
                        Navigator.pop(context);
                        setState(() {
                          isLoading = true;
                        });
                        ServiceManager().removeAll();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false);
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    });
                  },
                  child: const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ),
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

  Widget _buildDrawer2() {
    print("^^^^^^^^");
    print(ServiceManager.profileURL);
    print("^^^^^^^^");
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.red],
              ),
            ),
            accountName: Text(ServiceManager.userName),
            accountEmail: Text(ServiceManager.userEmail),
            currentAccountPicture: ServiceManager.profileURL ==
                    'https://mahakundali.com/'
                ? const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/profile.jpeg'),
                    backgroundColor: Colors.transparent,
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(ServiceManager.profileURL),
                  ),

            //  CircleAvatar(
            //   backgroundImage: NetworkImage(ServiceManager.profileURL),
            // ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductUploadScreen(),
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.person),
              title: Text('Product Upload'),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          GestureDetector(
            onTap: () {
              logoutBuilder(context, onClickYes: () {
                try {
                  Navigator.pop(context);
                  setState(() {
                    isLoading = true;
                  });
                  ServiceManager().removeAll();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                }
              });
            },
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> logoutBuilder(BuildContext context,
      {required Function() onClickYes}) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        title: Text('Logout', style: kHeaderStyle()),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onClickYes,
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCards() {
    List<Widget> cards = [];
    if (dashboardData != null) {
      for (var item in dashboardData!['astrologer_dashboard_overview']) {
        String title = item.keys.first;
        var data = item[title];
        cards.add(_buildCard(
            title, data['total'].toString(), data['icon'], data['url']));
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards,
      ),
    );
  }

  Widget _buildCard(String title, String count, String iconUrl, String url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // Handle navigation to the URL or other actions
        },
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: 180,
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.orange.shade200, Colors.red.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.network(iconUrl, width: 40, height: 40),
                    const Spacer(),
                    Text(
                      count,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentChatRequests() {
    List chatRequests = dashboardData?['chat_request_received_list'] ?? [];
    return _buildSection(
      title: 'Recent Chat Requests',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: ['Date', 'Customer Name', 'Status', 'Action']
              .map((header) => DataColumn(label: Text(header)))
              .toList(),
          rows: chatRequests.map((chat) {
            return DataRow(cells: [
              DataCell(Text(chat['date'])),
              DataCell(Text(chat['name'])),
              DataCell(Text(chat['online_status'])),
              DataCell(ElevatedButton(
                onPressed: () {
                  // Handle Chat Now action
                },
                child: const Text('Chat Now'),
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecentReviews() {
    List reviews = dashboardData?['recent_reviews_list'] ?? [];
    return _buildSection(
      title: 'Recent Reviews',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: ['Date', 'Review', 'Rating']
              .map((header) => DataColumn(label: Text(header)))
              .toList(),
          rows: reviews.map((review) {
            return DataRow(cells: [
              DataCell(Text(review['date'])),
              DataCell(Container(
                width: 200, // Limit the width of the review text
                child: Text(
                  review['review'],
                  overflow: TextOverflow.ellipsis,
                ),
              )),
              DataCell(Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < int.parse(review['rate'])
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.orange,
                  );
                }),
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
