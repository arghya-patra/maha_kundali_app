import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/cartScreen.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/productListScreen.dart';
import 'package:maha_kundali_app/screens/Home/user_home.dart';
import 'package:maha_kundali_app/screens/Home/test_purpose/test_astro_home2.dart';
import 'package:maha_kundali_app/screens/Home/test_purpose/test_home_screen.dart';
import 'package:maha_kundali_app/screens/Home/profile.dart';
import 'package:maha_kundali_app/screens/chats/chatListScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;

class UserDashboardScreen extends StatefulWidget {
  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ServiceManager().getUserData();
    getDashboardData(context);
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  getDashboardData(context) async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    print(ServiceManager.tokenID);
    print(url.toString());
    var res = await http.post(Uri.parse(url), body: {
      'action': 'dashboard-overview',
      'authorizationToken': ServiceManager.tokenID, //8100007581
    });
    var data = jsonDecode(res.body);
    if (data['status'] == 200) {
      try {} catch (e) {
        toastMessage(message: e.toString());
        setState(() {
          isLoading = false;
        });
        print("catch");
        toastMessage(message: 'Something went wrong');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print("ELse part");
      toastMessage(message: 'Something Went wrong!');
    }
    setState(() {
      isLoading = false;
    });
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  key: _scaffoldKey,

      body: TabBarView(
        controller: _tabController,
        children: [
          UserDashboard(), //  HomeScreen(),
          ShoppingScreen(),
          ChatListScreen(),
          ShoppingCartScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomTabBar(),
    );
  }

  Widget _buildBottomTabBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: _buildTabContent(
              icon: Icons.home,
              label: 'Home',
            ),
          ),
          Tab(
            child: _buildTabContent(
              icon: Icons.shop,
              label: 'Shop',
            ),
          ),
          Tab(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: _tabController.index == 2
                    ? Colors.white
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: _tabController.index == 2
                    ? Colors.white
                    : Colors.transparent,
                radius: 28,
                child: Icon(
                  Icons.chat,
                  size: 30,
                  color:
                      _tabController.index == 2 ? Colors.orange : Colors.white,
                ),
              ),
            ),
          ),
          Tab(
            child: _buildTabContent(
              icon: Icons.shopping_cart,
              label: 'Cart',
            ),
          ),
          Tab(
            child: _buildTabContent(
              icon: Icons.person,
              label: 'Profile',
            ),
          ),
        ],
        indicator: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.3),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _buildTabContent({required IconData icon, required String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
