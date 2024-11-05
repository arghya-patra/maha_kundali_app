import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Numerology/num_model.dart';
import 'package:maha_kundali_app/screens/Numerology/numerology_details.dart';
import 'package:maha_kundali_app/screens/Personal%20Horoscope/personal_hor_details.dart';
import 'package:maha_kundali_app/screens/Personal%20Horoscope/personal_horoscope_model.dart';
import 'package:maha_kundali_app/screens/panchang/panchangScreen.dart';
import 'package:maha_kundali_app/screens/panchang/panchang_model.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:place_picker/place_picker.dart';

class NumerologyFormScreen extends StatefulWidget {
  @override
  _NumerologyFormScreenState createState() => _NumerologyFormScreenState();
}

class _NumerologyFormScreenState extends State<NumerologyFormScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedHour = "1";
  String selectedMinute = "1";
  String selectedLanguage = "English";
  String selectedTimezone = "IST";
  String birthPlace = "kolkata";
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  HoroscopeResponse? horoscopeResponse;
  late Future<NumerologyResponse> futureNumerology;

  String formattedDate = "";
  Future<NumerologyResponse> submitData() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'free-service-type',
      'authorizationToken': ServiceManager.tokenID,
      'type': 'numerology',
      'name': _nameController.text,
      'dob': formattedDate,
      'lang': 'en'
    });
    print(response.body);

    if (response.statusCode == 200) {
      return NumerologyResponse.fromJson(jsonDecode(response.body));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HoroscopeDetailScreen(
      //       horoscopeResponse: horoscopeResponse!,
      //     ),
      //   ),
      // );
    } else {
      throw Exception('Failed to load horoscope details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Know Your Numerology"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Enter Name'),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Date of Birth'),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: _buildFieldContainer(
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                    verticalHeight: 10.0),
              ),
              const SizedBox(height: 16),
              _buildLabel('Select Language'),
              _buildFieldContainer(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedLanguage,
                    underline: const SizedBox(),
                    items: ["English", "Hindi"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    },
                  ),
                  verticalHeight: 0.0),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    setState(() {
                      futureNumerology = submitData();
                    });
                    //submitData();
                    // NumerologyResponse numRes = await submitData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NumerologyDetailsScreen(
                              name: _nameController.text,
                              futureNumerology: futureNumerology)),
                    );
                    // Handle form submission
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
        print(formattedDate);
        print(selectedDate);
      });
    }
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFieldContainer({required Widget child, verticalHeight}) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(vertical: verticalHeight ?? 0, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
