import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class DashaDetailsScreen extends StatefulWidget {
  final String? name;
  final String? dob;
  final String? tob;
  final String? pob;
  final String? lat;
  final String? lon;
  final String? language;
  final String? screen;
  final String? gender;

  DashaDetailsScreen({
    required this.name,
    required this.dob,
    required this.tob,
    required this.pob,
    required this.lat,
    required this.lon,
    required this.language,
    required this.screen,
    required this.gender,
  });

  @override
  _DashaDetailsScreenState createState() => _DashaDetailsScreenState();
}

class _DashaDetailsScreenState extends State<DashaDetailsScreen> {
  Map<String, dynamic>? dashaData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashaDetails();
  }

  Future<void> fetchDashaDetails() async {
    String url = APIData.login; // Replace with your actual API URL
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'free-service-type',
        'authorizationToken': ServiceManager.tokenID,
        'type': 'dasha',
        'name': widget.name,
        'dob': widget.dob,
        'tob': widget.tob,
        'pob': widget.pob,
        'lang': widget.language == "English" ? 'en' : 'hi',
        'gender': widget.gender == "Male" ? 'm' : 'f',
        'lat': widget.lat,
        'lon': widget.lon
      });

      if (response.statusCode == 200) {
        setState(() {
          dashaData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dashaData?["title"] ?? "Dasha Details"),
        // centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: isLoading ? _buildShimmerEffect() : _buildDashaDetails(),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashaDetails() {
    if (dashaData == null) {
      return const Center(child: Text("No data available"));
    }

    var mahaDasha = dashaData!["dasha"]["maha_dasha"]["response"];
    var yoginiDasha = dashaData!["dasha"]["yogini-dasha-main"]["response"];
    var antarDasha = dashaData!["dasha"]["antar_dasha"]["response"];
    var currentMahaDasha =
        dashaData!["dasha"]["current_maha_dasha"]["response"];
    var currentAntarDasha =
        dashaData!["dasha"]["current_char_dasha"]["response"];
    var mainCharDashas = dashaData!["dasha"]["main_char_dashas"]["response"];
    var subCharDashas = dashaData!["dasha"]["sub_char_dashas"]["response"];

    return DefaultTabController(
      length: 6, // Number of tabs
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TabBar(
            isScrollable: true, // ✅ Makes tab names scrollable
            indicatorColor: Colors.deepOrange,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.black54,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabAlignment: TabAlignment.start,

            tabs: [
              Tab(text: "Maha Dasha"),
              Tab(text: "Yogini Dasha"),
              Tab(text: "Antar Dasha"),
              Tab(text: "Current Maha Dasha"),
              // Tab(text: "Current Antar Dasha"),
              Tab(text: "Main Char Dashas"),
              Tab(text: "Sub Char Dashas"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTable(
                  title: "Maha Dasha",
                  headers: ["Dasha", "Start Date"],
                  rows: List.generate(mahaDasha["mahadasha"].length, (index) {
                    return [
                      mahaDasha["mahadasha"][index],
                      mahaDasha["mahadasha_order"][index]
                    ];
                  }),
                ),
                _buildTable(
                  title: "Yogini Dasha",
                  headers: ["Dasha", "End Date"],
                  rows:
                      List.generate(yoginiDasha["dasha_list"].length, (index) {
                    return [
                      yoginiDasha["dasha_list"][index],
                      yoginiDasha["dasha_end_dates"][index]
                    ];
                  }),
                ),
                _buildTable(
                  title: "Antar Dasha",
                  headers: ["Antar Dasha", "Start Date"],
                  rows:
                      List.generate(antarDasha["antardashas"].length, (index) {
                    return [
                      antarDasha["antardashas"][index].join(", "),
                      antarDasha["antardasha_order"][index].join(", ")
                    ];
                  }),
                ),
                _buildTable(
                  title: "Current Maha Dasha",
                  headers: ["Dasha", "Start Date", "End Date"],
                  rows: [
                    [
                      currentMahaDasha["mahadasha"]["name"],
                      currentMahaDasha["mahadasha"]["start"],
                      currentMahaDasha["mahadasha"]["end"],
                    ],
                  ],
                ),
                // _buildTable(
                //   title: "Current Antar Dasha",
                //   headers: ["Dasha", "Start Date", "End Date"],
                //   rows: [
                //     [
                //       currentAntarDasha["antardasha"]["name"],
                //       currentAntarDasha["antardasha"]["start"],
                //       currentAntarDasha["antardasha"]["end"],
                //     ],
                //   ],
                // ),
                _buildTable(
                  title: "Main Char Dashas",
                  headers: ["Dasha", "Start Date", "End Date"],
                  rows: List.generate(mainCharDashas["dasha_list"].length,
                      (index) {
                    return [
                      mainCharDashas["dasha_list"][index],
                      mainCharDashas["start_date"],
                      mainCharDashas["dasha_end_dates"][index],
                    ];
                  }),
                ),
                _buildTable(
                  title: "Sub Char Dashas",
                  headers: ["Dasha", "Start Date", "End Date"],
                  rows: List.generate(subCharDashas.length, (index) {
                    return [
                      subCharDashas[index]["main_dasha"],
                      subCharDashas[index]["sub_dasha_start_date"],
                      subCharDashas[index]["sub_dasha_end_dates"].join(", "),
                    ];
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    // Dynamically set column widths
    Map<int, TableColumnWidth> columnWidths = {};
    if (headers.length == 2) {
      columnWidths = {
        0: const FlexColumnWidth(3),
        1: const FlexColumnWidth(3),
      };
    } else if (headers.length == 3) {
      columnWidths = {
        0: const FlexColumnWidth(2), // Name
        1: const FlexColumnWidth(2), // Start
        2: const FlexColumnWidth(3), // End (more space)
      };
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Table(
                border: TableBorder.symmetric(
                  inside: const BorderSide(color: Colors.orange, width: 1),
                ),
                columnWidths: columnWidths,
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(color: Colors.orange[300]),
                    children: headers.map((header) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          header,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                  // Data Rows
                  ...rows.map((row) {
                    return TableRow(
                      decoration: BoxDecoration(color: Colors.orange[100]),
                      children: row.map((cell) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              cell,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
