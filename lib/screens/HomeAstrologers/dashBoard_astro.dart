import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/HomeAstrologers/bookingListScreen.dart';
import 'package:maha_kundali_app/screens/HomeAstrologers/earningScreen.dart';
import 'package:maha_kundali_app/screens/HomeAstrologers/home_astro.dart';
import 'package:maha_kundali_app/screens/profileContent/editProfile.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class DashboardForAstrologerScreen extends StatefulWidget {
  @override
  _DashboardForAstrologerScreenState createState() =>
      _DashboardForAstrologerScreenState();
}

class _DashboardForAstrologerScreenState
    extends State<DashboardForAstrologerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDashboardData(context);
    _tabController = TabController(length: 4, vsync: this);
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
      print("______________________________________");
      print(res.body);
      print("______________________________________");
      try {
        // toastMessage(message: 'Logged In');
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => DashboardScreen()),
        //     (route) => false);
      } catch (e) {
        toastMessage(message: e.toString());
        setState(() {
          isLoading = false;
        });
        toastMessage(message: 'Something went wrong');
      }
    } else {
      setState(() {
        isLoading = false;
      });
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
          HomeAstroScreen(),
          BookingListScreen(),
          EarningsScreen(),
          EditProfileScreen(),
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
        tabs: const [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.shop)),
          // Container(
          //   height: 60,
          //   child: const Column(
          //     children: [
          //       CircleAvatar(
          //         backgroundColor: Colors.white,
          //         radius: 28,
          //         child: Icon(Icons.chat, size: 30, color: Colors.orange),
          //       ),
          //     ],
          //   ),
          // ),
          Tab(icon: Icon(Icons.shopping_cart)),
          Tab(icon: Icon(Icons.person)),
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
