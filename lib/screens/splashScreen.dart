import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/Authentication/login.dart';
import 'package:maha_kundali_app/screens/Authentication/registration.dart';
import 'package:maha_kundali_app/screens/Home/dashboardScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:maha_kundali_app/theme/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    ServiceManager().getUserID();
    ServiceManager().getTokenID();
    // LocationService().fetchLocation();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (ServiceManager.userID != '') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer!.isActive) _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Image.asset(
        'images/splash_img.webp',
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.contain,
      ),
    );
  }
}
