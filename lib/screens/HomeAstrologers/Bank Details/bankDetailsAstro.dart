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

class EditBankDetailsAstro extends StatefulWidget {
  @override
  _EditBankDetailsAstroState createState() => _EditBankDetailsAstroState();
}

class _EditBankDetailsAstroState extends State<EditBankDetailsAstro> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  String type = 'Savings';
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
      setState(() {
        _nameController.text = '${data['userDetails']['acc_holder_name']}';
        _bankNameController.text = '${data['userDetails']['bname']}';
        _accountNoController.text = '${data['userDetails']['acc_number']}';
        _ifscController.text = '${data['userDetails']['ifsc_code']}';
        type =
            '${data['userDetails']['acc_type']}' == 'S' ? "Savings" : "Current";
      });

      setState(() {
        _isLoading = false;
      });
    } else {}
  }

  Future<void> upDateBankData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-bank',
        'authorizationToken': ServiceManager.tokenID,
        'acc_holder_name': _nameController.text,
        'bname': _bankNameController.text,
        'acc_number': _accountNoController.text,
        'ifsc_code': _ifscController.text,
        'acc_type': type == "Savings" ? 'S' : 'C',
        'edit': '1'
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) {
          print(["_____", data]);
          getUserData();
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error fetching Data: $e');
    }
    setState(() {
      _isLoading = false;
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
        title: const Text('Edit Bank Details'),
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
                  children: [
                    const SizedBox(height: 16),
                    _buildTextFields(_nameController, 'Account Holder Name'),
                    const SizedBox(height: 16),
                    _buildTextFields(
                      _bankNameController,
                      'Bank Name',
                    ),
                    const SizedBox(height: 16),
                    _buildTextFields(
                      _accountNoController,
                      'Account Number',
                    ),
                    const SizedBox(height: 16),
                    _buildTextFields(
                      _ifscController,
                      'IFSC Code  ',
                    ),
                    const SizedBox(height: 16),
                    _buildAccTtypeSelection(),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        upDateBankData();
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
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAccTtypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Type',
          style: TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRadioOption('Savings'),
            _buildRadioOption('current'),
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
          groupValue: type,
          onChanged: (String? newValue) {
            setState(() {
              type = newValue!;
            });
          },
        ),
        Text(value),
        const SizedBox(width: 16), // Add spacing between radio buttons
      ],
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
}
