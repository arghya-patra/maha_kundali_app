import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/Authentication/registration.dart';
import 'package:maha_kundali_app/screens/Home/dashboardScreen.dart';
import 'package:maha_kundali_app/screens/Profile_details_register/register_profile.dart';

class SelectLanguageScreen extends StatefulWidget {
  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  String _selectedLanguage = '';

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिंदी'},
    // {'code': 'bn', 'name': 'বাংলা'},
    // {'code': 'ta', 'name': 'தமிழ்'},
    // {'code': 'te', 'name': 'తెలుగు'},
    // {'code': 'gu', 'name': 'ગુજરાતી'},
    // {'code': 'mr', 'name': 'मराठी'},
    // {'code': 'pa', 'name': 'ਪੰਜਾਬੀ'},
    // {'code': 'ml', 'name': 'മലയാളം'},
    // {'code': 'kn', 'name': 'ಕನ್ನಡ'},
    // {'code': 'or', 'name': 'ଓଡ଼ିଆ'},
    // {'code': 'as', 'name': 'অসমীয়া'},
    // {'code': 'ur', 'name': 'اردو'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
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
              'Please select your language',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _languages.map((language) {
                return ChoiceChip(
                  label: Text(language['name']!),
                  selected: _selectedLanguage == language['code'],
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedLanguage = selected ? language['code']! : '';
                    });
                  },
                  selectedColor: Colors.orange.withOpacity(0.7),
                  labelStyle: TextStyle(
                    color: _selectedLanguage == language['code']
                        ? Colors.white
                        : Colors.black,
                  ),
                );
              }).toList(),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedLanguage.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()
                            //DashboardScreen()
                            ));
                    // (route) => false);
                    print('Selected language: $_selectedLanguage');
                    // Perform submit action
                  }
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
          ],
        ),
      ),
    );
  }
}
