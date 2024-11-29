import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Authentication/login.dart';
import 'package:maha_kundali_app/screens/Home/userDashboardScreen.dart';
import 'package:maha_kundali_app/screens/HomeAstrologers/dashBoard_astro.dart';
import 'package:maha_kundali_app/screens/language_selection/language_selection.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;

class OtpVerificationScreen extends StatefulWidget {
  String? otp;
  bool isReg = false;
  String? mobile;
  OtpVerificationScreen(
      {super.key, this.otp, required this.isReg, this.mobile});
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _resendVisible = false;
  bool isLoading = false;
  TextEditingController _otpController = TextEditingController();
  String? otpText;

  @override
  void initState() {
    super.initState();
    otpText = widget.otp;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
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
        title: const Text('Otp verification'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              'Enter the code we have sent to ${widget.mobile}\n otp: ${otpText}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Text(
                    _timerText,
                    style: const TextStyle(fontSize: 20, color: Colors.orange),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _otpController,
                  autoDisposeControllers: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
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
                  animationDuration: const Duration(milliseconds: 900),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    sendOtp(context);
                  },
                  onChanged: (value) {},
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: GestureDetector(
                onTap: _resendVisible
                    ? () {
                        _resendCode();
                        loginUser(context);
                      }
                    : null,
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
            const SizedBox(height: 32),
            const Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to Terms and Policy
                },
                child: const Text(
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

  sendOtp(context) async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    var bodyReg = {
      'action': 'verify-register-otp',
      'authorizationToken': ServiceManager.tokenID,
      'otp': _otpController.text
    };
    var bodyLogin = {
      'action': 'verify-login-otp',
      'authorizationToken': ServiceManager.tokenID, //8100007581
      'otp': _otpController.text
    };
    var res = await http.post(Uri.parse(url),
        body: widget.isReg ? bodyReg : bodyLogin);
    var data = jsonDecode(res.body);
    if (data['status'] == 200) {
      try {
        if (widget.isReg == false) {
          print("***************");
          print(data);
          print("***************");

          ServiceManager()
              .setToken('${data['userDetails']['authorizationToken']}');
          ServiceManager().setRole('${data['userDetails']['user_type']}');
          ServiceManager().setUserLogo(data['userDetails']['logo']);
          ServiceManager().setUserName(data['userDetails']['name']);
          ServiceManager().getRole();
          ServiceManager().getUserName();
          if (ServiceManager.roleAs == 'buyer') {
            ServiceManager().getUserData();
          }
          ServiceManager().getUseLogo();
          if (ServiceManager.roleAs == 'buyer') {
            ServiceManager().setUser('${data['userDetails']['userId']}');
            ServiceManager.userID = '${data['userDetails']['userId']}';
          } else {
            ServiceManager().setUser('${data['userDetails']['user_id']}');
            ServiceManager.userID = '${data['userDetails']['user_id']}';
          }

          ServiceManager.tokenID =
              '${data['userDetails']['authorizationToken']}';
          ServiceManager.roleAs = '${data['userDetails']['user_type']}';
          ServiceManager.profileURL = '${data['userDetails']['logo']}';
          toastMessage(message: 'Logged In');
          print("&&&&&&&&&&&&&");
          print(ServiceManager.roleAs);
          print(ServiceManager.userID);
          print(ServiceManager.profileURL);
          print(ServiceManager.userName);
          print("&&&&&&&&&&&&&");
          ServiceManager.roleAs == 'buyer'
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserDashboardScreen()),
                  (route) => false)
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardForAstrologerScreen()),
                  (route) => false);
        } else {
          toastMessage(
              message: 'Registration Succesful! Please Login now',
              colors: Colors.green);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        }
      } catch (e) {
        toastMessage(message: e.toString());
        setState(() {
          isLoading = false;
        });
        // toastMessage(message: 'Something went wrong');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      toastMessage(message: data['message']);
    }
    setState(() {
      isLoading = false;
    });
    return 'Success';
  }

  Future<String> loginUser(context) async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    var res = await http.post(Uri.parse(url), body: {
      'action': 'login',
      'mobile': widget.mobile // mobile.text, //8100007581
    });
    var data = jsonDecode(res.body);

    if (data['status'] == 200) {
      try {
        toastMessage(message: 'Please check your mobile for OTP!');
        setState(() {
          otpText = data['otp'].toString();
        });
        ServiceManager().setToken('${data['authorizationToken']}');
        ServiceManager.tokenID = '${data['authorizationToken']}';
      } catch (e) {
        toastMessage(message: e.toString());
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      toastMessage(message: data['message']);
    }
    setState(() {
      isLoading = false;
    });
    return 'Success';
  }
}
