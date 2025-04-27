import 'dart:async';

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

  bool _isLoading2 = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<dynamic> _cities = [];
  String? _selectedCity;
  String? _selectedLat;
  String? _selectedLon;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _fetchCities(_searchController.text);
      }
    });
  }

  Future<void> _fetchCities(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(Uri.parse(APIData.login), body: {
        'action': 'get-city-name',
        'name': query,
      });

      // Log the response to check if it's valid
      print('Response: "${response.body}"'); // Log the response content
      print('Response: "${response.statusCode}"');

      if (response.body.isEmpty) {
        // Handle empty response
        print('Error: API returned an empty response');
        setState(() {
          _cities = [];
          _isLoading = false;
        });
        return;
      }

      if (response.statusCode == 200) {
        // Try decoding the response body
        try {
          final data = jsonDecode(response.body);

          if (data != null && data['city'] != null) {
            setState(() {
              _cities = data['city'];
              _isLoading = false;
            });
          } else {
            print('Error: "city" key not found in the response');
            setState(() {
              _cities = [];
              _isLoading = false;
            });
          }
        } catch (e) {
          print('Error decoding JSON: $e');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print(
            'Error: Failed to fetch cities, status code: ${response.statusCode}');
        setState(() {
          _cities = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _cities = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading2 = true;
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
        'pob': _selectedCity, //_placeController.text,
        'languange': selectedLanguage == 'English' ? 'en' : 'hn'
      });

      setState(() {
        _isLoading2 = false;
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
            backgroundColor: Colors.red,
            content: Text(responseData['message']),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
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
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register as an User'),
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
      body: _isLoading2
          ? Center(child: CircularProgressIndicator())
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
                    //-----------------------------------------------------------------------------------

                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: "Place of Birth",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                              color: Colors.deepOrange, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        suffixIcon:
                            _isLoading ? CircularProgressIndicator() : null,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Dropdown list for city suggestions
                    if (_cities.isNotEmpty)
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _cities.length,
                          itemBuilder: (context, index) {
                            final city = _cities[index]['city'];
                            final lat = _cities[index]['lat'];
                            final lon = _cities[index]['lon'];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCity = city;
                                  _selectedLat = lat;
                                  _selectedLon = lon;
                                  _searchController.text =
                                      city; // Set the selected city
                                  _cities.clear(); // Clear the dropdown
                                });
                              },
                              child: Container(
                                height: 50, // Set the desired height
                                padding: const EdgeInsets.all(
                                    8.0), // Optional: Add padding for the text
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors
                                        .grey, // Set the color of the border
                                    width: 1.0, // Set the width of the border
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Optional: Add rounded corners
                                ),
                                child: Text(
                                  city,
                                  style: TextStyle(
                                      fontSize:
                                          16), // Customize text style if needed
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    // Display selected city's details
                    // if (_selectedCity != null)
                    //   Padding(
                    //     padding: const EdgeInsets.all(3.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Selected City: $_selectedCity'),
                    //         Text('Latitude: $_selectedLat'),
                    //         Text('Longitude: $_selectedLon'),
                    //       ],
                    //     ),
                    //   ),
//-----------------------------------------------------------------------------------
                    // _buildTextField(
                    //   _placeController,
                    //   'Place of Birth',
                    // ),
                    //  const SizedBox(height: 16),
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
                        icon: const Icon(Icons.arrow_drop_down,
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
          borderSide: const BorderSide(color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: isEmail ? const Icon(Icons.email) : null,
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
          borderSide: const BorderSide(color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
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
