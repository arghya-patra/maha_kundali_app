import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Personal%20Horoscope/personal_hor_details.dart';
import 'package:maha_kundali_app/screens/Personal%20Horoscope/personal_horoscope_model.dart';
import 'package:maha_kundali_app/screens/panchang/panchangScreen.dart';
import 'package:maha_kundali_app/screens/panchang/panchang_model.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:place_picker/place_picker.dart';

class PersonalHoroscopeFormScreen extends StatefulWidget {
  @override
  _PersonalHoroscopeFormScreenState createState() =>
      _PersonalHoroscopeFormScreenState();
}

class _PersonalHoroscopeFormScreenState
    extends State<PersonalHoroscopeFormScreen> {
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
  final TextEditingController _timeController = TextEditingController();

  String formattedDate = "";
  submitData() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'free-service-type',
      'authorizationToken': ServiceManager.tokenID,
      'type': 'horoscope',
      'name': _nameController.text,
      'dob': formattedDate,
      'tob': "$selectedHour:$selectedMinute",
      'pob': birthPlace,
      'lang': 'en',
      'lat': '22.54111111',
      'lon': '8.33777778'
    });
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        horoscopeResponse =
            HoroscopeResponse.fromJson(json.decode(response.body));
      });
      // Navigate to next screen after data is fetched
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HoroscopeDetailScreen(
            horoscopeResponse: horoscopeResponse!,
          ),
        ),
      );
    } else {
      throw Exception('Failed to load horoscope details');
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        final String formattedTime = picked.hour.toString().padLeft(2, '0') +
            ':' +
            picked.minute.toString().padLeft(2, '0');
        _timeController.text = formattedTime;
        print(formattedTime);
        selectedHour = picked.hour.toString();
        selectedMinute = picked.minute.toString();
        print("&^^^&");
        print(selectedHour);
        print(selectedMinute);

        print("&^^^&");

        // _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Know Your Personal Horoscope"),
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
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Enter Email'),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Enter Mobile'),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Mobile',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Select Date'),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: _buildFieldContainer(
                  child: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Select Hour'),
              TextField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Time of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () => _selectTime(context),
              ),
              // _buildFieldContainer(
              //   child: DropdownButton<String>(
              //     isExpanded: true,
              //     value: selectedHour,
              //     underline: const SizedBox(),
              //     items: List.generate(
              //       24,
              //       (index) => DropdownMenuItem(
              //         value: (index + 1).toString(),
              //         child: Text((index + 1).toString()),
              //       ),
              //     ),
              //     onChanged: (value) {
              //       setState(() {
              //         selectedHour = value!;
              //       });
              //     },
              //   ),
              // ),
              // const SizedBox(height: 16),
              // _buildLabel('Select Minute'),
              // _buildFieldContainer(
              //   child: DropdownButton<String>(
              //     isExpanded: true,
              //     value: selectedMinute,
              //     underline: const SizedBox(),
              //     items: List.generate(
              //       60,
              //       (index) => DropdownMenuItem(
              //         child: Text((index + 1).toString()),
              //         value: (index + 1).toString(),
              //       ),
              //     ),
              //     onChanged: (value) {
              //       setState(() {
              //         selectedMinute = value!;
              //       });
              //     },
              //   ),
              // ),
              const SizedBox(height: 16),
              _buildLabel('Reporting Language'),
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
              ),
              const SizedBox(height: 16),
              _buildLabel('Birth Place'),
              GestureDetector(
                onTap: () async {
                  // LocationResult result = await Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => PlacePicker(
                  //       "YOUR_GOOGLE_API_KEY",
                  //     ),
                  //   ),
                  // );

                  // setState(() {
                  //   birthPlace = result.formattedAddress!;
                  // });
                },
                child: _buildFieldContainer(
                  child: Text(
                    birthPlace.isEmpty ? "Pick a location" : birthPlace,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Timezone'),
              _buildFieldContainer(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedTimezone,
                  underline: const SizedBox(),
                  items: ["IST", "GMT", "PST", "EST"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTimezone = value!;
                    });
                  },
                ),
              ),
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
                    submitData();
                    // Panchang panchang = await submitData();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           PanchangScreen(panchang: panchang)),
                    // );
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
      lastDate: DateTime(2101),
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

  Widget _buildFieldContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
