// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:maha_kundali_app/apiManager/apiData.dart';
// import 'package:maha_kundali_app/components/headerText.dart';
// import 'package:maha_kundali_app/service/serviceManager.dart';

// class HoroscopeDetailsScreen extends StatefulWidget {
//   final String zodiac;

//   HoroscopeDetailsScreen({required this.zodiac});

//   @override
//   _HoroscopeDetailsScreenState createState() => _HoroscopeDetailsScreenState();
// }

// class _HoroscopeDetailsScreenState extends State<HoroscopeDetailsScreen> {
//   late Future<Map<String, dynamic>> futureHoroscopeDetails;

//   @override
//   void initState() {
//     super.initState();
//     futureHoroscopeDetails = fetchHoroscopeDetails(widget.zodiac);
//   }

//   Future<Map<String, dynamic>> fetchHoroscopeDetails(String zodiac) async {
//     String url = APIData.login;
//     print(url.toString());
//     final response = await http.post(Uri.parse(url), body: {
//       'action': 'horoscope-detail',
//       'authorizationToken': ServiceManager.tokenID,
//       'zodiac': widget.zodiac,
//       //'lang': ''
//     });
//     print(response.body);

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load horoscope details');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Horoscope Details'),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: futureHoroscopeDetails,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text('No data available'));
//           }

//           final horoscopeDetails = snapshot.data!['myzodiac_details'];
//           final todayHoroscope = snapshot.data!['today'];

//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Zodiac Icon and Name
//                   Row(
//                     children: [
//                       Image.network(
//                         horoscopeDetails['icon'],
//                         width: 100,
//                         height: 100,
//                       ),
//                       const SizedBox(width: 10),
//                       animatedGradientText(
//                         text: horoscopeDetails['name'],
//                         gradient: const LinearGradient(
//                           colors: [
//                             Colors.orange,
//                             Color.fromARGB(255, 202, 121, 0)
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         fontSize: 28.0,
//                         duration: const Duration(seconds: 3),
//                       ),
//                       // Text(
//                       //   horoscopeDetails['name'],
//                       //   style: const TextStyle(
//                       //     fontSize: 24,
//                       //     fontWeight: FontWeight.bold,
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                   // const SizedBox(height: 10),

//                   // // Date Range
//                   // Text(
//                   //   'Date Range: ${horoscopeDetails['date_from']} - ${horoscopeDetails['date_to']}',
//                   //   style: const TextStyle(
//                   //       fontSize: 16, fontStyle: FontStyle.italic),
//                   // ),
//                   const SizedBox(height: 20),

//                   // Today's Horoscope Details
//                   const Text(
//                     'Today\'s Horoscope',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   _buildHoroscopeSection(
//                       'Lucky Color', todayHoroscope['lucky_color']),
//                   _buildHoroscopeSection('Lucky Number',
//                       todayHoroscope['lucky_number'].join(', ')),
//                   _buildHoroscopeSection(
//                       'Physique',
//                       todayHoroscope['bot_response']['physique']
//                           ['split_response']),
//                   _buildHoroscopeSection(
//                       'Status',
//                       todayHoroscope['bot_response']['status']
//                           ['split_response']),
//                   _buildHoroscopeSection(
//                       'Finances',
//                       todayHoroscope['bot_response']['finances']
//                           ['split_response']),
//                   _buildHoroscopeSection(
//                       'Relationship',
//                       todayHoroscope['bot_response']['relationship']
//                           ['split_response']),
//                   _buildHoroscopeSection(
//                       'Career',
//                       todayHoroscope['bot_response']['career']
//                           ['split_response']),
//                   _buildHoroscopeSection(
//                       'Travel',
//                       todayHoroscope['bot_response']['travel']
//                           ['split_response']),
//                   _buildHoroscopeSection(
//                       'Family',
//                       todayHoroscope['bot_response']['family']
//                           ['split_response']),
//                   _buildHoroscopeSection(
//                       'Friends',
//                       todayHoroscope['bot_response']['friends']
//                           ['split_response']),
//                   _buildHoroscopeSection(
//                       'Health',
//                       todayHoroscope['bot_response']['health']
//                           ['split_response']),
//                   _buildHoroscopeSection(
//                       'Total Score',
//                       todayHoroscope['bot_response']['total_score']
//                           ['split_response']),

