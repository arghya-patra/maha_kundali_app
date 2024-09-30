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
  String selectedLanguage = "English";

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
        'languange': selectedLanguage == 'English' ? 'en' : 'hn'
      });

      setState(() {
        _isLoading = false;
      });
      print(response.body);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          ServiceManager().setToken('${responseData['authorizationToken']}');
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['message']),
          ));
        }
      } else {
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
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _timeController.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
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
        SizedBox(width: 16),
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
                    _buildDateField(_dateController, 'Date of Birth',
                        Icons.calendar_today, () => _selectDate(context)),
                    const SizedBox(height: 20),
                    _buildDateField(_timeController, 'Time of Birth',
                        Icons.access_time, () => _selectTime(context)),
                    const SizedBox(height: 20),
                    _buildFieldContainer(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedLanguage,
                        underline:
                            const SizedBox(), // Remove default underline for a cleaner look
                        dropdownColor: Colors.white, // Dropdown menu color
                        icon: Icon(Icons.arrow_drop_down,
                            color: Colors.deepOrange), // Custom dropdown icon
                        items: ["English", "Hindi"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Colors.grey[800], // Custom text color
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                      ),
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

  Widget _buildFieldContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Background color similar to the text fields
        border: Border.all(color: Colors.orange), // Matching border color
        borderRadius: BorderRadius.circular(12), // Matching rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Subtle shadow
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: child,
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
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.deepOrange, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: isEmail ? Icon(Icons.email) : null,
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

  Widget _buildDateField(TextEditingController controller, String labelText,
      IconData icon, VoidCallback onTap) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.deepOrange, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildShimmerBox() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
