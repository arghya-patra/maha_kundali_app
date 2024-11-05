import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Kundli/kundliDetails.dart';
import 'package:maha_kundali_app/screens/Kundli/kundliModel.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class KundliScreen extends StatefulWidget {
  @override
  _KundliScreenState createState() => _KundliScreenState();
}

class _KundliScreenState extends State<KundliScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String selectedLanguage = "English";
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<dynamic> _cities = [];
  String? _selectedCity;
  String? _selectedLat;
  String? _selectedLon;
  bool isLoading2 = true;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Simulating loading time
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading2 = false;
      });
      _animationController.forward();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _placeController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
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
        // _timeController.text = picked.format(context);
      });
    }
  }

  submitData() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'free-service-type',
      'authorizationToken': ServiceManager.tokenID,
      'type': 'kundali',
      'name': _nameController.text,
      'dob': _dateController.text,
      'tob': _timeController.text,
      'pob': _selectedCity,
      'lang': 'en',
      'lat': _selectedLat,
      'lon': _selectedLon
    });
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final basicDetails =
          BasicDetails.fromJson(data['horoscope']['basic_details']);
      final ascendantReport = AscendantReport.fromJson(
          data['horoscope']['ascendant_report']['response'][0]);
      final moonSign =
          MoonSign.fromJson(data['horoscope']['moonsign']['response']);
      final sunSign =
          SunSign.fromJson(data['horoscope']['sunsign']['response']);
      // final planetDetails = Map<String, PlanetDetails>.from(data['horoscope']
      //         ['planet_details']
      //     .map((k, v) => MapEntry(k, PlanetDetails.fromJson(v))));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KundliDetailsScreen(
            basicDetails: basicDetails,
            ascendantReport: ascendantReport,
            moonSign: moonSign,
            sunSign: sunSign,
            //planetDetails: planetDetails,
          ),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Know your Kundali'),
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
                    // Replace with actual Kundli image asset
                    const SizedBox(height: 20),
                    Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Image.asset('images/kundali.png'),
                      ),
                    ),
                    const Text(
                      "What is Kundali?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Kundali is a detailed chart that represents the positioning of stars and planets at the time of a person's birth.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Get Your Kundali?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
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
                    // const SizedBox(height: 20),
                    // TextField(
                    //   controller: _placeController,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Place of Birth',
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        labelText: 'Place of Birth',
                        border: OutlineInputBorder(),
                        suffixIcon:
                            _isLoading ? CircularProgressIndicator() : null,
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
                            return ListTile(
                              title: Text(city),
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
                            );
                          },
                        ),
                      ),

                    // Display selected city's details
                    if (_selectedCity != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Selected City: $_selectedCity'),
                            Text('Latitude: $_selectedLat'),
                            Text('Longitude: $_selectedLon'),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // _buildLabel('Select Language'),
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
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          submitData();
                          // Submit action and navigate to another screen
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFieldContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
