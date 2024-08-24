import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:maha_kundali_app/aaa/test.dart';
import 'package:maha_kundali_app/components/buttons.dart';
import 'package:maha_kundali_app/screens/Authentication/login.dart';
import 'package:maha_kundali_app/screens/Authentication/otpVerification.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  bool _isFormVisible = false;
  bool isLoading = false;
  String? selectedCountryCode = '+91';

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isFormVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign up'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepOrange,
                Colors.orange,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity: _isFormVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register with your phone number',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You will receive an OTP',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: _isFormVisible
                  ? Row(
                      children: [
                        Container(
                          //color: Colors.red,
                          child: CountryListPick(
                            onChanged: (CountryCode? code) {
                              setState(() {
                                selectedCountryCode = code!.dialCode;
                              });
                            },
                            initialSelection: '+91',
                            useSafeArea: true,
                          ),
                        ),
                        //  const SizedBox(width: 2),
                        const Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 32),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VideoCallScreen()));
                },
                child: const Text(
                  'Have an account? Sign in!',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: isLoading != true
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpVerificationScreen(),
                          ),
                        );
                      },
                      child: Text('Send Otp'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 15.0),
                      ),
                    )
                  : LoadingButton(),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Some other text as footer',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
