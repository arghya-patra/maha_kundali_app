import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class HoroscopeDetailsScreen extends StatefulWidget {
  final String zodiac;

  const HoroscopeDetailsScreen({required this.zodiac, Key? key})
      : super(key: key);

  @override
  _HoroscopeDetailsScreenState createState() => _HoroscopeDetailsScreenState();
}

class _HoroscopeDetailsScreenState extends State<HoroscopeDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Future<Map<String, dynamic>> _horoscopeData;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    _horoscopeData = fetchHoroscopeData();
  }

  Future<Map<String, dynamic>> fetchHoroscopeData() async {
    String url = APIData.login;
    final response = await http.post(Uri.parse(url), body: {
      'action': 'horoscope-detail',
      'authorizationToken': ServiceManager.tokenID,
      'zodiac': widget.zodiac,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load horoscope details');
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
        title: Text(
          'Horoscope Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      backgroundColor: Color(0xFF3E2723),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(),
            ),
          ),
          Column(
            children: [
              // Header (Back button and title)

              // Zodiac Wheel with Image
              FutureBuilder<Map<String, dynamic>>(
                future: _horoscopeData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                        height: 200,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _animation.value,
                              child: ZodiacWheel(
                                imageUrl: snapshot.data!['myzodiac_details']
                                    ['icon'],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return const SizedBox(height: 200);
                },
              ),

              // Custom Tab Bar
              GlassTabBar(
                tabs: const ["Today", "Tomorrow", "Weekly", "Yearly"],
                currentIndex: _currentTabIndex,
                onTap: (index) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                  _controller.reset();
                  _controller.forward();
                },
              ),

              // Main Content
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _horoscopeData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return _buildContent(snapshot.data!);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        'Horoscope Details',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true, // Center the title
      elevation: 4, // Optional: Add elevation for shadow effect
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    switch (_currentTabIndex) {
      case 0:
        return _buildDailyContent(data['today'], "Today's Horoscope");
      case 1:
        return _buildDailyContent(data['tomorrow'], "Tomorrow's Horoscope");
      case 2:
        return _buildWeeklyContent(data['week']);
      case 3:
        return _buildYearlyContent(data['year']);
      default:
        return _buildDailyContent(data['today'], "Today's Horoscope");
    }
  }

  Widget _buildDailyContent(Map<String, dynamic> data, String title) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GlassCard(
            child: Column(
              children: [
                const Text(
                  'Lucky Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLuckyDetailItem(
                      Icons.color_lens,
                      'Color',
                      data['lucky_color'],
                      Color(int.parse(data['lucky_color_code'].substring(1, 7),
                              radix: 16) +
                          0xFF000000),
                    ),
                    _buildLuckyDetailItem(
                      Icons.star,
                      'Numbers',
                      data['lucky_number'].join(', '),
                      null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                ...data['bot_response']
                    .entries
                    .map((entry) => _buildPredictionCard(
                          safeCapitalize(entry.key),
                          entry.value['split_response'],
                          entry.value['score'],
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuckyDetailItem(
      IconData icon, String title, String value, Color? color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: color != null
                ? null
                : const LinearGradient(colors: [Colors.blue, Colors.purple]),
            color: color,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionCard(String category, String prediction, int score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _getScoreColor(score),
                ),
                child: Text(
                  '$score%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            prediction,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyContent(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            child: Column(
              children: [
                const Text(
                  'Weekly Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Week ${data['week_number']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLuckyDetailItem(
                      Icons.color_lens,
                      'Color',
                      data['lucky_color'],
                      Color(int.parse(data['lucky_color_code'].substring(1, 7),
                              radix: 16) +
                          0xFF000000),
                    ),
                    _buildLuckyDetailItem(
                      Icons.star,
                      'Numbers',
                      data['lucky_number'].join(', '),
                      null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Predictions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                ...data['bot_response']
                    .entries
                    .map((entry) => _buildPredictionCard(
                          safeCapitalize(entry.key),
                          entry.value['split_response'],
                          entry.value['score'],
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyContent(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GlassCard(
            child: const Column(
              children: [
                Text(
                  'Yearly Horoscope',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Detailed predictions for each quarter',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quarters
          ...['phase_1', 'phase_2', 'phase_3', 'phase_4'].map((phase) {
            final quarter = data[phase];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: const LinearGradient(
                              colors: [Colors.deepPurple, Colors.blue],
                            ),
                          ),
                          child: Text(
                            quarter['period'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _getScoreColor(quarter['score']),
                          ),
                          child: Text(
                            '${quarter['score']}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      quarter['prediction'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categories
                    ...[
                      'physique',
                      'health',
                      'relationship',
                      'career',
                      'travel',
                      'family',
                      'friends',
                      'finance',
                      'status'
                    ].map((category) {
                      final categoryData = quarter[category];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              safeCapitalize(category),
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Check if categoryData is not null and has a prediction
                            categoryData != null &&
                                    categoryData['prediction'] != null
                                ? Text(
                                    categoryData['prediction'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  )
                                : Container(), // Empty container if no prediction
                            const Divider(color: Colors.white24, height: 16),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green.shade800;
    if (score >= 60) return Colors.blue.shade700;
    if (score >= 40) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  String safeCapitalize(String? str) {
    if (str != null && str.isNotEmpty) {
      return str.capitalize();
    }
    return '';
  }
}

// Helper widget for the zodiac wheel with image
class ZodiacWheel extends StatelessWidget {
  final String imageUrl;

  const ZodiacWheel({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        height: 170,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 255, 51, 51).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple[300],
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// Custom glass tab bar widget
class GlassTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final Function(int) onTap;

  const GlassTabBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white30, width: 0.5),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = index == currentIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: isSelected
                      ? BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFC107),
                              Color(0xFFFF5722)
                            ], // Amber to Deep Orange
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF5722)
                                  .withOpacity(0.3), // Deep Orange shadow
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        )
                      : null,
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// Glass card widget with blur effect

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const GlassCard({
    required this.child,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.03),
                ],
                center: Alignment.topLeft,
                radius: 1.0,
              ),
            ),
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Particle background painter
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Random random = Random();

  ParticlePainter({int count = 50})
      : particles = List.generate(count, (index) {
          return Particle(
            position: Offset(
              Random().nextDouble() * 1000,
              Random().nextDouble() * 1000,
            ),
            velocity: Offset(
              Random().nextDouble() * 2 - 1,
              Random().nextDouble() * 2 - 1,
            ),
            radius: Random().nextDouble() * 2 + 1,
            alpha: Random().nextDouble() * 0.2 + 0.1,
          );
        });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 250, 204, 65), // Amber
        Color.fromARGB(255, 255, 106, 61), // Deep Orange
      ],
    );

    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );

    for (final particle in particles) {
      particle.position += particle.velocity;
      if (particle.position.dx < 0 || particle.position.dx > size.width) {
        particle.velocity = Offset(-particle.velocity.dx, particle.velocity.dy);
      }
      if (particle.position.dy < 0 || particle.position.dy > size.height) {
        particle.velocity = Offset(particle.velocity.dx, -particle.velocity.dy);
      }

      final paint = Paint()
        ..color = Color.fromARGB(255, 255, 0, 0)
            .withOpacity(particle.alpha) // Orange particle color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Particle model
class Particle {
  Offset position;
  Offset velocity;
  double radius;
  double alpha;

  Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.alpha,
  });
}

// String extension for capitalization
extension StringCasingExtension on String {
  String capitalize() {
    return length > 0 ? this[0].toUpperCase() + substring(1) : '';
  }
}
