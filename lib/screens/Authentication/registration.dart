import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Authentication/otpVerification.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String email = _emailController.text.trim();
      String mobile = _mobileController.text.trim();
      String password = _passwordController.text.trim();
      String url = APIData.login;
      print(url.toString());
      var response = await http.post(Uri.parse(url), body: {
        'action': 'register',
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'mobile': mobile,
        'password': password
      });
      //  var data = jsonDecode(response.body);
      // var response = await http.post(
      //   Uri.parse('https://yourapi.com/register'),
      //   body: json.encode({
      //     'first_name': firstName,
      //     'last_name': lastName,
      //     'email': email,
      //     'mobile': mobile,
      //     'password': password,
      //   }),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      // );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Assuming a successful response contains a "success" key
        var responseData = json.decode(response.body);
        if (responseData['isSuccess']) {
          print(responseData);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(
                        isReg: true,
                        otp: responseData['userDetails']['otp'].toString(),
                      )),
              (route) => false);
        } else {
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
                    _buildTextField(_firstNameController, 'First Name'),
                    const SizedBox(height: 16),
                    _buildTextField(_lastNameController, 'Last Name'),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email', isEmail: true),
                    const SizedBox(height: 16),
                    _buildTextField(_mobileController, 'Mobile Number',
                        isNumber: true),
                    const SizedBox(height: 16),
                    _buildTextField(_passwordController, 'Password',
                        isPassword: true),
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

class OtpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
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
      body: const Center(
        child: Text('Enter OTP here'),
      ),
    );
  }
}
