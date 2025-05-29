import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/screens/Astro_Ecom/cartScreen.dart';
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
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  reportDetails['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoppingCartScreen()
                          // WalletScreen(),
                          ),
                    );
                    // Buy Now action
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '₹${reportDetails['price']} - ${reportDetails['delivery_day']} Days Delivery',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.orangeAccent,
            ),
          ),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              reportDetails['short_description'],
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(height: 6),
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
      textAlign: TextAlign.justify,
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
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 16,
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

  String _parseHtmlString(String htmlString) {
    // Parse the HTML string and convert it to plain text
    final document = html_parser.parse(htmlString);
    // Decode HTML entities to plain text

    return document.body?.text ?? '';
    //return html_entities.decode(document.body?.text ?? '');
  }
}
