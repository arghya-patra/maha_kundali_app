import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Authentication/otpVerification.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String _gender = 'Male';

  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String mobile = _mobileController.text.trim();
      String url = APIData.login;
      print(url.toString());
      var response = await http.post(Uri.parse(url), body: {
        'action': 'register',
        'mobile': mobile,
        'name': name,
        'email': email,
        'gender': _gender,
        'dob': _dateController.text,
        'tob': _timeController.text,
        'pob': _placeController.text,
        'languange': 'en'
      });

      setState(() {
        _isLoading = false;
      });
      print(response.body);
      if (response.statusCode == 200) {
        // Assuming a successful response contains a "success" key
        var responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          print(responseData);
          ServiceManager().setToken('${responseData['authorizationToken']}');
          // ServiceManager.userID = '${data['userInfo']['id']}';
          ServiceManager.tokenID = '${responseData['authorizationToken']}';
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(
                        isReg: true,
                        otp: responseData['otp'].toString(),
                      )),
              (route) => false);
        } else {
          toastMessage(
              message: 'Registration Succesful! Please Login now',
              colors: Colors.green);
          // Handle errors, e.g., show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['message']),
          ));
        }
      } else {
        // Handle errors, e.g., show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registration failed. Please try again.'),
        ));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        print(_dateController.text);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        final String formattedTime = picked.hour.toString().padLeft(2, '0') +
            ':' +
            picked.minute.toString().padLeft(2, '0');
        _timeController.text = formattedTime;
        print(formattedTime);
        // _timeController.text = picked.format(context);
      });
    }
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
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
        SizedBox(width: 16), // Add spacing between radio buttons
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
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
          ? Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerBox(),
                    const SizedBox(height: 16),
                    _buildShimmerBox(),
                    const SizedBox(height: 16),
                    _buildShimmerBox(),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    _buildTextField(_nameController, 'Name'),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email', isEmail: true),
                    const SizedBox(height: 16),
                    _buildTextField(_mobileController, 'Mobile Number',
                        isNumber: true),
                    const SizedBox(height: 16),
                    _buildGenderSelection(),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _placeController,
                      'Place of Birth',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _timeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Time of Birth',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () => _selectTime(context),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _register,
                      child: const Text('Register'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 15.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isEmail = false, bool isPassword = false, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isNumber
              ? TextInputType.phone
              : TextInputType.text,
      obscureText: isPassword,
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

  Widget _buildShimmerBox() {
    return Container(
      height: 60,
      width: double.infinity,
      color: Colors.white,
    );
  }
}
