// import 'package:flutter/material.dart';
// import 'package:maha_kundali_app/apiManager/apiData.dart';
// import 'package:maha_kundali_app/screens/Book%20Puja/astrologers_model.dart';
// import 'package:maha_kundali_app/screens/Book%20Puja/bookPuja.dart';
// import 'package:maha_kundali_app/service/serviceManager.dart';
// import 'package:shimmer/shimmer.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class SelectAstrologerListScreen extends StatefulWidget {
//   String pujaName;
//   SelectAstrologerListScreen({required this.pujaName});
//   @override
//   _SelectAstrologerListScreenState createState() =>
//       _SelectAstrologerListScreenState();
// }

// class _SelectAstrologerListScreenState
//     extends State<SelectAstrologerListScreen> {
//   late Future<List<Astrologer>> _futureAstrologers;

//   @override
//   void initState() {
//     super.initState();
//     _futureAstrologers = fetchAstrologers();
//   }

//   Future<List<Astrologer>> fetchAstrologers() async {
//     String url = APIData.login;
//     print(url.toString());
//     final response = await http.post(Uri.parse(url), body: {
//       'action': 'select-astrologer',
//       'service_type': 'pooja',
//       // 'authorizationToken': ServiceManager.tokenID,
//       'name': widget.pujaName
//     });
//     print(response.body);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final astrologerList = data['astrologer_list_for_pooja'] as List;
//       final skills = data['skills'];
//       final languages = data['langs'];

//       return astrologerList.map((astrologerJson) {
//         final astrologerId = astrologerJson['astrologer_id'];
//         final astrologerSkills = (skills[astrologerId] as List)
//             .map((s) => s['name'] as String)
//             .toList();
//         final astrologerLanguages = (languages[astrologerId] as List)
//             .map((l) => l['name'] as String)
//             .toList();

//         return Astrologer.fromJson(
//             astrologerJson, astrologerSkills, astrologerLanguages);
//       }).toList();
//     } else {
//       throw Exception('Failed to load astrologers');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Astrologers for Pooja'),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.orange, Colors.red],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: FutureBuilder<List<Astrologer>>(
//         future: _futureAstrologers,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildShimmer();
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No astrologers found'));
//           }

//           final astrologers = snapshot.data!;

//           return GridView.builder(
//             padding: const EdgeInsets.all(8.0),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 1,
//               crossAxisSpacing: 8.0,
//               mainAxisSpacing: 8.0,
//             ),
//             itemCount: astrologers.length,
//             itemBuilder: (context, index) {
//               final astrologer = astrologers[index];
//               return _buildAstrologerCard(astrologer);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildShimmer() {
//     return GridView.builder(
//       padding: const EdgeInsets.all(8.0),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//       ),
//       itemCount: 6,
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   blurRadius: 6,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             margin: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 120,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius:
//                         const BorderRadius.vertical(top: Radius.circular(8.0)),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: 16,
//                         color: Colors.grey[200],
//                       ),
//                       const SizedBox(height: 8.0),
//                       Container(
//                         height: 14,
//                         color: Colors.grey[200],
//                       ),
//                       const SizedBox(height: 8.0),
//                       Container(
//                         height: 14,
//                         color: Colors.grey[200],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAstrologerCard(Astrologer astrologer) {
//     return Card(
//       color: const Color.fromARGB(255, 255, 239, 204),
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius:
//                 const BorderRadius.vertical(top: Radius.circular(12.0)),
//             child: Image.network(
//               astrologer.logo,
//               height: 180, // Increased height
//               width: double.infinity,
//               fit: BoxFit.contain,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   astrologer.name,
//                   style: const TextStyle(
//                     fontSize: 18.0, // Increased font size
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange,
//                   ),
//                 ),
//                 const SizedBox(height: 6.0), // Increased spacing
//                 Text(
//                   'Puja Price: ₹${astrologer.price}',
//                   style: TextStyle(
//                     fontSize: 16.0, // Increased font size
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 6.0), // Increased spacing
//                 Text(
//                   'Experience: ${astrologer.experience}',
//                   style: TextStyle(
//                     fontSize: 16.0, // Increased font size
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 12.0),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Handle the select action
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => BookingPujaScreen()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange, // Background color
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 12.0),
//                       elevation: 4.0,
//                     ),
//                     child: const Text(
//                       'Select',
//                       style: TextStyle(fontSize: 16.0), // Increased font size
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Book%20Puja/astrologers_model.dart';
import 'package:maha_kundali_app/screens/Book%20Puja/bookPuja.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SelectAstrologerListScreen extends StatefulWidget {
  final String pujaName;
  SelectAstrologerListScreen({required this.pujaName});

  @override
  _SelectAstrologerListScreenState createState() =>
      _SelectAstrologerListScreenState();
}

class _SelectAstrologerListScreenState
    extends State<SelectAstrologerListScreen> {
  late Future<List<Astrologer>> _futureAstrologers;
  String? astroId;

  @override
  void initState() {
    super.initState();
    _futureAstrologers = fetchAstrologers();
  }

  Future<List<Astrologer>> fetchAstrologers() async {
    String url = APIData.login;
    print(url.toString());

    final response = await http.post(Uri.parse(url), body: {
      'action': 'select-astrologer',
      'service_type': 'pooja',
      // 'authorizationToken': ServiceManager.tokenID,
      'name': widget.pujaName
    });

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final astrologerList = data['astrologer_list_for_pooja'] as List;

      return astrologerList.map((astrologerJson) {
        final details = astrologerJson['Details'];
        final astrologerId = details['astrologer_id'];
        setState(() {
          astroId = astrologerId;
        });

        // Extract skills and languages from the astrologer JSON
        final astrologerSkills = (astrologerJson['skills'] as List)
            .map((s) => s['name'] as String)
            .toList();
        final astrologerLanguages = (astrologerJson['langs'] as List)
            .map((l) => l['name'] as String)
            .toList();

        // Create and return an Astrologer object
        return Astrologer.fromJson(
          details,
          astrologerSkills,
          astrologerLanguages,
        );
      }).toList();
    } else {
      throw Exception('Failed to load astrologers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrologers for Pooja'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Astrologer>>(
        future: _futureAstrologers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmer();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No astrologers found'));
          }

          final astrologers = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: astrologers.length,
            itemBuilder: (context, index) {
              final astrologer = astrologers[index];
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 8.0), // Add space between cards
                child: _buildAstrologerCard(astrologer),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        color: Colors.grey[200],
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 14,
                        color: Colors.grey[200],
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 14,
                        color: Colors.grey[200],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAstrologerCard(Astrologer astrologer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.orange, // Orange border
          width: 1.5, // Adjust width as needed
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Verified Icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  astrologer.logo,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12.0),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  astrologer.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(Icons.price_check, color: Colors.orange, size: 16),
                    const SizedBox(width: 4.0),
                    Text(
                      '₹${astrologer.price}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4.0),
                    Text(
                      '${astrologer.experience} yrs',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Select Button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingPujaScreen(
                    pujaName: widget.pujaName,
                    astrologerId: astrologer.id,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 1,
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            ),
            child: const Text(
              'Select',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
