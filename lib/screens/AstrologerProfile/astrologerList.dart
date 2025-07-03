// import 'package:flutter/material.dart';
// import 'package:maha_kundali_app/apiManager/apiData.dart';
// import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerProfileDetail.dart';
// import 'package:maha_kundali_app/service/serviceManager.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AstrologerListScreen extends StatefulWidget {
//   @override
//   _AstrologerListScreenState createState() => _AstrologerListScreenState();
// }

// class _AstrologerListScreenState extends State<AstrologerListScreen> {
//   List<String> _selectedChips = [];
//   List<String> _banners = [];

//   @override
//   void initState() {
//     super.initState();
//     _banners = [
//       'images/banner1.png',
//       'images/banner2.jpg',
//       'images/banner3.jpeg',
//     ];
//   }

//   // Stream for fetching astrologers data
//   Stream<List<Map<String, dynamic>>> _fetchAstrologers() async* {
//     while (true) {
//       String url = APIData.login;
//       print(url.toString());
//       try {
//         final response = await http.post(Uri.parse(url), body: {
//           'action': 'astrologer-list',
//           'authorizationToken': ServiceManager.tokenID
//         });
//         final data = json.decode(response.body);
//         print(response.body);

//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//           yield List<Map<String, dynamic>>.from(data['list'].map((item) {
//             return {
//               'user_id': item['Details']['user_id'],
//               'name': item['Details']['name'],
//               'establish': item['Details']['establish'],
//               'experience': item['Details']['experience'],
//               'call_rate': item['Details']['call_rate'],
//               'chat_rate': item['Details']['chat_rate'],
//               'logo': item['Details']['logo'],
//               'skills': List<String>.from(
//                   item['skills'].map((skill) => skill['name'])),
//               'langs':
//                   List<String>.from(item['langs'].map((lang) => lang['name'])),
//             };
//           }));
//         } else {
//           yield [];
//         }
//       } catch (e) {
//         yield [];
//       }
//       await Future.delayed(Duration(seconds: 10));
//     }
//   }

//   Widget _buildChipSection(List<String> skills) {
//     return Container(
//       height: 60.0,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: skills.map((skill) => _buildChip(skill)).toList(),
//       ),
//     );

//     //  Wrap(
//     //   children: skills.map((skill) => _buildChip(skill)).toList(),
//     // );
//   }

//   Widget _buildChip(String label) {
//     bool isSelected = _selectedChips.contains(label);
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: ChoiceChip(
//         label: Text(label),
//         selected: isSelected,
//         onSelected: (selected) {
//           setState(() {
//             if (isSelected) {
//               _selectedChips.remove(label);
//             } else {
//               _selectedChips.add(label);
//             }
//           });
//         },
//         selectedColor: Colors.orange,
//         backgroundColor: Colors.grey[200],
//         labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           side: BorderSide(
//             color: isSelected ? Colors.orange : Colors.grey,
//             width: 1,
//           ),
//         ),
//       ),
//     );
//   }

//   List<Map<String, dynamic>> _filterAstrologers(
//       List<Map<String, dynamic>> astrologers) {
//     if (_selectedChips.isEmpty) return astrologers;
//     return astrologers.where((astrologer) {
//       return astrologer['skills']
//           .any((skill) => _selectedChips.contains(skill));
//     }).toList();
//   }

//   Widget _buildBannerSlider() {
//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 150.0,
//         autoPlay: true,
//         enlargeCenterPage: true,
//       ),
//       items: _banners.map((banner) {
//         return Builder(
//           builder: (BuildContext context) {
//             return Container(
//               width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.symmetric(horizontal: 5.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.0),
//                 image: DecorationImage(
//                   image: AssetImage(banner),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Our Astrologer List'),
//         backgroundColor: Colors.deepOrange,
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _fetchAstrologers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildLoadingShimmer();
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error fetching data'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data available'));
//           } else {
//             final allSkills = List<String>.from(
//               snapshot.data!
//                   .expand((astrologer) => astrologer['skills'])
//                   .toSet(),
//             );
//             final filteredAstrologers = _filterAstrologers(snapshot.data!);

//             return Column(
//               children: [
//                 _buildChipSection(allSkills),
//                 Expanded(child: _buildAstrologerList(filteredAstrologers)),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildLoadingShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: CircleAvatar(backgroundColor: Colors.white),
//             title: Container(height: 20, color: Colors.white),
//             subtitle: Container(height: 15, color: Colors.white),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildAstrologerList(List<Map<String, dynamic>> astrologers) {
//     return ListView.builder(
//       itemCount: astrologers.length,
//       itemBuilder: (context, index) {
//         final astrologer = astrologers[index];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     AstrologerProfileScreen(id: astrologer['user_id']),
//               ),
//             );
//             print(astrologer['user_id']);
//           },
//           child: Card(
//             margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundImage: NetworkImage(astrologer['logo']),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           astrologer['name'],
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         SizedBox(height: 5),
//                         Text('${astrologer['experience']} Experience'),
//                         SizedBox(height: 5),
//                         Text('Skills: ${astrologer['skills'].join(', ')}'),
//                         SizedBox(height: 5),
//                         Text('Languages: ${astrologer['langs'].join(', ')}'),
//                         SizedBox(height: 5),
//                         Text('Call Rate: ₹${astrologer['call_rate']} / min'),
//                         Text('Chat Rate: ₹${astrologer['chat_rate']} / min'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
