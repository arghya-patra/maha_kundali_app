import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Home/userDashboardScreen.dart';
import 'package:maha_kundali_app/screens/HomeAstrologers/dashBoard_astro.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ContactAstroProfileScreen extends StatefulWidget {
  @override
  _ContactAstroProfileScreenState createState() =>
      _ContactAstroProfileScreenState();
}

class _ContactAstroProfileScreenState extends State<ContactAstroProfileScreen> {
  bool _isLoading = true;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  String _gender = 'Male';

  @override
  void initState() {
    super.initState();
    // fullNameController.text = ServiceManager.userName;
    // emailController.text = ServiceManager.userEmail;
    // phoneNumberController.text = ServiceManager.userMobile;
    getUserData();

    // Simulate a loading delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void getUserData() async {
    setState(() {
      _isLoading = true;
    });
    String url = APIData.login;
    var res = await http.post(Uri.parse(url), body: {
      'action': 'astrologer-profile-update',
      'authorizationToken': ServiceManager.tokenID, //8100007581
    });
    var data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      //  _nameController.text = '${data['userDetails']['name']}';

      // profileURL = '${data['userDetails']['logo']}';
      // userMobile = data['userDetails']['mobile'] ?? '';
      setState(() {
        _isLoading = false;
      });
    } else {}
  }

  Future<void> upDateProfileData() async {}
  String? selectedCountry = "India";
  String? selectedState;
  String? selectedCity;

  final List<String> states = [
    "Andhra Pradesh",
    "Karnataka",
    "Maharashtra",
    "Tamil Nadu",
    "Uttar Pradesh",
  ];

  final Map<String, List<String>> cities = {
    "Andhra Pradesh": ["Vishakhapatnam", "Vijayawada", "Guntur"],
    "Karnataka": ["Bangalore", "Mysore", "Hubli"],
    "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
    "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai"],
    "Uttar Pradesh": ["Lucknow", "Kanpur", "Varanasi"],
  };

  List<String> availableCities = [];

  void _updateCityDropdown(String state) {
    setState(() {
      availableCities = cities[state] ?? [];
      selectedCity = null;
    });
  }

  Widget _buildTextFields(TextEditingController controller, String labelText,
      {bool isEmail = false,
      bool isPassword = false,
      bool isNumber = false,
      readOnly = false,
      maxLines}) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isNumber
              ? TextInputType.phone
              : TextInputType.text,
      obscureText: isPassword,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (isPassword && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (isNumber && value.length != 10) {
          return 'Please enter a valid mobile number';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact Details'),
        centerTitle: true,
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
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: _buildShimmerEffect(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCountry,
                      items: ["India"]
                          .map((country) => DropdownMenuItem(
                              value: country, child: Text(country)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // State Dropdown
                    const Text("State"),
                    DropdownButtonFormField<String>(
                      value: selectedState,
                      items: states
                          .map((state) => DropdownMenuItem(
                              value: state, child: Text(state)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedState = value;
                          _updateCityDropdown(value!);
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // City Dropdown
                    const Text("City"),
                    DropdownButtonFormField<String>(
                      value: selectedCity,
                      items: availableCities
                          .map((city) =>
                              DropdownMenuItem(value: city, child: Text(city)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),
                    _buildTextFields(addressController, 'Address'),
                    const SizedBox(height: 16),
                    _buildTextFields(pinCodeController, 'Pin Code'),
                    const SizedBox(height: 16),
                    _buildTextFields(degreeController, 'Highest Qualification'),
                    const SizedBox(height: 16),

                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          upDateProfileData();
                          // Handle update functionality
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                ),
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
        const SizedBox(height: 16),
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 16),
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 16),
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 16),
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 32),
        Container(
          height: 40,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        const Spacer(),
        Container(
          height: 20,
          width: 150,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 16),
        Container(
          height: 40,
          width: double.infinity,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRadioOption('Male'),
            _buildRadioOption('Female'),
            _buildRadioOption('Other'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _gender,
          onChanged: (String? newValue) {
            setState(() {
              _gender = newValue!;
            });
          },
        ),
        Text(value),
        const SizedBox(width: 16), // Add spacing between radio buttons
      ],
    );
  }
}
