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

class EditAstroProfileScreen extends StatefulWidget {
  @override
  _EditAstroProfileScreenState createState() => _EditAstroProfileScreenState();
}

class _EditAstroProfileScreenState extends State<EditAstroProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  String _profileImage = 'images/profile.jpeg'; // Initial profile image
  File? _image;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _alterMobileController = TextEditingController();
  final TextEditingController _serviceStartController = TextEditingController();
  final TextEditingController _callRateController = TextEditingController();
  final TextEditingController _chatRateController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  String _gender = 'Male';

  @override
  void initState() {
    super.initState();
    fullNameController.text = ServiceManager.userName;
    emailController.text = ServiceManager.userEmail;
    phoneNumberController.text = ServiceManager.userMobile;
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

      _nameController.text = '${data['userDetails']['name']}';
      _emailController.text = '${data['userDetails']['email']}';
      _mobileController.text = '${data['userDetails']['mobile']}';
      _gender = '${data['userDetails']['gender']}';
      _alterMobileController.text = '${data['userDetails']['alternateno']}';
      _serviceStartController.text = '${data['userDetails']['establish']}';
      _callRateController.text = '${data['userDetails']['call_rate']}';
      _chatRateController.text = '${data['userDetails']['chat_rate']}';
      _panController.text = '${data['userDetails']['panno']}';
      _aadharController.text = '${data['userDetails']['aadhar_no']}';
      _aboutController.text = '${data['userDetails']['company_desc']}';

      // profileURL = '${data['userDetails']['logo']}';
      // userMobile = data['userDetails']['mobile'] ?? '';
      setState(() {
        _isLoading = false;
      });
    } else {}
  }

  Future<void> upDateProfileData() async {
    setState(() {
      _isLoading = true;
    });

    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String mobile = _mobileController.text.trim();
    String alterNo = _alterMobileController.text.trim();
    String serviceStart = _serviceStartController.text.trim();
    String callRate = _callRateController.text.trim();
    String chatRate = _chatRateController.text.trim();
    String pan = _panController.text.trim();
    String aadhar = _aadharController.text.trim();
    String about = _aboutController.text.trim();

    String url = APIData.login;

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['action'] = 'buyer-profile'
      ..fields['authorizationToken'] = ServiceManager.tokenID
      ..fields['mobile'] = mobile
      ..fields['name'] = name
      ..fields['email'] = email
      ..fields['alternateno'] = alterNo
      ..fields['establish'] = serviceStart
      ..fields['call_rate'] = callRate
      ..fields['chat_rate'] = chatRate
      ..fields['panno'] = pan
      ..fields['aadhar_no'] = aadhar
      ..fields['company_desc'] = about;

    // Add the image file only if it's selected
    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('logo', _image!.path));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        if (jsonResponse['status'] == 200) {
          toastMessage(message: 'Profile Updated!', colors: Colors.green);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardForAstrologerScreen()),
            (route) => false,
          );
        } else {
          toastMessage(message: jsonResponse['message'], colors: Colors.red);
        }
      } else {
        toastMessage(
            message: 'Something went wrong. Please try again.',
            colors: Colors.red);
      }
    } catch (e) {
      toastMessage(message: 'Error: $e', colors: Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.orange),
                title: const Text('Camera'),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_album, color: Colors.orange),
                title: const Text('Gallery'),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCounterField(
      TextEditingController controller, String labelText) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            readOnly: true, // To prevent manual editing
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Decrement Button
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            int currentValue = int.parse(controller.text);
            if (currentValue > 1) {
              currentValue--;
              controller.text = currentValue.toString();
            }
          },
        ),
        // Increment Button
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            int currentValue = int.parse(controller.text);
            if (currentValue < 50) {
              currentValue++;
              controller.text = currentValue.toString();
            }
          },
        ),
      ],
    );
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
        title: const Text('Edit Profile'),
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
                    Stack(
                      children: [
                        _image == null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(ServiceManager.profileURL),
                                //FileImage(File(_image!.path))
                                //_image!=null? FileImage(File(_image.path)):AssetImage(_profileImage),

                                // backgroundImage: AssetImage(_profileImage),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(File(_image!.path))
                                //_image!=null? FileImage(File(_image.path)):AssetImage(_profileImage),

                                // backgroundImage: AssetImage(_profileImage),
                                ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImageSourceActionSheet,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  const Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //----

                    const SizedBox(height: 16),
                    _buildTextFields(_nameController, 'Name'),
                    const SizedBox(height: 16),
                    _buildTextFields(_emailController, 'Email',
                        isEmail: true, readOnly: true),
                    const SizedBox(height: 16),
                    _buildTextFields(_mobileController, 'Mobile Number',
                        readOnly: true, isNumber: true),
                    const SizedBox(height: 16),
                    _buildTextFields(
                        _alterMobileController, 'Alternate Mobile Number',
                        isNumber: true),
                    const SizedBox(height: 16),

                    _buildGenderSelection(),
                    const SizedBox(height: 16),
                    _buildTextFields(_panController, 'Pan Card Number',
                        readOnly: true, isNumber: true),
                    const SizedBox(height: 16),
                    _buildTextFields(_aadharController, 'Aadhar card  Number',
                        readOnly: true),
                    const SizedBox(height: 16),
                    _buildTextFields(_aboutController, 'About', maxLines: 5),

                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        upDateProfileData();
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

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(fontSize: 16.0),
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
        const SizedBox(width: 16), // Add spacing between radio buttons
      ],
    );
  }
}


// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:image_picker/image_picker.dart';

// class EditAstroProfileScreen extends StatefulWidget {
//   @override
//   _EditAstroProfileScreenState createState() => _EditAstroProfileScreenState();
// }

// class _EditAstroProfileScreenState extends State<EditAstroProfileScreen> {
//   final ImagePicker _picker = ImagePicker();
//   String _profileImage = 'images/profile.jpeg'; // Initial profile image
//   File? _image;

//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     // Simulate a loading delay
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   Future<void> _showImageSourceActionSheet() async {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.0),
//               topRight: Radius.circular(20.0),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Colors.orange),
//                 title: const Text('Camera'),
//                 onTap: () async {
//                   final pickedFile =
//                       await _picker.pickImage(source: ImageSource.camera);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _image = File(pickedFile.path);
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_album, color: Colors.orange),
//                 title: const Text('Gallery'),
//                 onTap: () async {
//                   final pickedFile =
//                       await _picker.pickImage(source: ImageSource.gallery);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _image = File(pickedFile.path);
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTextField(
//       {required String label,
//       required TextEditingController controller,
//       bool isPassword = false}) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fullNameController = TextEditingController();
//     final emailController = TextEditingController();
//     final phoneNumberController = TextEditingController();
//     final passwordController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.orange, Colors.deepOrange],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? Shimmer.fromColors(
//               baseColor: Colors.grey[300]!,
//               highlightColor: Colors.grey[100]!,
//               child: _buildShimmerEffect(),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       _image == null
//                           ? CircleAvatar(
//                               radius: 50,
//                               backgroundImage: AssetImage(_profileImage)
//                               //FileImage(File(_image!.path))
//                               //_image!=null? FileImage(File(_image.path)):AssetImage(_profileImage),

//                               // backgroundImage: AssetImage(_profileImage),
//                               )
//                           : CircleAvatar(
//                               radius: 50,
//                               backgroundImage: FileImage(File(_image!.path))
//                               //_image!=null? FileImage(File(_image.path)):AssetImage(_profileImage),

//                               // backgroundImage: AssetImage(_profileImage),
//                               ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: _showImageSourceActionSheet,
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.orange,
//                             ),
//                             padding: const EdgeInsets.all(8.0),
//                             child: const Icon(Icons.edit, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   _buildTextField(
//                       label: 'Full Name', controller: fullNameController),
//                   const SizedBox(height: 16),
//                   _buildTextField(label: 'Email', controller: emailController),
//                   const SizedBox(height: 16),
//                   _buildTextField(
//                       label: 'Phone Number', controller: phoneNumberController),
//                   const SizedBox(height: 16),
//                   _buildTextField(
//                       label: 'Password',
//                       controller: passwordController,
//                       isPassword: true),
//                   const SizedBox(height: 32),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle update functionality
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 50, vertical: 15),
//                       backgroundColor: Colors.orange,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     child: const Text('Update'),
//                   ),
//                   const Spacer(),
//                   const Text(
//                     'You joined on 2/22/2022',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   const SizedBox(height: 16),
//                   OutlinedButton(
//                     onPressed: () {
//                       // Handle delete account functionality
//                     },
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 50, vertical: 15),
//                       side: const BorderSide(color: Colors.red),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     child: const Text('Delete Account',
//                         style: TextStyle(color: Colors.red)),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildShimmerEffect() {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 50,
//           backgroundColor: Colors.grey[300],
//         ),
//         const SizedBox(height: 16),
//         Container(
//           height: 20,
//           width: double.infinity,
//           color: Colors.grey[300],
//         ),
//         const SizedBox(height: 16),
//         Container(
//           height: 20,
//           width: double.infinity,
//           color: Colors.grey[300],
//         ),
//         const SizedBox(height: 16),
//         Container(
//           height: 20,
//           width: double.infinity,
//           color: Colors.grey[300],
//         ),
//         const SizedBox(height: 16),
//         Container(
//           height: 20,
//           width: double.infinity,
//           color: Colors.grey[300],
//         ),
//         const SizedBox(height: 32),
//         Container(
//           height: 40,
//           width: double.infinity,
//           color: Colors.grey[300],
//         ),
//         const Spacer(),
//         Container(
//           height: 20,
//           width: 150,
//           color: Colors.grey[300],
//         ),
//         const SizedBox(height: 16),
//         Container(
//           height: 40,
//           width: double.infinity,
//           color: Colors.grey[300],
//         ),
//       ],
//     );
//   }
// }
