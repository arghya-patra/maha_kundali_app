import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HoroscopeDetailsScreen extends StatefulWidget {
  @override
  _HoroscopeDetailsScreenState createState() => _HoroscopeDetailsScreenState();
}

class _HoroscopeDetailsScreenState extends State<HoroscopeDetailsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a delay for the shimmer effect
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horoscope Details'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
            ),
          ),
        ),
      ),
      body: _isLoading ? _buildShimmer() : _buildContent(),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            height: 200,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Container(
            height: 20,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/libra_horos.webp'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Horoscope Description',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Here is a detailed description of the horoscope. This section will be populated with dynamic content fetched from an API in the future. For now, this is just placeholder text.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        _buildBulletPoint('First important point about the horoscope.'),
        _buildBulletPoint('Second key detail that should be noted.'),
        _buildBulletPoint(
            'Another significant aspect related to this horoscope.'),
        const SizedBox(height: 16),
        const Text(
          'This is a second paragraph with more detailed information. The content here can span multiple lines and include various details relevant to the horoscope. Again, this is placeholder text, and the real content will come from an API.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ", style: TextStyle(fontSize: 20)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
