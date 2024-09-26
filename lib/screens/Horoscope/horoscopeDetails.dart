import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/headerText.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class HoroscopeDetailsScreen extends StatefulWidget {
  final String zodiac;

  HoroscopeDetailsScreen({required this.zodiac});

  @override
  _HoroscopeDetailsScreenState createState() => _HoroscopeDetailsScreenState();
}

class _HoroscopeDetailsScreenState extends State<HoroscopeDetailsScreen> {
  late Future<Map<String, dynamic>> futureHoroscopeDetails;

  @override
  void initState() {
    super.initState();
    futureHoroscopeDetails = fetchHoroscopeDetails(widget.zodiac);
  }

  Future<Map<String, dynamic>> fetchHoroscopeDetails(String zodiac) async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horoscope Details'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureHoroscopeDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          final horoscopeDetails = snapshot.data!['myzodiac_details'];
          final todayHoroscope = snapshot.data!['today'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Zodiac Icon and Name
                  Row(
                    children: [
                      Image.network(
                        horoscopeDetails['icon'],
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 10),
                      animatedGradientText(
                        text: horoscopeDetails['name'],
                        gradient: const LinearGradient(
                          colors: [
                            Colors.orange,
                            Color.fromARGB(255, 202, 121, 0)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        fontSize: 28.0,
                        duration: const Duration(seconds: 3),
                      ),
                      // Text(
                      //   horoscopeDetails['name'],
                      //   style: const TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                  // const SizedBox(height: 10),

                  // // Date Range
                  // Text(
                  //   'Date Range: ${horoscopeDetails['date_from']} - ${horoscopeDetails['date_to']}',
                  //   style: const TextStyle(
                  //       fontSize: 16, fontStyle: FontStyle.italic),
                  // ),
                  const SizedBox(height: 20),

                  // Today's Horoscope Details
                  const Text(
                    'Today\'s Horoscope',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildHoroscopeSection(
                      'Lucky Color', todayHoroscope['lucky_color']),
                  _buildHoroscopeSection('Lucky Number',
                      todayHoroscope['lucky_number'].join(', ')),
                  _buildHoroscopeSection(
                      'Physique',
                      todayHoroscope['bot_response']['physique']
                          ['split_response']),
                  _buildHoroscopeSection(
                      'Status',
                      todayHoroscope['bot_response']['status']
                          ['split_response']),
                  _buildHoroscopeSection(
                      'Finances',
                      todayHoroscope['bot_response']['finances']
                          ['split_response']),
                  _buildHoroscopeSection(
                      'Relationship',
                      todayHoroscope['bot_response']['relationship']
                          ['split_response']),
                  _buildHoroscopeSection(
                      'Career',
                      todayHoroscope['bot_response']['career']
                          ['split_response']),
                  _buildHoroscopeSection(
                      'Travel',
                      todayHoroscope['bot_response']['travel']
                          ['split_response']),
                  _buildHoroscopeSection(
                      'Family',
                      todayHoroscope['bot_response']['family']
                          ['split_response']),
                  _buildHoroscopeSection(
                      'Friends',
                      todayHoroscope['bot_response']['friends']
                          ['split_response']),
                  _buildHoroscopeSection(
                      'Health',
                      todayHoroscope['bot_response']['health']
                          ['split_response']),
                  _buildHoroscopeSection(
                      'Total Score',
                      todayHoroscope['bot_response']['total_score']
                          ['split_response']),

                  // More details
                  const SizedBox(height: 20),
                  const Text(
                    'Yearly Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    horoscopeDetails['profession'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    horoscopeDetails['luck'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    horoscopeDetails['health'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    horoscopeDetails['advice'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    horoscopeDetails['business'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    horoscopeDetails['money'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    horoscopeDetails['love'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHoroscopeSection(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          detail,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class HoroscopeDetailsScreen extends StatefulWidget {
//   @override
//   _HoroscopeDetailsScreenState createState() => _HoroscopeDetailsScreenState();
// }

// class _HoroscopeDetailsScreenState extends State<HoroscopeDetailsScreen> {
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     // Simulate a delay for the shimmer effect
//     Future.delayed(const Duration(seconds: 3), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Horoscope Details'),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.orange, Colors.red],
//             ),
//           ),
//         ),
//       ),
//       body: _isLoading ? _buildShimmer() : _buildContent(),
//     );
//   }

//   Widget _buildShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           Container(
//             height: 200,
//             color: Colors.grey[300],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             height: 20,
//             color: Colors.grey[300],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             height: 100,
//             color: Colors.grey[300],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             height: 100,
//             color: Colors.grey[300],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     return ListView(
//       padding: const EdgeInsets.all(16.0),
//       children: [
//         Container(
//           height: 250,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('images/libra_horos.webp'),
//               fit: BoxFit.fill,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         const Text(
//           'Horoscope Description',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         const Text(
//           'Here is a detailed description of the horoscope. This section will be populated with dynamic content fetched from an API in the future. For now, this is just placeholder text.',
//           style: TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 16),
//         _buildBulletPoint('First important point about the horoscope.'),
//         _buildBulletPoint('Second key detail that should be noted.'),
//         _buildBulletPoint(
//             'Another significant aspect related to this horoscope.'),
//         const SizedBox(height: 16),
//         const Text(
//           'This is a second paragraph with more detailed information. The content here can span multiple lines and include various details relevant to the horoscope. Again, this is placeholder text, and the real content will come from an API.',
//           style: TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }

//   Widget _buildBulletPoint(String text) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("• ", style: TextStyle(fontSize: 20)),
//         Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
//       ],
//     );
//   }
// }
