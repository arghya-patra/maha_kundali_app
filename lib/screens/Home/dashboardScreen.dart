import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/cartScreen.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/productListScreen.dart';
import 'package:maha_kundali_app/screens/Home/astro_home.dart';
import 'package:maha_kundali_app/screens/Home/home_screen.dart';
import 'package:maha_kundali_app/screens/Home/profile.dart';
import 'package:maha_kundali_app/screens/chats/chatListScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
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
    print("______________________________________");
    print(res.body);
    print("______________________________________");
    var data = jsonDecode(res.body);
    if (data['status'] == 200) {
      print("______________________________________");
      print(res.body);
      print("______________________________________");
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
          AstrologerDashboard(), //  HomeScreen(),
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
