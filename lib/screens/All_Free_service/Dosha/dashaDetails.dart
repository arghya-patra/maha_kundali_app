import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class DashaDetailsScreen extends StatefulWidget {
  String? name;
  String? dob;
  String? tob;
  String? pob;
  String? lat;
  String? lon;
  String? language;
  String? screen;
  String? gender;
  DashaDetailsScreen(
      {required this.name,
      required this.dob,
      required this.tob,
      required this.pob,
      required this.lat,
      required this.lon,
      required this.language,
      required this.screen,
      required this.gender});
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
        //'city': _selectedCity,
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
        centerTitle: true,
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
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
      return Center(child: Text("No data available"));
    }

    var mahaDasha = dashaData!["dasha"]["maha_dasha"]["response"];
    var yoginiDasha = dashaData!["dasha"]["yogini-dasha-main"]["response"];
    var antarDasha = dashaData!["dasha"]["antar_dasha"]["response"];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: 20),
          _buildTable(
            title: "Yogini Dasha",
            headers: ["Dasha", "End Date"],
            rows: List.generate(yoginiDasha["dasha_list"].length, (index) {
              return [
                yoginiDasha["dasha_list"][index],
                yoginiDasha["dasha_end_dates"][index]
              ];
            }),
          ),
          SizedBox(height: 20),
          _buildTable(
            title: "Antar Dasha",
            headers: ["Antar Dasha", "Start Date"],
            rows: List.generate(antarDasha["antardashas"].length, (index) {
              return [
                antarDasha["antardashas"][index].join(", "),
                antarDasha["antardasha_order"][index].join(", ")
              ];
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(
      {required String title,
      required List<String> headers,
      required List<List<String>> rows}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.orange, width: 1),
            ),
            columnWidths: {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.orange[300]),
                children: headers.map((header) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        header,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
              ...rows.map((row) {
                return TableRow(
                  decoration: BoxDecoration(color: Colors.orange[100]),
                  children: row.map((cell) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(cell, textAlign: TextAlign.center),
                    );
                  }).toList(),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
