import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class BirthChartScreen extends StatefulWidget {
  String? svgData;
  String? subTitle;
  BirthChartScreen({required this.svgData, required this.subTitle});
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
        title: const Text('Birth Chart'),
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
            : Column(
                children: [
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [Colors.deepOrangeAccent, Colors.black],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                      },
                      child: Text(
                        widget.subTitle!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors
                              .white, // Required but gets overridden by ShaderMask
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black45,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Text(widget.subTitle!),
                  svgData != null
                      ? SvgPicture.string(
                          svgData!,
                          placeholderBuilder: (context) =>
                              const CircularProgressIndicator(),
                        )
                      : const Text('Failed to load birth chart'),
                ],
              ),
      ),
    );
  }
}
