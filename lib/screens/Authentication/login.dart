import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/buttons.dart';
import 'package:maha_kundali_app/components/customTextfield.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Authentication/forgotPass.dart';
import 'package:maha_kundali_app/screens/Authentication/registration.dart';
import 'package:maha_kundali_app/screens/Home/dashboardScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:maha_kundali_app/theme/style.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isObscure = true;
  bool isLoading = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: kBackgroundDesign(context),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            //  backgroundColor: Colors.purple[50],
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.orange.shade800,
              title: const Text('Login'),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade700, Colors.orange.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.symmetric(horizontal: 25.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        KTextField(
                          title: 'Phone',
                          controller: phone,
                          textInputType: TextInputType.phone,
                        ),
                        KTextField(
                          title: 'Password',
                          controller: password,
                          obscureText: isObscure,
                          suffixButton: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            icon: Icon(!isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: TextButton(
                                child: Text(
                                  "Forgotten Password?",
                                  style: linkTextStyle(context),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        isLoading != true
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DashboardScreen(),
                                    ),
                                  );
                                  // if (_formKey.currentState!.validate()) {
                                  //   setState(() {
                                  //     isLoading = true;
                                  //   });

                                  //   loginUser(context);
                                  // }
                                },
                                child: Text('Login'),
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
                        SizedBox(
                          height: 20,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(color: Colors.black54),
                            children: <TextSpan>[
                              TextSpan(text: 'Not a registered user ? '),
                              TextSpan(
                                text: 'Sign up',
                                style: linkTextStyle(context),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()));
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))

        //    SingleChildScrollView(
        //     child: Form(
        //       key: _formKey,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //           const SizedBox(height: 50),
        //           Image.asset(
        //             'images/logo.png',
        //             height: 100,
        //             width: 300,
        //           ),
        //           const SizedBox(height: 20),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 10),
        //             child: Text(
        //                 textAlign: TextAlign.center,
        //                 style: kHeaderStyle(color: Colors.blueGrey),
        //                 "Please enter your valid email address, we don't share it with anyone without your consent"),
        //           ),
        //           const SizedBox(height: 40),
        //           KTextField(
        //             title: 'Email',
        //             controller: email,
        //             textInputType: TextInputType.emailAddress,
        //           ),
        //           KTextField(
        //             title: 'Password',
        //             controller: password,
        //             obscureText: isObscure,
        //             suffixButton: IconButton(
        //               onPressed: () {
        //                 setState(() {
        //                   isObscure = !isObscure;
        //                 });
        //               },
        //               icon: Icon(!isObscure
        //                   ? Icons.visibility_off_outlined
        //                   : Icons.visibility),
        //             ),
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.end,
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(right: 12.0),
        //                 child: TextButton(
        //                   child: Text(
        //                     "Forgotten Password?",
        //                     style: linkTextStyle(context),
        //                   ),
        //                   onPressed: () {
        //                     // Navigator.push(
        //                     //   context,
        //                     //   MaterialPageRoute(
        //                     //     builder: (context) => ForgetPasswordScreen(),
        //                     //   ),
        //                     // );
        //                   },
        //                 ),
        //               )
        //             ],
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 10),
        //             child: RichText(
        //                 textAlign: TextAlign.center,
        //                 text: TextSpan(
        //                     style: TextStyle(
        //                         color:
        //                             Theme.of(context).textTheme.bodySmall!.color),
        //                     children: <TextSpan>[
        //                       const TextSpan(text: 'By continuing you agree to '),
        //                       TextSpan(
        //                         text: 'Terms of Use',
        //                         style: linkTextStyle(context),
        //                         recognizer: TapGestureRecognizer()
        //                           ..onTap = () {
        //                             // Navigator.push(
        //                             //     context,
        //                             //     MaterialPageRoute(
        //                             //         builder: (context) =>
        //                             //             AboutUsScreen()));
        //                           },
        //                       ),
        //                       const TextSpan(text: ' & '),
        //                       TextSpan(
        //                         text: 'Privacy Policy',
        //                         style: linkTextStyle(context),
        //                         recognizer: TapGestureRecognizer()
        //                           ..onTap = () {
        //                             // Navigator.push(
        //                             //     context,
        //                             //     MaterialPageRoute(
        //                             //         builder: (context) =>
        //                             //             AboutUsScreen()));
        //                           },
        //                       ),
        //                     ])),
        //           ),
        //           SizedBox(
        //             height: 10,
        //           ),
        //           RichText(
        //             textAlign: TextAlign.center,
        //             text: TextSpan(
        //               style: TextStyle(color: Colors.black54),
        //               children: <TextSpan>[
        //                 TextSpan(text: 'Not a registered user ? '),
        //                 TextSpan(
        //                   text: 'Sign up',
        //                   style: linkTextStyle(context),
        //                   recognizer: TapGestureRecognizer()
        //                     ..onTap = () {
        //                       // Navigator.push(
        //                       //     context,
        //                       //     MaterialPageRoute(
        //                       //         builder: (context) => Registration()));
        //                     },
        //                 ),
        //               ],
        //             ),
        //           ),
        //           SizedBox(
        //             height: 70,
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //   floatingActionButton: isLoading != true
        //       ? KButton(
        //           title: 'Login',
        //           onClick: () {
        //             if (_formKey.currentState!.validate()) {
        //               setState(() {
        //                 isLoading = true;
        //               });

        //               loginUser(context);
        //             }
        //           },
        //         )
        //       : LoadingButton(),
        // ),
        );
  }

  Future<String> loginUser(context) async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    print(url.toString());
    var res = await http.post(Uri.parse(url), body: {
      'email': phone.text,
      'password': password.text,
    });
    if (res.statusCode == 200) {
      print("______________________________________");
      print(res.body);
      print("______________________________________");
      var data = jsonDecode(res.body);
      try {
        print('${data['userInfo']['id']}');
        ServiceManager().setUser('${data['userInfo']['id']}');
        ServiceManager().setToken('${data['auth_token']}');
        ServiceManager.userID = '${data['userInfo']['id']}';
        ServiceManager.tokenID = '${data['auth_token']}';
        print(ServiceManager.roleAs);
        toastMessage(message: 'Logged In');
        // Navigator.pushAndRemoveUntil(context,
        //     MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } catch (e) {
        toastMessage(message: e.toString());
        setState(() {
          isLoading = false;
        });
        toastMessage(message: 'Something went wrong');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      toastMessage(message: 'Invalid email or password');
    }
    setState(() {
      isLoading = false;
    });
    return 'Success';
  }
}
