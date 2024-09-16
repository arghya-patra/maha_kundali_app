import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Service-Report/service_report_details.dart';
import 'package:maha_kundali_app/screens/Service-Report/servide_report_model.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// class AllServiceReportScreen extends StatefulWidget {
//   @override
//   _AllServiceReportScreenState createState() => _AllServiceReportScreenState();
// }

// class _AllServiceReportScreenState extends State<AllServiceReportScreen>
//     with SingleTickerProviderStateMixin {
//   late Future<List<ServiceReport>> futureReports;
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     futureReports = fetchServiceReports();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//   }

//   Future<List<ServiceReport>> fetchServiceReports() async {
//     String url = APIData.login;
//     print(url.toString());
//     final response = await http.post(Uri.parse(url), body: {
//       'action': 'all-report',
//       'authorizationToken': ServiceManager.tokenID,
//     });
//     print(response.body);

//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       List<dynamic> reports = jsonResponse['all_report_list'];
//       return reports.map((data) => ServiceReport.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to load service reports');
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('All Service Reports'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<List<ServiceReport>>(
//         future: futureReports,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildShimmerGrid();
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return _buildReportGrid(snapshot.data!);
//           } else {
//             return const Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildShimmerGrid() {
//     return GridView.builder(
//       padding: const EdgeInsets.all(10),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         childAspectRatio: 0.7,
//       ),
//       itemBuilder: (context, index) => Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: Container(
//           color: Colors.white,
//         ),
//       ),
//       itemCount: 8,
//     );
//   }

//   Widget _buildReportGrid(List<ServiceReport> reports) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(10),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         childAspectRatio: 0.7,
//       ),
//       itemBuilder: (context, index) {
//         final report = reports[index];
//         return GestureDetector(
//           onTap: () {
//             // Navigate to another screen
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => ReportDetailScreen(report: report),
//             //   ),
//             // );
//           },
//           child: ScaleTransition(
//             scale: CurvedAnimation(
//               parent: _animationController,
//               curve: Curves.easeIn,
//             ),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   ClipRRect(
//                     borderRadius:
//                         const BorderRadius.vertical(top: Radius.circular(15.0)),
//                     child: Image.network(
//                       report.icon,
//                       height: 120,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       report.name,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text(
//                       report.shortDescription,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ),
//                   const Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '₹${report.price}',
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '${report.deliveryDay} Days',
//                           style:
//                               const TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       itemCount: reports.length,
//     );
//   }
// }

class AllServiceReportScreen extends StatefulWidget {
  @override
  _AllServiceReportScreenState createState() => _AllServiceReportScreenState();
}

class _AllServiceReportScreenState extends State<AllServiceReportScreen> {
  late Future<List<ServiceReport>> futureReports;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    futureReports = fetchServiceReports();
    // _animationController = AnimationController(
    //   duration: const Duration(milliseconds: 500),
    //   vsync: this,
    // );
  }

  Future<List<ServiceReport>> fetchServiceReports() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'all-report',
      'authorizationToken': ServiceManager.tokenID,
    });
    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> reports = jsonResponse['all_report_list'];
      return reports.map((data) => ServiceReport.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load service reports');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Service Reports'),
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
      body: FutureBuilder<List<ServiceReport>>(
        future: futureReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading(); // Show shimmer effect
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return _buildGridView(snapshot.data!);
          } else {
            return const Center(child: Text('No Data Available'));
          }
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      itemCount: 8, // Simulate number of shimmer items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<ServiceReport> reports) {
    return GridView.builder(
      itemCount: reports.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        final report = reports[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceDetailScreen(
                  serviceId: report.name,
                ),
              ),
            );
          },
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        report.icon,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF424242),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${report.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFEF6C00),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${report.deliveryDay} Days Delivery',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _buildGridView(List<ServiceReport> reports) {
  //   return GridView.builder(
  //     itemCount: reports.length,
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 8.0,
  //       mainAxisSpacing: 8.0,
  //     ),
  //     itemBuilder: (context, index) {
  //       final report = reports[index];
  //       return GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ServiceDetailScreen(
  //                 serviceId: report.name,
  //               ),
  //             ),
  //           );
  //           // Navigate to detailed report screen
  //         },
  //         child: Card(
  //           elevation: 4,
  //           color: Color.fromARGB(255, 255, 238, 200),
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 child: Image.network(
  //                   report.icon,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       report.name,
  //                       style: const TextStyle(fontWeight: FontWeight.bold),
  //                     ),
  //                     Text('₹${report.price}'),
  //                     Text('${report.deliveryDay} Days Delivery'),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
