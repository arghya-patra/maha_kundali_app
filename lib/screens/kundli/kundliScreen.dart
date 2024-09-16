import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
        _isLoading = false;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _placeController.dispose();
    _dateController.dispose();
    _timeController.dispose();
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
      'pob': _placeController.text,
      'lang': 'en',
      'city': '',
      'lat': '22.54111111',
      'lon': '8.33777778'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kundli Details'),
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
                      "What is Kundli?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Kundli is a detailed chart that represents the positioning of stars and planets at the time of a person's birth.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Get Your Kundli?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _placeController,
                      decoration: const InputDecoration(
                        labelText: 'Place of Birth',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
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
                        labelText: 'Time of Birth',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () => _selectTime(context),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          submitData();
                          // Submit action and navigate to another screen
                        },
                        child: const Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
