import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/All_Free_service/panchang/panchangScreen.dart';
import 'package:maha_kundali_app/screens/All_Free_service/panchang/panchang_model.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:place_picker/place_picker.dart';

class PanchangFormScreen extends StatefulWidget {
  @override
  _PanchangFormScreenState createState() => _PanchangFormScreenState();
}

class _PanchangFormScreenState extends State<PanchangFormScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedHour = "1";
  String selectedMinute = "1";
  String selectedLanguage = "English";
  String selectedTimezone = "IST";
  String birthPlace = "kolkata";
  String formattedDate = "";
  String selectedGender = "Male";

  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Timer? _debounce;
  List<dynamic> _cities = [];
  String? _selectedCity;
  String? _selectedLat;
  String? _selectedLon;
  bool _isLoading = false;

  bool isLoading2 = true;
  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

    // _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = TimeOfDay.now();
      _timeController.text = now.format(context);
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading2 = false;
      });
    });
    _searchController.addListener(_onSearchChanged);
  }

  submitData() async {
    setState(() {
      isLoading2 = true;
    });
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'free-service-type',
      'authorizationToken': ServiceManager.tokenID,
      'type': 'panchang',
      'date': formattedDate,
      'hr': selectedHour,
      'min': selectedMinute,
      'pob': _selectedCity,
      'lang': selectedLanguage == "English" ? 'en' : 'hi',
      'lat': _selectedLat,
      'lon': _selectedLon
    });
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isLoading2 = false;
      });
      return Panchang.fromJson(
          jsonDecode(response.body)['panchang']['panchang']['response']);
    } else {
      throw Exception('Failed to load horoscope details');
    }
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

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _fetchCities(_searchController.text);
      }
    });
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
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Know Your Panchang"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading2
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
                    const SizedBox(height: 10),
                    _buildLabel('Name'),
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
                    _buildLabel('Select Date'),
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
                    _buildLabel('Select Time'),
                    TextField(
                      controller: _timeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
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

                    _buildLabel('Place of Birth'),

                    //----------

                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        labelText: 'Place of Birth',
                        border: const OutlineInputBorder(),
                        suffixIcon: _isLoading
                            ? const CircularProgressIndicator()
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                    color: Colors
                                        .grey, // Set the color of the border
                                    width: 1.0, // Set the width of the border
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Optional: Add rounded corners
                                ),
                                child: Text(
                                  city,
                                  style: const TextStyle(
                                      fontSize:
                                          16), // Customize text style if needed
                                ),
                              ),
                            );
                          },
                        ),
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
                    ),

                    // Dropdown list for city suggestions

                    // Display selected city's details
                    // if (_selectedCity != null)
                    //   Padding(
                    //     padding: const EdgeInsets.all(3.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Selected City: $_selectedCity'),
                    //         Text('Latitude: $_selectedLat'),
                    //         Text('Longitude: $_selectedLon'),
                    //       ],
                    //     ),
                    //   ),

                    //---------

                    // GestureDetector(
                    //   onTap: () async {},
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
                          if (_searchController.text.isEmpty ||
                              _selectedCity == null) {
                            _showError("Please select a place of birth.");
                            return;
                          }
                          if (formattedDate == "") {
                            _showError("Please select your date of birth.");
                            return;
                          }
                          if (_timeController.text.isEmpty) {
                            _showError("Please select your time of birth.");
                            return;
                          }
                          //submitData();
                          Panchang panchang = await submitData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PanchangScreen(
                                    name: _nameController.text,
                                    panchang: panchang)),
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
          EdgeInsets.symmetric(vertical: verticalHeight ?? 0, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
