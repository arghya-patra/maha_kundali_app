import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Numerology/num_model.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Numerology/numerology_details.dart';
import 'package:maha_kundali_app/screens/Personal%20Horoscope/personal_hor_details.dart';
import 'package:maha_kundali_app/screens/Personal%20Horoscope/personal_horoscope_model.dart';
import 'package:maha_kundali_app/screens/All_Free_service/panchang/panchangScreen.dart';
import 'package:maha_kundali_app/screens/All_Free_service/panchang/panchang_model.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
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
  String selectedGender = "Male";
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  HoroscopeResponse? horoscopeResponse;
  late Future<NumerologyResponse> futureNumerology;
  bool isLoading = true;
  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<NumerologyResponse> submitData() async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'free-service-type',
      'authorizationToken': ServiceManager.tokenID,
      'type': 'numerology',
      'name': _nameController.text,
      'dob': formattedDate,
      'lang': selectedLanguage == "English" ? 'en' : 'hi'
    });
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
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
      body: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 200, color: Colors.white),
                  const SizedBox(height: 20),
                  Container(height: 30, width: 200, color: Colors.white),
                  const SizedBox(height: 10),
                  Container(height: 15, color: Colors.white),
                  const SizedBox(height: 5),
                  Container(height: 15, width: 150, color: Colors.white),
                  const SizedBox(height: 30),
                  Container(height: 50, color: Colors.white),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Enter Name'),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text("Gender: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Radio(
                              value: "Male",
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value.toString();
                                });
                              },
                            ),
                            const Text("Male"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: "Female",
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value.toString();
                                });
                              },
                            ),
                            const Text("Female"),
                          ],
                        ),
                      ],
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
                          if (_nameController.text.isEmpty) {
                            _showError("Please enter your name.");
                            return;
                          }
                          if (formattedDate == "") {
                            _showError("Please select your date of birth.");
                            return;
                          }
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
