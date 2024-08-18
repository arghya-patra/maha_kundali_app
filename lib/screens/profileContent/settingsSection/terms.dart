import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    // Simulate a network or data load delay
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? _buildShimmerEffect()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please read these terms and conditions carefully before using this application.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  buildBulletPoint('Acceptance of terms'),
                  buildBulletPoint('User responsibilities'),
                  buildBulletPoint('Account security'),
                  buildBulletPoint('Intellectual property'),
                  buildBulletPoint('Termination of services'),
                  SizedBox(height: 16),
                  Text(
                    '1. Acceptance of Terms',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'By accessing or using our services, you agree to be bound by these terms.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    '2. User Responsibilities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You are responsible for your use of the service and any consequences thereof.',
                  ),
                  // Add more sections as needed
                ],
              ),
            ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            buildShimmerBulletPoint(),
            buildShimmerBulletPoint(),
            buildShimmerBulletPoint(),
            buildShimmerBulletPoint(),
            buildShimmerBulletPoint(),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 15,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 15,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerBulletPoint() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Colors.orange,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
