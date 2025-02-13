import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Dosha/doshaDetails.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';

class SavedKundalisScreen extends StatefulWidget {
  @override
  _SavedKundalisScreenState createState() => _SavedKundalisScreenState();
}

class _SavedKundalisScreenState extends State<SavedKundalisScreen> {
  List<Map<String, dynamic>> kundaliList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedKundalis();
  }

  Future<void> fetchSavedKundalis() async {
    final response = await http.post(Uri.parse(APIData.login), body: {
      'action': 'view-saved-kundali',
      'authorizationToken': ServiceManager.tokenID,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        kundaliList = List<Map<String, dynamic>>.from(data['list']);
        filteredList = kundaliList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList = kundaliList
          .where((item) =>
              item['save_name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Saved Kundalis",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: "Search Kundali by Name...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Kundali List
          Expanded(
            child: isLoading
                ? _buildShimmerEffect()
                : filteredList.isEmpty
                    ? _buildNoDataUI()
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          var item = filteredList[index];
                          return _buildKundaliTile(item);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Kundali List Tile UI
  Widget _buildKundaliTile(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepOrangeAccent,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          item['save_name'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          item['date'],
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoshaDetailsScreen(
                    name: '',
                    dob: '',
                    tob: '',
                    pob: '',
                    lat: '',
                    lon: '',
                    language: '',
                    saved: false,
                    screen: 'kun',
                    id: item['id'],
                    gender: '',
                    isByKundaliId: true)),
          );

          // Navigate to details screen (if needed)
        },
      ),
    );
  }

  // Shimmer Loading Effect
  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  // No Data UI
  Widget _buildNoDataUI() {
    return const Center(
      child: Text(
        "No Kundalis Found!",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
}
