import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class BirthChartScreen extends StatefulWidget {
  String? svgData;
  String? subTitle;
  String? title;
  String? bottomText;
  BirthChartScreen(
      {required this.svgData,
      required this.subTitle,
      required this.title,
      required this.bottomText});
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
        title: const Text('Chart'),
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
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title Section
                        Text(
                          widget.title ?? "Default Title",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 1.0,
                          ),
                        ), // Spacing between title and subtitle

                        // Subtitle Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: Text(
                            widget.subTitle ?? "Default Subtitle",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    // Text(widget.subTitle!),
                    svgData != null
                        ? SvgPicture.string(
                            svgData!,
                            placeholderBuilder: (context) =>
                                const CircularProgressIndicator(),
                          )
                        : const Text('Failed to load birth chart'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0),
                      child: Text(
                        widget.bottomText ?? "Default Subtitle",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          letterSpacing: 0.5,
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
