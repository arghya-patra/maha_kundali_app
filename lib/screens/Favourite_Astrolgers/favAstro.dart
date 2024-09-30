import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class FavoriteAstrologersScreen extends StatefulWidget {
  @override
  State<FavoriteAstrologersScreen> createState() =>
      _FavoriteAstrologersScreenState();
}

class _FavoriteAstrologersScreenState extends State<FavoriteAstrologersScreen> {
  Future<List<dynamic>> fetchFavoriteAstrologers() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'favorite-astrologers',
      'authorizationToken': ServiceManager.tokenID
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['isSuccess']) {
        return data['favorite_astrologer_list'];
      } else {
        throw Exception('Failed to load favorite astrologers');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Astrologers'),
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
      body: FutureBuilder<List<dynamic>>(
        future: fetchFavoriteAstrologers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite astrologers found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final astrologer = snapshot.data![index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        // Navigate to astrologer's details screen
                      },
                      child: Row(
                        children: [
                          // Avatar section
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(astrologer['logo']),
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                          // Info section
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    astrologer['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Added on: ${astrologer['added_on']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Call to action icon
                          // const Padding(
                          //   padding: EdgeInsets.only(right: 12.0),
                          //   child: Icon(
                          //     Icons.arrow_forward_ios,
                          //     color: Colors.orangeAccent,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
