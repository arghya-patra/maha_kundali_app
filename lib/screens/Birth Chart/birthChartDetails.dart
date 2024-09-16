import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class BirthChartScreen extends StatefulWidget {
  String? svgData;
  BirthChartScreen({required this.svgData});
  @override
  _BirthChartScreenState createState() => _BirthChartScreenState();
}

class _BirthChartScreenState extends State<BirthChartScreen> {
  String? svgData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    svgData = widget.svgData;
    isLoading = false;
    print("*************************");
    print(svgData);
    print("*************************");
    //  fetchBirthChart();
  }

  // Future<void> fetchBirthChart() async {
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://example.com/api/getBirthChart'), // Replace with your API URL
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = jsonDecode(response.body);
  //     setState(() {
  //       svgData = data['content'];
  //       isLoading = false;
  //     });
  //   } else {
  //     // Handle the error
  //     setState(() {
  //       isLoading = false;
  //     });
  //     throw Exception('Failed to load birth chart');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Birth Chart'),
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
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : svgData != null
                ? SvgPicture.string(
                    svgData!,
                    placeholderBuilder: (context) =>
                        CircularProgressIndicator(),
                  )
                : Text('Failed to load birth chart'),
      ),
    );
  }
}
