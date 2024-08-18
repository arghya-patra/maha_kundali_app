import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/my_order.dart';
import 'package:maha_kundali_app/screens/profileContent/editProfile.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsSection/changePassword.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsSection/myAddress.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsSection/terms.dart';
import 'package:shimmer/shimmer.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Simulate loading time for shimmer effect
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Settings'),
            Tab(text: 'Transaction'),
            Tab(text: 'Notifications'),
          ],
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? _buildShimmerEffect()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSettingsTab(),
                _buildPaymentTab(),
                _buildNotificationsTab(),
              ],
            ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        children: List.generate(6, (index) => _buildShimmerListItem()),
      ),
    );
  }

  Widget _buildShimmerListItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60.0,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      children: [
        _buildSectionHeader('General'),
        _buildSettingsOption('My Orders', Icons.shopping_cart,
            route: OrderDetailsScreen()),
        _buildSettingsOption('My Address', Icons.location_on,
            route: AddMyAddressScreen()),
        _buildSettingsOption('Edit Profile', Icons.edit,
            route: EditProfileScreen()),
        _buildSettingsOption('Change Password', Icons.lock,
            route: ChangePasswordScreen()),
        _buildSectionHeader('About Us'),
        _buildSettingsOption('Terms and Conditions', Icons.article,
            route: TermsAndConditionsScreen()),
        _buildSettingsOption('Privacy Policy', Icons.privacy_tip,
            route: TermsAndConditionsScreen()),
        _buildSectionHeader('Notification'),
        _buildNotificationSwitch(),
      ],
    );
  }

  Widget _buildPaymentTab() {
    return ListView(
      children: [
        _buildSectionHeader('Last Transactions'),
        ...List.generate(10, (index) => _buildTransactionItem(index + 1)),
        TextButton(
          onPressed: () {
            // View more action
          },
          child: Text('View More'),
        ),
      ],
    );
  }

  Widget _buildNotificationsTab() {
    return ListView(
      children: List.generate(10, (index) => _buildNotificationItem(index)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    );
  }

  Widget _buildSettingsOption(String title, IconData icon, {route}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => route,
          ),
        );
        // Navigate to corresponding screen
      },
    );
  }

  Widget _buildNotificationSwitch() {
    return SwitchListTile(
      title: Text('Allow Notifications'),
      value: true,
      onChanged: (bool value) {
        // Handle notification switch
      },
      secondary: Icon(Icons.notifications_active, color: Colors.orange),
    );
  }

  Widget _buildTransactionItem(int index) {
    return ListTile(
      leading: Icon(Icons.payment, color: Colors.green),
      title: Text('Transaction $index'),
      subtitle: Text('Details of the transaction'),
      trailing: Text(
        '₹${index * 100}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNotificationItem(int index) {
    return ListTile(
      leading: Icon(
        index % 2 == 0 ? Icons.admin_panel_settings : Icons.system_update,
        color: index % 2 == 0 ? Colors.blue : Colors.red,
      ),
      title: Text('Notification Title $index'),
      subtitle: Text('This is the detail of notification $index.'),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        // Handle notification click
      },
    );
  }
}
