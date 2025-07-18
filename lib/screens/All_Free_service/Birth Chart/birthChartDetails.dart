import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class BirthChartScreen extends StatefulWidget {
  String? name;
  String? dob;
  String? tob;
  String? pob;
  String? lat;
  String? lon;
  String? language;
  String? gender;
  //--
  BirthChartScreen({
    super.key,
    required this.name,
    required this.dob,
    required this.tob,
    required this.pob,
    required this.lat,
    required this.lon,
    required this.language,
    required this.gender,
  });
  @override
  _BirthChartScreenState createState() => _BirthChartScreenState();
}

class _BirthChartScreenState extends State<BirthChartScreen> {
  String? svgData;
  bool isLoading = true;
  Map<String, dynamic>? chartData;
  String? title;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _fetchChartData();
    //  fetchBirthChart();
  }

  Future<void> _fetchChartData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String url = APIData.login;

      print(url.toString());
      print('Action: ${'free-service-type'}');
      print('Authorization Token: ${ServiceManager.tokenID}');
      print('Type: ${'birthchart'}');
      print('Name: ${widget.name}');
      print('Gender: ${widget.gender}');
      print('Date of Birth: ${widget.dob}');
      print('Time of Birth: ${widget.tob}');
      print('Place of Birth: ${widget.pob}');
      print('Language: ${widget.language}');
      print('Latitude: ${widget.lat}');
      print('Longitude: ${widget.lon}');
      final response = await http.post(Uri.parse(url), body: {
        'action': 'free-service-type',
        'authorizationToken': ServiceManager.tokenID,
        'type': 'birthchart',
        'name': widget.name,
        'gender': widget.gender,
        'dob': widget.dob,
        'tob': widget.tob,
        'pob': widget.pob,
        'lang': widget.language,
        'lat': widget.lat,
        'lon': widget.lon
      });
      if (response.statusCode == 200) {
        setState(() {
          var data = json.decode(response.body);
          print(["*&*&*&*&*&*&", data]);
          title = data['title'];
          print(["%%%%%%%%%%", data['chart']['Lagna']]);
          chartData = {
            'Lagna': data['chart']['Lagna'],
            'Dreshkana': data['chart']['Dreshkana'],
            'Somanatha': data['chart']['Somanatha'],
            'Saptamsa': data['chart']['Saptamsa'],
            'Navamsa': data['chart']['Navamsa'],
            'Dasamsa': data['chart']['Dasamsa'],
            'Dasamsa-EvenReverse': data['chart']['Dasamsa-EvenReverse'],
            'Dwadasamsa': data['chart']['Dwadasamsa'],
            'Shodashamsa': data['chart']['Shodashamsa'],
            'Vimsamsa': data['chart']['Vimsamsa'],
            'ChaturVimshamsha': data['chart']['ChaturVimshamsha'],
            'Trimshamsha': data['chart']['Trimshamsha'],
            'KhaVedamsa': data['chart']['KhaVedamsa'],
            'AkshaVedamsa': data['chart']['AkshaVedamsa'],
            'Shastiamsha': data['chart']['Shastiamsha']
          };
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final chartKeys = chartData?.keys.toList() ?? [];

    return DefaultTabController(
      length: chartKeys.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title ?? "Chart",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1.0,
            ),
          ),
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    // color: Color.fromARGB(255, 255, 166, 13),
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.deepOrange,
                      labelColor: Colors.deepOrange,
                      unselectedLabelColor: Colors.black54,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      tabAlignment: TabAlignment.start,
                      tabs: chartKeys
                          .map((key) => Tab(text: key.replaceAll('-', '\n')))
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: chartKeys.map((key) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: _buildChartWidget(key, chartData![key]),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildChartWidget(String title, String svgData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Render the SVG image using an SVG package (like flutter_svg)
          SvgPicture.string(
            svgData,
            height: 300, // Adjust the size as needed
            width: double.infinity,
            placeholderBuilder: (BuildContext context) =>
                const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}




// SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             // // Title Section
        //             // Text(
        //             //   widget.title ?? "Default Title",
        //             //   textAlign: TextAlign.center,
        //             //   style: const TextStyle(
        //             //     fontSize: 24,
        //             //     fontWeight: FontWeight.bold,
        //             //     color: Colors.black87,
        //             //     letterSpacing: 1.0,
        //             //   ),
        //             // ), // Spacing between title and subtitle

        //             // // Subtitle Section
        //             // Padding(
        //             //   padding: const EdgeInsets.symmetric(
        //             //       horizontal: 8.0, vertical: 2),
        //             //   child: Text(
        //             //     widget.subTitle ?? "Default Subtitle",
        //             //     textAlign: TextAlign.center,
        //             //     style: TextStyle(
        //             //       fontSize: 16,
        //             //       fontWeight: FontWeight.w500,
        //             //       color: Colors.grey.shade700,
        //             //       letterSpacing: 0.5,
        //             //     ),
        //             //   ),
        //             // ),
        //             const SizedBox(height: 10),
        //             Container(
        //               width: 100,
        //               height: 4,
        //               decoration: BoxDecoration(
        //                 color: Colors.deepOrangeAccent,
        //                 borderRadius: BorderRadius.circular(2),
        //               ),
        //             ),
        //           ],
        //         ),
        //         // Text(widget.subTitle!),
        //         svgData != null
        //             ? SvgPicture.string(
        //                 svgData!,
        //                 placeholderBuilder: (context) =>
        //                     const CircularProgressIndicator(),
        //               )
        //             : const Text('Failed to load birth chart'),
        //         // Padding(
        //         //   padding: const EdgeInsets.symmetric(
        //         //       horizontal: 8.0, vertical: 0),
        //         //   child: Text(
        //         //     widget.bottomText ?? "Default Subtitle",
        //         //     textAlign: TextAlign.center,
        //         //     style: TextStyle(
        //         //       fontSize: 16,
        //         //       fontWeight: FontWeight.w500,
        //         //       color: Colors.grey.shade700,
        //         //       letterSpacing: 0.5,
        //         //     ),
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //   ),