import 'dart:async';
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

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<dynamic> _cities = [];
  String? _selectedCity;
  String? _selectedLat;
  String? _selectedLon;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _fetchCities(_searchController.text);
      }
    });
  }

  Future<void> _fetchCities(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(Uri.parse(APIData.login), body: {
        'action': 'get-city-name',
        'name': query,
      });

      // Log the response to check if it's valid
      print('Response: "${response.body}"'); // Log the response content
      print('Response: "${response.statusCode}"');

      if (response.body.isEmpty) {
        // Handle empty response
        print('Error: API returned an empty response');
        setState(() {
          _cities = [];
          _isLoading = false;
        });
        return;
      }

      if (response.statusCode == 200) {
        // Try decoding the response body
        try {
          final data = jsonDecode(response.body);

          if (data != null && data['city'] != null) {
            setState(() {
              _cities = data['city'];
              _isLoading = false;
            });
          } else {
            print('Error: "city" key not found in the response');
            setState(() {
              _cities = [];
              _isLoading = false;
            });
          }
        } catch (e) {
          print('Error decoding JSON: $e');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print(
            'Error: Failed to fetch cities, status code: ${response.statusCode}');
        setState(() {
          _cities = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _cities = [];
        _isLoading = false;
      });
    }
  }

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
      'pob': _selectedCity,
      'lang': 'en',
      'lat': _selectedLat,
      'lon': _selectedLon
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Enter Email'),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Enter Mobile'),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Mobile',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Select Date of Birth'),
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
              _buildLabel('Select Time of Birth'),
              TextField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                  verticalHeight: 1.0),
              const SizedBox(height: 16),
              _buildLabel('Place of Birth'),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Place of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: _isLoading ? CircularProgressIndicator() : null,
                ),
              ),
              const SizedBox(height: 10),

              // Dropdown list for city suggestions
              if (_cities.isNotEmpty)
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index]['city'];
                      final lat = _cities[index]['lat'];
                      final lon = _cities[index]['lon'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCity = city;
                            _selectedLat = lat;
                            _selectedLon = lon;
                            _searchController.text =
                                city; // Set the selected city
                            _cities.clear(); // Clear the dropdown
                          });
                        },
                        child: Container(
                          height: 50, // Set the desired height
                          padding: const EdgeInsets.all(
                              8.0), // Optional: Add padding for the text
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey, // Set the color of the border
                              width: 1.0, // Set the width of the border
                            ),
                            borderRadius: BorderRadius.circular(
                                5.0), // Optional: Add rounded corners
                          ),
                          child: Text(
                            city,
                            style: TextStyle(
                                fontSize: 16), // Customize text style if needed
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Display selected city's details
              if (_selectedCity != null)
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected City: $_selectedCity'),
                      Text('Latitude: $_selectedLat'),
                      Text('Longitude: $_selectedLon'),
                    ],
                  ),
                ),

              //----------------------------------------------------------------

              // GestureDetector(
              //   onTap: () async {
              //     // LocationResult result = await Navigator.of(context).push(
              //     //   MaterialPageRoute(
              //     //     builder: (context) => PlacePicker(
              //     //       "YOUR_GOOGLE_API_KEY",
              //     //     ),
              //     //   ),
              //     // );

              //     // setState(() {
              //     //   birthPlace = result.formattedAddress!;
              //     // });
              //   },
              //   child: _buildFieldContainer(
              //     child: Text(
              //       birthPlace.isEmpty ? "Pick a location" : birthPlace,
              //       style: const TextStyle(fontSize: 16),
              //     ),
              //   ),
              // ),
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
                  verticalHeight: 1.0),
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

  Widget _buildFieldContainer({required Widget child, verticalHeight}) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(vertical: verticalHeight ?? 10, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
