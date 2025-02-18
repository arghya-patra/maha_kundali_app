// import 'package:flutter/material.dart';
// import 'package:maha_kundali_app/apiManager/apiData.dart';
// import 'package:maha_kundali_app/service/serviceManager.dart';
// import 'package:shimmer/shimmer.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class SadeSatiScreen extends StatefulWidget {
//   String? name;
//   String? dob;
//   String? tob;
//   String? pob;
//   String? lat;
//   String? lon;
//   String? language;

//   String? gender;
//   SadeSatiScreen(
//       {required this.name,
//       required this.dob,
//       required this.tob,
//       required this.pob,
//       required this.lat,
//       required this.lon,
//       required this.language,
//       required this.gender});
//   @override
//   _SadeSatiScreenState createState() => _SadeSatiScreenState();
// }

// class _SadeSatiScreenState extends State<SadeSatiScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     fetchSadeSatiData(); // Call API on screen load
//   }

//   Future<Map<String, dynamic>> fetchSadeSatiData() async {
//     String url = APIData.login;

//     try {
//       final response = await http.post(Uri.parse(url), body: {
//         'action': 'free-service-type',
//         'authorizationToken': ServiceManager.tokenID,
//         'type': 'sade-sati',
//         'name': widget.name ?? "",
//         'dob': widget.dob ?? "",
//         'tob': widget.tob ?? "",
//         'pob': widget.pob ?? "",
//         'lang': widget.language == "English" ? 'en' : 'hi',
//         'gender': widget.gender == "Male" ? 'm' : 'f',
//         'lat': widget.lat ?? "",
//         'lon': widget.lon ?? "",
//         'page': 'sade-sati-table'
//       });

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);

//         if (responseData.containsKey('data') && responseData['data'] is List) {
//           return {
//             "content": {
//               "response": List<Map<String, dynamic>>.from(responseData['data'])
//             }
//           };
//         } else {
//           return {
//             "content": {"response": []}
//           }; // Return an empty list if no data
//         }
//       } else {
//         return {"error": "Failed to load Sade Sati data"};
//       }
//     } catch (e) {
//       return {"error": "Error fetching data: $e"};
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sade Sati Details"),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.orange, Colors.deepOrange],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: "Sade Sati Table"),
//             Tab(text: "Current Sade Sati"),
//           ],
//           indicatorColor: Colors.white,
//         ),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: fetchSadeSatiData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildShimmer();
//           } else if (snapshot.hasError) {
//             return const Center(child: Text("Error fetching data"));
//           } else {
//             var data = snapshot.data!;
//             return TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildSadeSatiTable(data["content"]["response"]),
//                 _buildCurrentSadeSati(data["content"]["response"]),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildSadeSatiTable(List sadeSatiData) {
//     return SingleChildScrollView(
//       child: DataTable(
//         columns: const [
//           DataColumn(label: Text("Zodiac")),
//           DataColumn(label: Text("Type")),
//           DataColumn(label: Text("Start Date")),
//           DataColumn(label: Text("End Date")),
//           DataColumn(label: Text("Dhaiya")),
//         ],
//         rows: sadeSatiData
//             .map((item) => DataRow(cells: [
//                   DataCell(Text(item["zodiac"])),
//                   DataCell(Text(item["type"])),
//                   DataCell(Text(item["start_date"])),
//                   DataCell(Text(item["end_date"])),
//                   DataCell(Text(item["dhaiya"])),
//                 ]))
//             .toList(),
//       ),
//     );
//   }

//   Widget _buildCurrentSadeSati(List sadeSatiData) {
//     if (sadeSatiData.isEmpty) {
//       return const Center(
//         child: Text(
//           "No Sade Sati data available",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       );
//     }

//     var currentPhase = sadeSatiData.last; // This is now safe

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         elevation: 5,
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Colors.orange, Colors.deepOrange],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("Current Sade Sati Phase",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold)),
//               const Divider(color: Colors.white),
//               _buildDetailRow("Zodiac", currentPhase["zodiac"]),
//               _buildDetailRow("Type", currentPhase["type"]),
//               _buildDetailRow("Start Date", currentPhase["start_date"]),
//               _buildDetailRow("End Date", currentPhase["end_date"]),
//               _buildDetailRow("Dhaiya", currentPhase["dhaiya"]),
//               _buildDetailRow("Direction", currentPhase["direction"]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label,
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold)),
//           Text(value, style: const TextStyle(color: Colors.white)),
//         ],
//       ),
//     );
//   }

//   Widget _buildShimmer() {
//     return ListView.builder(
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: ListTile(
//               title: Container(height: 10, color: Colors.white),
//               subtitle: Container(height: 10, color: Colors.white),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
