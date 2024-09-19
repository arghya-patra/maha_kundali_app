import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/Authentication/login.dart';
import 'package:maha_kundali_app/screens/profileContent/buyMembershipScreen.dart';
import 'package:maha_kundali_app/screens/profileContent/callIntakeForm.dart';
import 'package:maha_kundali_app/screens/profileContent/editProfile.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:maha_kundali_app/theme/style.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  String _profileImage = 'images/profile.jpeg'; // Initial profile image

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a loading delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
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

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.orange),
                title: Text('Camera'),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _profileImage = pickedFile.path;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_album, color: Colors.orange),
                title: Text('Gallery'),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _profileImage = pickedFile.path;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: _buildShimmerEffect(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(_profileImage),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImageSourceActionSheet,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange,
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('John Doe',
                      style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 8),
                  Text('johndoe@example.com',
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 32),
                  _buildProfileOption('Edit Profile', Icons.edit, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen()));
                  }),
                  _buildProfileOption('Settings', Icons.settings, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  }),
                  _buildProfileOption(
                      'Buy Membership',
                      //Billing Details',
                      Icons.credit_card, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuyMembershipScreen()));
                  }),
                  _buildProfileOption(
                      'Call Intake Form',
                      //User Management
                      Icons.group, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CallIntakeFormScreen()));
                  }),
                  _buildProfileOption('Logout', Icons.logout, () {
                    logoutBuilder(context, onClickYes: () {
                      try {
                        Navigator.pop(context);
                        setState(() {
                          _isLoading = true;
                        });
                        ServiceManager().removeAll();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false);
                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    });
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
        ),
        SizedBox(height: 16),
        Container(
          height: 20,
          width: 150,
          color: Colors.grey[300],
        ),
        SizedBox(height: 8),
        Container(
          height: 20,
          width: 200,
          color: Colors.grey[300],
        ),
        SizedBox(height: 32),
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        SizedBox(height: 16),
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        SizedBox(height: 16),
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        SizedBox(height: 16),
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        SizedBox(height: 16),
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}

class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Center(
        child: Text('User Management Screen'),
      ),
    );
  }
}
