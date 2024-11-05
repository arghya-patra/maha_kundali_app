import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/match_Making/matchMakingModel.dart';
import 'package:maha_kundali_app/screens/match_Making/matchReport.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class KundliMatchingScreen extends StatefulWidget {
  @override
  _KundliMatchingScreenState createState() => _KundliMatchingScreenState();
}

class _KundliMatchingScreenState extends State<KundliMatchingScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _boyNameController = TextEditingController();
  final TextEditingController _boyDobController = TextEditingController();
  final TextEditingController _boyTimeController = TextEditingController();
  String boyFormattedDate = '';
  //final TextEditingController _boyPlaceController = TextEditingController();
  final TextEditingController _boysearchController = TextEditingController();

  final TextEditingController _girlNameController = TextEditingController();
  final TextEditingController _girlDobController = TextEditingController();
  String girlFormattedDate = '';
  final TextEditingController _girlTimeController = TextEditingController();
  final TextEditingController _girlsearchController = TextEditingController();

  bool _isLoading = false;
  bool _isLoading2 = true;
  late AnimationController _animationController;
  late Animation<double> _blinkAnimation;
  String selectedTimezone = "IST";
  int hour = 0;
  int minute = 0;

  Timer? _debounce;
  List<dynamic> _cities = [];
  String? _selectedBoyCity;
  String? _selectedBoyLat;
  String? _selectedBoyLon;
  String? _selectedGirlCity;
  String? _selectedGirlLat;
  String? _selectedGirlLon;
  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _blinkAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_animationController);

    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading2 = false;
      });
    });
    _boysearchController.addListener(_onBoySearchChanged);
    _girlsearchController.addListener(_onGirlSearchChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _boyNameController.dispose();
    _boyDobController.dispose();
    _boyTimeController.dispose();
    _boysearchController.removeListener(_onBoySearchChanged);
    _boysearchController.dispose();
    _girlNameController.dispose();
    _girlDobController.dispose();
    _girlTimeController.dispose();
    _girlsearchController.removeListener(_onGirlSearchChanged);
    _girlsearchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
        print(controller.text);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        final String formattedTime = picked.hour.toString().padLeft(2, '0') +
            ':' +
            picked.minute.toString().padLeft(2, '0');
        controller.text = formattedTime;
        print(formattedTime);
        // controller.text = picked.format(context);
        // print(controller.text);
        hour = picked.hour;
        minute = picked.minute;
      });
    }
  }

  void _onGirlSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_girlsearchController.text.isNotEmpty) {
        _fetchCities(_girlsearchController.text);
      }
    });
  }

  void _onBoySearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_boysearchController.text.isNotEmpty) {
        _fetchCities(_girlsearchController.text);
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
      'type': 'matchmaking',
      'boy_name': _boyNameController.text,
      'boy_dob': _boyDobController.text,
      'boy_tob': _boyTimeController.text,
      'boy_pob': _selectedBoyCity,
      'girl_name': _girlNameController.text,
      'girl_dob': _girlDobController.text,
      'girl_tob': _girlTimeController.text,
      'girl_pob': _selectedGirlCity,
      'lang': 'en',
      'boy_lat': '22.54111111',
      'boy_lon': '88.33777778',
      'girl_lat': '22.54111111',
      'girl_lon': '88.33777778'
    });
    print(response.body);

    if (response.statusCode == 200) {
      return Matchmaking.fromJson(jsonDecode(response.body)['matchmaking']);
    } else {
      throw Exception('Failed to load horoscope details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Love & Marriage'),
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
      body: _isLoading2
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kundli Matching",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Kundli Matching is a process that helps to match the horoscopes of the bride and groom before marriage.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  _buildFormSection(
                      title: "Enter Boy's Details",
                      nameController: _boyNameController,
                      dobController: _boyDobController,
                      timeController: _boyTimeController,
                      placeController: _boysearchController,
                      selectedCity: _selectedBoyCity,
                      selectedlat: _selectedBoyLat,
                      selectedlon: _selectedBoyLon),
                  const SizedBox(height: 20),
                  Center(
                    child: FadeTransition(
                      opacity: _blinkAnimation,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFormSection(
                      title: "Enter Girl's Details",
                      nameController: _girlNameController,
                      dobController: _girlDobController,
                      timeController: _girlTimeController,
                      placeController: _girlsearchController,
                      selectedCity: _selectedGirlCity,
                      selectedlat: _selectedGirlLat,
                      selectedlon: _selectedGirlLon),
                  const SizedBox(height: 30),
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
                  SizedBox(
                    height: 20,
                  ),
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
                        Matchmaking match = await submitData();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MatchmakingResultScreen(
                              matchmaking: match,
                            ),
                          ),
                        );
                        // Navigate to compatibility results screen
                      },
                      child: const Text(
                        'Check Compatibility',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
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
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }

  Widget _buildFormSection({
    required String title,
    required TextEditingController nameController,
    required TextEditingController dobController,
    required TextEditingController timeController,
    required TextEditingController placeController,
    selectedCity,
    selectedlat,
    selectedlon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 176, 184, 255),
              Color.fromARGB(255, 255, 191, 136)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, dobController),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Time of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () => _selectTime(context, timeController),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: placeController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Place of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: _isLoading ? CircularProgressIndicator() : null,
                ),
              ),
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
                            selectedCity = city;
                            selectedlat = lat;
                            selectedlon = lon;
                            placeController.text =
                                city; // Set the selected city
                            _cities.clear(); // Clear the dropdown
                          });
                        },
                      );
                    },
                  ),
                ),

              // Display selected city's details
              // if (selectedCity != null)
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text('Selected City: $selectedCity'),
              //         Text('Latitude: $selectedlat'),
              //         Text('Longitude: $selectedlon'),
              //       ],
              //     ),
              //   ),

              // TextField(
              //   controller: placeController,
              //   decoration: const InputDecoration(
              //     labelText: 'Place of Birth',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
