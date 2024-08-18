import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:shimmer/shimmer.dart';

class PanchangScreen extends StatefulWidget {
  @override
  _PanchangScreenState createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedPlace;
  bool _isLoading = false;
  bool _showPanchangDetails = false;

  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  void _checkPanchang() {
    setState(() {
      _isLoading = true;
      _showPanchangDetails = false;
    });

    // Simulate a delay for loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _showPanchangDetails = true;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panchang'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Select Date
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          'Select Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: Colors.orange[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    // Select Place
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.orange[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        hint: const Text('Select Place'),
                        value: _selectedPlace,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPlace = newValue!;
                          });
                        },
                        items: _states
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    // Check Panchang Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: _checkPanchang,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Check Panchang',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 16.0,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                width: double.infinity,
                                height: 16.0,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                width: 100.0,
                                height: 16.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            else if (_showPanchangDetails)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Panchang Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPanchangTable(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanchangTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(3),
      },
      children: [
        _buildTableRow('Date', DateFormat.yMMMd().format(_selectedDate)),
        _buildTableRow('Place', _selectedPlace ?? 'Select Place'),
        _buildTableRow('Tithi', 'Shukla Paksha'),
        _buildTableRow('Nakshatra', 'Rohini'),
        _buildTableRow('Paksha', 'Krishna'),
        _buildTableRow('Yoga', 'Shiva'),
        _buildTableRow('Day', 'Wednesday'),
        _buildTableRow('Sunrise', '6:00 AM'),
        _buildTableRow('Sunset', '6:30 PM'),
        _buildTableRow('Moonrise', '8:00 PM'),
        _buildTableRow('Moonset', '8:30 AM'),
        _buildTableRow('Hindu Month', 'Shravana'),
        _buildTableRow('Hindu Day', 'Panchami'),
        _buildTableRow('Hindu Year', '2079 Vikram Samvat'),
      ],
    );
  }

  TableRow _buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