//                   // More details
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Yearly Overview',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     horoscopeDetails['profession'],
//                     textAlign: TextAlign.justify,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     horoscopeDetails['luck'],
//                     textAlign: TextAlign.justify,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     horoscopeDetails['health'],
//                     textAlign: TextAlign.justify,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     horoscopeDetails['advice'],
//                     textAlign: TextAlign.justify,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     horoscopeDetails['business'],
//                     textAlign: TextAlign.justify,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     horoscopeDetails['money'],
//                     textAlign: TextAlign.justify,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     horoscopeDetails['love'],
//                     textAlign: TextAlign.justify,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildHoroscopeSection(String title, String detail) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           textAlign: TextAlign.justify,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           detail,
//           style: const TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 15),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HoroscopeDetailsScreen extends StatefulWidget {
  final String zodiac;

  HoroscopeDetailsScreen({required this.zodiac});
  @override
  _HoroscopeDetailsScreenState createState() => _HoroscopeDetailsScreenState();
}

class _HoroscopeDetailsScreenState extends State<HoroscopeDetailsScreen>
    with SingleTickerProviderStateMixin {
  Future<Map<String, dynamic>> fetchHoroscopeData() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'horoscope-detail',
      'authorizationToken': ServiceManager.tokenID,
      'zodiac': widget.zodiac,
      //'lang': ''
    });
    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load horoscope details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Horoscope Details'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Today"),
              Tab(text: "Tomorrow"),
              Tab(text: "Weekly"),
              Tab(text: "Yearly"),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.amber],
              ),
            ),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchHoroscopeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var data = snapshot.data!;
              return TabBarView(
                children: [
                  // Today Horoscope
                  _buildHoroscopeTab(data, data['today'], "Today's Horoscope"),
                  // Tomorrow Horoscope
                  _buildHoroscopeTab(
                      data, data['tomorrow'], "Tomorrow's Horoscope"),
                  // Weekly Horoscope
                  _buildHoroscopeTab(data, data['week'], "Weekly Horoscope"),
                  // Yearly Horoscope
                  _buildYearlyTab(data, data['year'], "Yearly Horoscope"),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Updated to include image and name
  Widget _buildHoroscopeTab(Map<String, dynamic> data,
      Map<String, dynamic> horoscopeData, String title) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Image and Name at the top
          Center(
            child: Column(
              children: [
                Image.network(
                  data['myzodiac_details']['icon'],
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(
                  data['myzodiac_details']['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text("Lucky Color: ${horoscopeData['lucky_color']}"),
          Text("Lucky Numbers: ${horoscopeData['lucky_number'].join(', ')}"),
          const SizedBox(height: 10),
          _buildBotResponseDetails(horoscopeData['bot_response']),
        ],
      ),
    );
  }

  // Updated to include image and name
  Widget _buildYearlyTab(Map<String, dynamic> data,
      Map<String, dynamic> yearlyData, String title) {
    List<String> phases = yearlyData.keys.toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Image and Name at the top
          Center(
            child: Column(
              children: [
                Image.network(
                  data['myzodiac_details']['icon'],
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(
                  data['myzodiac_details']['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...phases.map((phase) {
            var phaseDetails = yearlyData[phase];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${phaseDetails['period']}:"),
                Text("${phaseDetails['prediction']}"),
                const SizedBox(height: 10),
                _buildBotResponseDetails(phaseDetails),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  // Widget to build bot response details
  Widget _buildBotResponseDetails(Map<String, dynamic> botResponse) {
    List<String> keys = botResponse.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: keys.map((key) {
        var detail = botResponse[key];

        // Check if detail is a map, and contains the 'split_response' field
        if (detail is Map<String, dynamic> &&
            detail.containsKey('split_response')) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$key: ${detail['split_response']}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
            ],
          );
        } else {
          // If it's not a map or doesn't contain 'split_response', handle it as a string or another type
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$key: $detail", // Display the detail as a string or handle accordingly
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
            ],
          );
        }
      }).toList(),
    );
  }
}
