import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/All_Free_service/panchang/panchang_model.dart';

class PanchangScreen extends StatefulWidget {
  final String? name;
  final Panchang panchang;

  const PanchangScreen({required this.panchang, required this.name});

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Panchang of ${widget.name ?? ''}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          // centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Tithi'),
              Tab(text: 'Nakshatra'),
              Tab(text: 'Karana'),
              Tab(text: 'Yoga'),
              Tab(text: 'Advanced'),
            ],
          ),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.orange.shade50,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  _buildTitleSection(
                      'Day: ${widget.panchang.dayName}', Icons.calendar_today),
                ],
              ),
            ),
            const Divider(height: 0),
            Expanded(
              child: TabBarView(
                children: [
                  _buildScrollableSection('Tithi', [
                    _buildDetailItem('Name', widget.panchang.tithi.name),
                    _buildDetailItem('Start', widget.panchang.tithi.start),
                    _buildDetailItem('End', widget.panchang.tithi.end),
                    _buildDetailItem('Type', widget.panchang.tithi.type),
                    _buildDetailItem('Diety', widget.panchang.tithi.diety),
                    _buildDetailItem('Meaning', widget.panchang.tithi.meaning),
                    _buildDetailItem('Special', widget.panchang.tithi.special),
                  ]),
                  _buildScrollableSection('Nakshatra', [
                    _buildDetailItem('Name', widget.panchang.nakshatra.name),
                    _buildDetailItem('Start', widget.panchang.nakshatra.start),
                    _buildDetailItem('End', widget.panchang.nakshatra.end),
                    _buildDetailItem(
                        'Meaning', widget.panchang.nakshatra.meaning),
                    _buildDetailItem(
                        'Special', widget.panchang.nakshatra.special),
                    _buildDetailItem(
                        'Summary', widget.panchang.nakshatra.summary),
                  ]),
                  _buildScrollableSection('Karana', [
                    _buildDetailItem('Name', widget.panchang.karana.name),
                    _buildDetailItem('Start', widget.panchang.karana.start),
                    _buildDetailItem('End', widget.panchang.karana.end),
                    _buildDetailItem('Type', widget.panchang.karana.type),
                    _buildDetailItem('Special', widget.panchang.karana.special),
                  ]),
                  _buildScrollableSection('Yoga', [
                    _buildDetailItem('Name', widget.panchang.yoga.name),
                    _buildDetailItem('Start', widget.panchang.yoga.start),
                    _buildDetailItem('End', widget.panchang.yoga.end),
                    _buildDetailItem('Meaning', widget.panchang.yoga.meaning),
                    _buildDetailItem('Special', widget.panchang.yoga.special),
                  ]),
                  _buildScrollableSection('Advanced Details', [
                    _buildDetailItem(
                        'Sunrise', widget.panchang.advancedDetails.sunRise),
                    _buildDetailItem(
                        'Sunset', widget.panchang.advancedDetails.sunSet),
                    _buildDetailItem(
                        'Moonrise', widget.panchang.advancedDetails.moonRise),
                    _buildDetailItem(
                        'Moonset', widget.panchang.advancedDetails.moonSet),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Title with icon
  Widget _buildTitleSection(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
      ],
    );
  }

  // Scrollable Card Section
  Widget _buildScrollableSection(String title, List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: _buildCardSection(title, children),
    );
  }

  // Detail Item
  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Card Layout
  Widget _buildCardSection(String title, List<Widget> children) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.shade300,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info, color: Colors.orange.shade800, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: Colors.orange.shade400,
                thickness: 1.5,
                indent: 10,
                endIndent: 10,
              ),
              const SizedBox(height: 10),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:maha_kundali_app/screens/All_Free_service/panchang/panchang_model.dart';

// class PanchangScreen extends StatefulWidget {
//   String? name;
//   final Panchang panchang;

//   PanchangScreen({required this.panchang, required this.name});

//   @override
//   State<PanchangScreen> createState() => _PanchangScreenState();
// }

// class _PanchangScreenState extends State<PanchangScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Panchang Details'),
//         centerTitle: true,
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
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Panchang of ${widget.name!}",
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             _buildTitleSection(
//                 'Day: ${widget.panchang.dayName}', Icons.calendar_today),
//             _buildCardSection('Tithi', [
//               _buildDetailItem('Name', widget.panchang.tithi.name),
//               _buildDetailItem('Start', widget.panchang.tithi.start),
//               _buildDetailItem('End', widget.panchang.tithi.end),
//               _buildDetailItem('Type', widget.panchang.tithi.type),
//               _buildDetailItem('Diety', widget.panchang.tithi.diety),
//               _buildDetailItem('Meaning', widget.panchang.tithi.meaning),
//               _buildDetailItem('Special', widget.panchang.tithi.special),
//             ]),
//             SizedBox(height: 20),
//             _buildCardSection('Nakshatra', [
//               _buildDetailItem('Name', widget.panchang.nakshatra.name),
//               _buildDetailItem('Start', widget.panchang.nakshatra.start),
//               _buildDetailItem('End', widget.panchang.nakshatra.end),
//               _buildDetailItem('Meaning', widget.panchang.nakshatra.meaning),
//               _buildDetailItem('Special', widget.panchang.nakshatra.special),
//               _buildDetailItem('Summary', widget.panchang.nakshatra.summary),
//             ]),
//             SizedBox(height: 20),
//             _buildCardSection('Karana', [
//               _buildDetailItem('Name', widget.panchang.karana.name),
//               _buildDetailItem('Start', widget.panchang.karana.start),
//               _buildDetailItem('End', widget.panchang.karana.end),
//               _buildDetailItem('Type', widget.panchang.karana.type),
//               _buildDetailItem('Special', widget.panchang.karana.special),
//             ]),
//             SizedBox(height: 20),
//             _buildCardSection('Yoga', [
//               _buildDetailItem('Name', widget.panchang.yoga.name),
//               _buildDetailItem('Start', widget.panchang.yoga.start),
//               _buildDetailItem('End', widget.panchang.yoga.end),
//               _buildDetailItem('Meaning', widget.panchang.yoga.meaning),
//               _buildDetailItem('Special', widget.panchang.yoga.special),
//             ]),
//             SizedBox(height: 20),
//             _buildCardSection('Advanced Details', [
//               _buildDetailItem(
//                   'Sunrise', widget.panchang.advancedDetails.sunRise),
//               _buildDetailItem(
//                   'Sunset', widget.panchang.advancedDetails.sunSet),
//               _buildDetailItem(
//                   'Moonrise', widget.panchang.advancedDetails.moonRise),
//               _buildDetailItem(
//                   'Moonset', widget.panchang.advancedDetails.moonSet),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }

//   // Title Section with Icon
//   Widget _buildTitleSection(String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.orangeAccent, size: 30),
//         SizedBox(width: 10),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.deepOrange,
//           ),
//         ),
//       ],
//     );
//   }

//   // Section Title
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//         color: Colors.deepOrange,
//       ),
//     );
//   }

//   // Detail Item with bold title and regular value text
//   Widget _buildDetailItem(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$title: ',
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Card Section for grouping details with a Card style
//   Widget _buildCardSection(String title, List<Widget> children) {
//     return Card(
//       elevation: 6,
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.orange.shade100, Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: Colors.orange.shade300,
//             width: 1.5,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.info, color: Colors.orange, size: 20),
//                   SizedBox(width: 8),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.orange.shade800,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Divider(
//                 color: Colors.orange.shade400,
//                 thickness: 1.5,
//                 indent: 10,
//                 endIndent: 10,
//               ),
//               const SizedBox(height: 10),
//               ...children, // Unpack children widgets for details
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

