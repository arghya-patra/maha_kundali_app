import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/my_order.dart';
import 'package:maha_kundali_app/screens/profileContent/editProfile.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsSection/changePassword.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsSection/contactUs.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsSection/myAddress.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsSection/terms.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Map<String, dynamic>>? _transactionData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch data on initialization
    _fetchTransactionDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTransactionDetails() async {
    String url = APIData.login;

    try {
      var res = await http.post(Uri.parse(url), body: {
        'action': 'transaction',
        'authorizationToken': ServiceManager.tokenID
      });

      var data = jsonDecode(res.body);
      if (data['isSuccess'] == true && data['status'] == 200) {
        setState(() {
          _transactionData =
              List<Map<String, dynamic>>.from(data['transaction_list']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        toastMessage(message: 'Something went wrong');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      toastMessage(message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
            const Tab(text: 'Settings'),
            const Tab(text: 'Transaction'),
            // const Tab(text: 'Notifications'),
          ],
          indicatorColor: Colors.white,
          labelStyle:
              const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSettingsTab(),
                _buildPaymentTab(),
                //  _buildNotificationsTab(),
              ],
            ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      children: [
        _buildSectionHeader('General'),
        _buildSettingsOption('My Orders', Icons.shopping_cart,
            route: OrderHistoryScreen()),
        // _buildSettingsOption('My Address', Icons.location_on,
        //     route: AddMyAddressScreen()),
        _buildSettingsOption('Edit Profile', Icons.edit,
            route: EditProfileScreen()),
        // _buildSettingsOption('Change Password', Icons.lock,
        //     route: ChangePasswordScreen()),
        _buildSectionHeader('About Us'),
        _buildSettingsOption('Terms and Conditions', Icons.article,
            route: TermsAndConditionsScreen(
              title: "Terms of Service",
              action: 'terms-of-service',
            )),
        _buildSettingsOption('Privacy Policy', Icons.privacy_tip,
            route: TermsAndConditionsScreen(
              title: "Privacy Policy",
              action: 'privacy-policy',
            )),
        _buildSettingsOption('Refund Polocy', Icons.article,
            route: TermsAndConditionsScreen(
              title: "Refund Policy",
              action: 'refund-policy',
            )),
        _buildSettingsOption('About Us', Icons.privacy_tip,
            route: TermsAndConditionsScreen(
              title: "About Us",
              action: 'about-us',
            )),
        _buildSettingsOption('Contact Us', Icons.contact_page,
            route: ContactUsScreen()),

        _buildSectionHeader('Notification'),
        _buildNotificationSwitch(),
      ],
    );
  }

  Widget _buildPaymentTab() {
    if (_transactionData == null || _transactionData!.isEmpty) {
      return Center(child: Text('No transactions found'));
    }
    return ListView(
      children: _transactionData!
          .map((transaction) => _buildTransactionItem(transaction))
          .toList(),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return ListTile(
      leading: Icon(Icons.payment, color: Colors.green),
      title: Text(transaction['service_name'] ?? 'No Service Name'),
      subtitle: Text(
          'ID: ${transaction['trans_id'] ?? 'N/A'}\nDate: ${transaction['date']}'),
      trailing: Text(
        '₹${transaction['amount']}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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
        style: const TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    );
  }

  Widget _buildSettingsOption(String title, IconData icon,
      {required Widget route}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => route,
          ),
        );
      },
    );
  }

  bool isNoti = false;

  Widget _buildNotificationSwitch() {
    return SwitchListTile(
      title: const Text('Allow Notifications'),
      value: isNoti,
      onChanged: (bool value) {
        setState(() {
          isNoti = !isNoti;
        });
        // Handle notification switch
      },
      secondary: const Icon(Icons.notifications_active, color: Colors.orange),
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
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        // Handle notification click
      },
    );
  }
}
