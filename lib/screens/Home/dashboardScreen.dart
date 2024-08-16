import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/cartScreen.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/productListScreen.dart';
import 'package:maha_kundali_app/screens/Home/home_screen.dart';
import 'package:maha_kundali_app/screens/Home/profile.dart';
import 'package:maha_kundali_app/screens/chats/chatListScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  key: _scaffoldKey,

      body: TabBarView(
        controller: _tabController,
        children: [
          HomeScreen(),
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
          const Tab(icon: Icon(Icons.home)),
          const Tab(icon: Icon(Icons.shop)),
          Container(
            height: 60,
            child: const Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28,
                  child: Icon(Icons.chat, size: 30, color: Colors.orange),
                ),
              ],
            ),
          ),
          const Tab(icon: Icon(Icons.shopping_cart)),
          const Tab(icon: Icon(Icons.person)),
        ],
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(5.0),
        indicatorColor: Colors.white,
        indicator: const BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class LiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Live Screen'));
  }
}

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Orders Screen'));
  }
}
