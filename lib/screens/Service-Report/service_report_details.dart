import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
//import 'package:html/entities.dart' as html_entities;

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  ServiceDetailScreen({required this.serviceId});

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> _serviceDetailsFuture;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _serviceDetailsFuture = fetchServiceDetails(widget.serviceId);

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  Future<Map<String, dynamic>> fetchServiceDetails(String id) async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'view-report',
      'authorizationToken': ServiceManager.tokenID,
      'name': id
    });
    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load service details');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Detail'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _serviceDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: _buildServiceDetail(snapshot.data!),
            );
          } else {
            return Center(child: Text('No Data Available'));
          }
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              Container(height: 200, color: Colors.white),
              SizedBox(height: 16),
              Container(height: 20, color: Colors.white),
              SizedBox(height: 16),
              Container(height: 20, color: Colors.white),
              SizedBox(height: 16),
              Container(height: 100, color: Colors.white),
            ],
          ),
        ),
        SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(height: 100, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildServiceDetail(Map<String, dynamic> data) {
    final reportDetails = data['reportDetails'];
    final similarReports = data['similar_report_list'] as List<dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              reportDetails['icon'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 24),
          Text(
            reportDetails['name'],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '₹${reportDetails['price']} - ${reportDetails['delivery_day']} Days Delivery',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.orangeAccent,
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              reportDetails['short_description'],
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(height: 24),
          _buildSectionTitle('Details:'),
          SizedBox(height: 8),
          _buildRichText(reportDetails['description']),
          SizedBox(height: 24),
          _buildSectionTitle('Contains:'),
          SizedBox(height: 8),
          _buildRichText(reportDetails['contain']),
          SizedBox(height: 24),
          _buildSectionTitle('Benefits:'),
          SizedBox(height: 8),
          _buildRichText(reportDetails['benefits']),
          SizedBox(height: 32),
          _buildSectionTitle('Similar Reports:'),
          SizedBox(height: 16),
          _buildSimilarReportsGrid(similarReports),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildRichText(String htmlContent) {
    return Text(
      _parseHtmlString(htmlContent),
      style: TextStyle(
        fontSize: 18,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  Widget _buildSimilarReportsGrid(List<dynamic> similarReports) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: similarReports.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {
        final report = similarReports[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceDetailScreen(
                  serviceId: report['name'],
                ),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    report['icon'],
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // SizedBox(height: 4),
                      // Text(
                      //   '₹${report['price']}',
                      //   style: TextStyle(
                      //     color: Colors.orangeAccent,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // SizedBox(height: 4),
                      // Text(
                      //   '${report['delivery_day']} Days Delivery',
                      //   style: TextStyle(
                      //     color: Colors.grey[600],
                      //     fontSize: 14,
                      //   ),
                      // ),
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

  // Widget _buildServiceDetail(Map<String, dynamic> data) {
  //   final reportDetails = data['reportDetails'];
  //   final similarReports = data['similar_report_list'] as List<dynamic>;

  //   return ListView(
  //     padding: const EdgeInsets.all(16.0),
  //     children: [
  //       Image.network(reportDetails['icon']),
  //       SizedBox(height: 16),
  //       Text(
  //         reportDetails['name'],
  //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 8),
  //       Text(
  //         '₹${reportDetails['price']} - ${reportDetails['delivery_day']} Days Delivery',
  //         style: TextStyle(fontSize: 18, color: Colors.grey[600]),
  //       ),
  //       SizedBox(height: 16),
  //       Text(
  //         reportDetails['short_description'],
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       SizedBox(height: 16),
  //       Text(
  //         'Details:',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 8),
  //       Text(
  //         _parseHtmlString(reportDetails['description']),
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       SizedBox(height: 16),
  //       Text(
  //         'Contains:',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 8),
  //       Text(
  //         _parseHtmlString(reportDetails['contain']),
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       SizedBox(height: 16),
  //       Text(
  //         'Benefits:',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 8),
  //       Text(
  //         _parseHtmlString(reportDetails['benefits']),
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       SizedBox(height: 24),
  //       Text(
  //         'Similar Reports:',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 8),
  //       _buildSimilarReportsGrid(similarReports),
  //     ],
  //   );
  // }

  // Widget _buildSimilarReportsGrid(List<dynamic> similarReports) {
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: similarReports.length,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 8.0,
  //       mainAxisSpacing: 8.0,
  //     ),
  //     itemBuilder: (context, index) {
  //       final report = similarReports[index];
  //       return Card(
  //         elevation: 4,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Expanded(
  //               child: Image.network(
  //                 report['icon'],
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     report['name'],
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                   Text('₹${report['price']}'),
  //                   Text('${report['delivery_day']} Days Delivery'),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  String _parseHtmlString(String htmlString) {
    // Parse the HTML string and convert it to plain text
    final document = html_parser.parse(htmlString);
    // Decode HTML entities to plain text

    return document.body?.text ?? '';
    //return html_entities.decode(document.body?.text ?? '');
  }
}
