import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/buttons.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Authentication/login.dart';
import 'package:maha_kundali_app/screens/Authentication/otpVerification.dart';
import 'package:maha_kundali_app/screens/Authentication/registration.dart';
import 'package:maha_kundali_app/screens/profileContent/settingsSection/terms.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/theme/style.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Make sure to import the country_list_pick package

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isFormVisible = false;
  bool isLoading = false;

  String? selectedCountryCode = '+91';
  TextEditingController mobile = TextEditingController();

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
      backgroundColor: const Color.fromARGB(255, 255, 221, 170),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange,
                Color.fromARGB(255, 255, 234, 202),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: kBackgroundDesign(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Center(
                        child: Image.asset(
                          'images/ganesh.png',
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedOpacity(
                        opacity: _isFormVisible ? 1.0 : 0.0,
                        duration: const Duration(seconds: 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Login with your Mobile Number',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                // Country code picker
                                // Container(
                                //   child: CountryListPick(
                                //     onChanged: (CountryCode? code) {
                                //       setState(() {
                                //         selectedCountryCode = code!.dialCode;
                                //       });
                                //     },
                                //     initialSelection: '+91',
                                //     // useSafeArea: true,
                                //     // Add more customization if needed
                                //   ),
                                // ),
                                Image.asset(
                                  'images/indian_flag.jpeg', // Path to your India flag image
                                  height: 30, // Set the desired height
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  '+91', // Country code
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: mobile,
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 20),
                                        labelText: 'Enter Mobile Number',
                                        labelStyle: const TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        hintText: 'Enter Mobile Number',
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.orangeAccent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.orangeAccent,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        suffixIcon: const Icon(
                                          Icons.phone_iphone,
                                          color: Colors.orangeAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: isLoading != true
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (mobile.text.isEmpty) {
                                          toastMessage(
                                              message: 'Enter Phone Number');
                                        } else {
                                          loginUser(context);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 8,
                                        shadowColor: Colors.deepOrange,
                                        backgroundColor:
                                            const Color(0xFFFF7518),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 209, 126, 1),
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0,
                                          vertical: 15.0,
                                        ),
                                      ),
                                      child: const Text(
                                        'Send OTP',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : LoadingButton(),
                            ),
                            const SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                text: 'By signing up, you agree to our ',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Use',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TermsAndConditionsScreen(
                                                    action: 'terms-of-service',
                                                  )),
                                        );
                                        // _openWebView(context,
                                        //     'https://mahakundali.com/info/terms-of-service');
                                      },
                                  ),
                                  const TextSpan(
                                    text: ' and ',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TermsAndConditionsScreen(
                                                    action: 'privacy-policy',
                                                  )),
                                        );

                                        // _openWebView(context,
                                        //     'https://mahakundali.com/info/privacy-policy');
                                      },
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()),
                                );
                              },
                              child: const Text(
                                'Don\'t Have an account? Register Here!',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  //decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer Section
            Container(
              color: const Color.fromARGB(179, 255, 247, 239),
              child: const Column(
                children: [
                  Divider(color: Colors.grey, thickness: 2),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '100%',
                            style: TextStyle(
                              fontSize: 20, // Bigger font size for the number
                              fontWeight: FontWeight.bold, // Bold text
                              color: Colors.black54, // Text color
                            ),
                          ),
                          Text(
                            'Privacy\n ',
                            style: TextStyle(
                              fontSize: 14, // Smaller font size for the label
                              color: Colors.black54, // Text color
                            ),
                          ),
                        ],
                      ),

                      // Space between the columns
                      Column(
                        children: [
                          Text(
                            textAlign: TextAlign.end,
                            '2500+',
                            style: TextStyle(
                              fontSize: 20, // Bigger font size for the number
                              fontWeight: FontWeight.bold, // Bold text
                              color: Colors.black54, // Text color
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Certified\nAstrologers',
                            style: TextStyle(
                              fontSize: 14, // Smaller font size for the label
                              color: Colors.black54, // Text color
                            ),
                          ),
                        ],
                      ),
                      // VerticalDivider(
                      //   color: Colors.black, // Color of the divider
                      //   thickness: 1, // Thickness of the divider
                      //   width: 40, // Space to occupy
                      // ),
                      // const SizedBox(width: 40), // Space between the columns
                      Column(
                        children: [
                          Text(
                            textAlign: TextAlign.end,
                            '1 Cr+',
                            style: TextStyle(
                              fontSize: 20, // Bigger font size for the number
                              fontWeight: FontWeight.bold, // Bold text
                              color: Colors.black54, // Text color
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Happy\nCustomers',
                            style: TextStyle(
                              fontSize: 14, // Smaller font size for the label
                              color: Colors.black54, // Text color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url),
      ),
    );
  }

  Future<String> loginUser(context) async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    print(url.toString());
    var res = await http.post(Uri.parse(url), body: {
      'action': 'login',
      'mobile': mobile.text // mobile.text, //8100007581
    });
    var data = jsonDecode(res.body);

    if (data['status'] == 200) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please check your mobile for OTP!'),
          backgroundColor: Colors.green,
        ));
        ServiceManager().setToken('${data['authorizationToken']}');
        ServiceManager.tokenID = '${data['authorizationToken']}';
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                    mobile: mobile.text,
                    isReg: false,
                    otp: data['otp'].toString(),
                  )),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ));
        //toastMessage(message: e.toString());
        setState(() {
          isLoading = false;
        });
        toastMessage(message: 'Something went wrong');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(data['message']),
      ));
    }
    setState(() {
      isLoading = false;
    });
    return 'Success';
  }

  // Future<String> loginUser2(BuildContext context) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   String url = APIData.login;
  //   var res = await http
  //       .post(Uri.parse(url), body: {'action': 'login', 'mobile': mobile.text});
  //   var data = jsonDecode(res.body);
  //   print(res.body);
  //   if (data['status'] == 200) {
  //     try {
  //       toastMessage(message: 'Please check your mobile for OTP!');
  //       ServiceManager().setToken('${data['authorizationToken']}');
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => OtpVerificationScreen(
  //                   mobile: mobile.text,
  //                   isReg: false,
  //                   otp: data['otp'].toString(),
  //                 )),
  //         (route) => false,
  //       );
  //     } catch (e) {
  //       toastMessage(message: 'Something went wrong');
  //     } finally {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     toastMessage(message: data['message']);
  //   }

  //   return 'Success';
  // }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text(),
          ),
      body: WebViewWidget(controller: controller),
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:maha_kundali_app/apiManager/apiData.dart';
// import 'package:maha_kundali_app/components/buttons.dart';
// import 'package:maha_kundali_app/components/util.dart';
// import 'package:maha_kundali_app/screens/Authentication/login.dart';
// import 'package:maha_kundali_app/screens/Authentication/otpVerification.dart';
// import 'package:country_list_pick/country_list_pick.dart';
// import 'package:maha_kundali_app/screens/Authentication/registration.dart';
// import 'package:maha_kundali_app/screens/Profile_details_register/register_profile.dart';
// import 'package:maha_kundali_app/service/serviceManager.dart';
// import 'package:http/http.dart' as http;

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with TickerProviderStateMixin {
//   bool _isFormVisible = false;
//   bool isLoading = false;

//   String? selectedCountryCode = '+91';
//   TextEditingController mobile = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _startAnimation();
//   }

//   void _startAnimation() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     setState(() {
//       _isFormVisible = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 221, 170),
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Login'),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.deepOrange,
//                 Colors.orange,
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Opacity(
//             opacity: 0.08, // Adjust the opacity level here
//             child: Image.asset(
//               'images/ganesh.png', // Your image path
//               fit: BoxFit.cover, // To cover the entire background
//               height: double.infinity,
//               width: double.infinity,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 100.0, left: 16, right: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AnimatedOpacity(
//                   opacity: _isFormVisible ? 1.0 : 0.0,
//                   duration: const Duration(seconds: 1),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Image.asset(
//                       //   'images/ganesh.png',
//                       //   height: MediaQuery.of(context).size.height / 4,
//                       //   fit: BoxFit.fill,
//                       // ),
//                       const Text(
//                         'Login with your phone number',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 AnimatedContainer(
//                   duration: const Duration(seconds: 1),
//                   curve: Curves.easeInOut,
//                   child: _isFormVisible
//                       ? Row(
//                           children: [
//                             Container(
//                               //color: Colors.red,
//                               child: CountryListPick(
//                                 onChanged: (CountryCode? code) {
//                                   setState(() {
//                                     selectedCountryCode = code!.dialCode;
//                                   });
//                                 },
//                                 initialSelection: '+91',
//                                 useSafeArea: true,
//                               ),
//                             ),
//                             //  const SizedBox(width: 2),
//                             Expanded(
//                               child: TextField(
//                                 controller: mobile,
//                                 keyboardType: TextInputType.phone,
//                                 decoration: const InputDecoration(
//                                   labelText: 'Phone Number',
//                                   border: OutlineInputBorder(),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : const SizedBox.shrink(),
//                 ),
//                 const SizedBox(height: 32),
//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => RegistrationScreen()));
//                       // Navigator.push(context,
//                       //     MaterialPageRoute(builder: (context) => VideoCallScreen()));
//                     },
//                     child: const Text(
//                       'Don\'t Have an account? Register Here!',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 Center(
//                   child: isLoading != true
//                       ? ElevatedButton(
//                           onPressed: () {
//                             if (mobile.text.isEmpty) {
//                               toastMessage(message: 'Enter Phone Number');
//                             } else {
//                               loginUser(context);
//                             }
//                           },
//                           child: const Text('Send Otp'),
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.white,
//                             backgroundColor: Colors.orange,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30.0),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 50.0, vertical: 15.0),
//                           ),
//                         )
//                       : LoadingButton(),
//                 ),
//                 const Spacer(),
//                 // Center(
//                 //   child: Text(
//                 //     'Some other text as footer',
//                 //     style: Theme.of(context).textTheme.bodySmall,
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<String> loginUser(context) async {
//     setState(() {
//       isLoading = true;
//     });
//     String url = APIData.login;
//     print(url.toString());
//     var res = await http.post(Uri.parse(url), body: {
//       'action': 'login',
//       'mobile': mobile.text // mobile.text, //8100007581
//     });
//     var data = jsonDecode(res.body);

//     if (data['status'] == 200) {
//       print("______________________________________");
//       print(res.body);
//       print("______________________________________");
//       try {
//         print(data['status']);
//         print(data['authorizationToken']);
//         toastMessage(message: 'Please check your mobile for OTP!');
//         // print('${data['userInfo']['id']}');
//         // ServiceManager().setUser('${data['userInfo']['id']}');
//         ServiceManager().setToken('${data['authorizationToken']}');
//         // ServiceManager.userID = '${data['userInfo']['id']}';
//         ServiceManager.tokenID = '${data['authorizationToken']}';
//         // print(ServiceManager.roleAs);
//         // ServiceManager().getUserData();
//         // toastMessage(message: 'Logged In');
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => OtpVerificationScreen(
//                       mobile: mobile.text,
//                       isReg: false,
//                       otp: data['otp'].toString(),
//                     )),
//             (route) => false);
//       } catch (e) {
//         toastMessage(message: e.toString());
//         setState(() {
//           isLoading = false;
//         });
//         toastMessage(message: 'Something went wrong');
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       toastMessage(message: data['message']);
//     }
//     setState(() {
//       isLoading = false;
//     });
//     return 'Success';
//   }
// }
