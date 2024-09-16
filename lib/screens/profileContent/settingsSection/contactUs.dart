import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/buttons.dart';
import 'package:maha_kundali_app/screens/Home/dashboardScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:maha_kundali_app/theme/style.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCon = TextEditingController();

  final TextEditingController emailCon = TextEditingController();

  final TextEditingController phoneCon = TextEditingController();

  final TextEditingController msgCon = TextEditingController();
  final TextEditingController subCon = TextEditingController();
  String _name = '';
  String _email = '';
  String _phone = '';
  String _message = '';

  String _subject = '';
  bool isLoading = false;
  sendrequest() async {
    setState(() {
      isLoading = true;
    });

    String url = APIData.login;
    print(url);

    var res = await http.post(Uri.parse(url), body: {
      'action': 'contact-us',
      'authorizationToken': ServiceManager.tokenID,
      'name': nameCon.text,
      'email': emailCon.text,
      'mobile': phoneCon.text,
      'subject': subCon.text,
      'message': msgCon.text
    });
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thank you for contacting us!"),
        ),
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => false);

      //  var data = jsonDecode(res.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong!"),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });

    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
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
      body: Container(
        decoration: kBackgroundDesign(context),
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'We would love to hear from you!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildContactForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameCon,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onSaved: (value) => _name = value ?? '',
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: emailCon,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) => _email = value ?? '',
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: phoneCon,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.phone),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              // Regular expression for validating phone numbers
              String pattern = r'^(?:[+0]9)?[0-9]{10}$';
              RegExp regExp = RegExp(pattern);
              if (!regExp.hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            onSaved: (value) => _phone = value ?? '',
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: subCon,
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Subject';
              }
              return null;
            },
            onSaved: (value) => _subject = value ?? '',
          ),
          TextFormField(
            controller: msgCon,
            decoration: const InputDecoration(
              labelText: 'Message',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.message),
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
            onSaved: (value) => _message = value ?? '',
          ),
          const SizedBox(height: 80),
          isLoading == true
              ? LoadingButton()
              : KButton(
                  title: "Submit",
                  onClick: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      sendrequest();
                      // Handle form submission logic
                      print('Name: $_name');
                      print('Email: $_email');
                      print('Phone: $_phone');
                      print('Message: $_message');
                    }
                  }),
        ],
      ),
    );
  }
}
