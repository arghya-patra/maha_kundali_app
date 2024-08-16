import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HoroscopeScreen extends StatefulWidget {
  @override
  _HoroscopeScreenState createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _loadData();
  }

  void _loadData() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulate network request
    setState(() {
      _isLoading = false;
    });
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
        title: const Text('Horoscope'),
        centerTitle: true,
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
      body: _isLoading ? _buildShimmerEffect() : _buildZodiacGrid(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Handle navigation to the "I don't know my Sign" screen
          },
          child: const Text("I don't know my Sign",
              style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange, width: 2),
          ),
        ),
        itemCount: 12,
      ),
    );
  }

  Widget _buildZodiacGrid() {
    final List<Map<String, String>> zodiacSigns = [
      {'name': 'Aries', 'image': 'images/aries.png'},
      {'name': 'Taurus', 'image': 'images/taurus.png'},
      {'name': 'Gemini', 'image': 'images/gemini.png'},
      {'name': 'Cancer', 'image': 'images/cancer.png'},
      {'name': 'Leo', 'image': 'images/leo.png'},
      {'name': 'Virgo', 'image': 'images/virgo.png'},
      {'name': 'Libra', 'image': 'images/libra.png'},
      {'name': 'Scorpio', 'image': 'images/scorpio.png'},
      {'name': 'Sagittarius', 'image': 'images/sagitta.png'},
      {'name': 'Capricorn', 'image': 'images/capricon.png'},
      {'name': 'Aquarius', 'image': 'images/aquarius.png'},
      {'name': 'Pisces', 'image': 'images/pisces.png'},
    ];

    return FadeTransition(
      opacity: _animation,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: zodiacSigns.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle navigation to the specific zodiac screen
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(zodiacSigns[index]['image']!,
                      height: 50, width: 50),
                  const SizedBox(height: 8),
                  Text(zodiacSigns[index]['name']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
