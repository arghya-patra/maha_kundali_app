import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/language_selection/language_selection.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _resendVisible = false;
  TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );

    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _controller.addListener(() {
      if (_controller.isDismissed) {
        setState(() {
          _resendVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String get _timerText {
    Duration duration = _controller.duration! * _controller.value;
    return '${duration.inSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Otp verification'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the code we have sent to +91xxxxxxx098',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 32),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Text(
                    _timerText,
                    style: TextStyle(fontSize: 20, color: Colors.orange),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _otpController,
                  autoDisposeControllers: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeColor: Colors.orange,
                    selectedColor: Colors.orange,
                    inactiveColor: Colors.grey,
                  ),
                  animationDuration: Duration(milliseconds: 900),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: GestureDetector(
                onTap: _resendVisible ? _resendCode : null,
                child: Text(
                  'Didn\'t receive OTP? Resend',
                  style: TextStyle(
                    color: _resendVisible ? Colors.blue : Colors.grey,
                    decoration:
                        _resendVisible ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectLanguageScreen(),
                    ),
                  );
                  // Submit OTP action
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                ),
                child: Text('Submit'),
              ),
            ),
            Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to Terms and Policy
                },
                child: Text(
                  'By signing up you agree to our terms and policy',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resendCode() {
    setState(() {
      _resendVisible = false;
      _controller.reset();
      _controller.reverse(from: 1.0);
    });
  }
}
