import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AstrologerListScreen extends StatefulWidget {
  @override
  _AstrologerListScreenState createState() => _AstrologerListScreenState();
}

class _AstrologerListScreenState extends State<AstrologerListScreen> {
  List<String> _selectedChips = [];
  List<Map<String, dynamic>> _allAstrologers = [];
  List<Map<String, dynamic>> _filteredAstrologers = [];
  List<String> _banners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    // Simulate network delay for API call
    await Future.delayed(Duration(seconds: 2));

    // Dummy data simulating API response
    setState(() {
      _banners = [
        'images/banner1.png',
        'images/banner2.jpg',
        'images/banner3.jpeg',
      ];
      _allAstrologers = [
        {
          'name': 'Astrologer A',
          'specialization': 'Business, Love',
          'experience': '10 years',
          'rating': 4.5,
          'rate': '₹500 / min',
          'image': 'images/astro1.jpg',
          'tags': ['Business', 'Love'],
        },
        {
          'name': 'Astrologer B',
          'specialization': 'Marriage, Education',
          'experience': '8 years',
          'rating': 4.0,
          'rate': '₹400 / min',
          'image': 'images/astro2.jpg',
          'tags': ['Marriage', 'Education'],
        },
        // Add more astrologers with different tags
        {
          'name': 'Astrologer C',
          'specialization': 'Kundli, Business',
          'experience': '12 years',
          'rating': 4.7,
          'rate': '₹600 / min',
          'image': 'images/astro3.jpg',
          'tags': ['Kundli', 'Business'],
        },
        {
          'name': 'Astrologer D',
          'specialization': 'Career, Love',
          'experience': '15 years',
          'rating': 4.3,
          'rate': '₹550 / min',
          'image': 'images/astro1.jpg',
          'tags': ['Career', 'Love'],
        },
        {
          'name': 'Astrologer E',
          'specialization': 'Education, Marriage',
          'experience': '9 years',
          'rating': 4.6,
          'rate': '₹450 / min',
          'image': 'images/astro2.jpg',
          'tags': ['Education', 'Marriage'],
        },
        {
          'name': 'Astrologer F',
          'specialization': 'Business, Kundli',
          'experience': '7 years',
          'rating': 4.2,
          'rate': '₹380 / min',
          'image': 'images/astro3.jpg',
          'tags': ['Business', 'Kundli'],
        },
        {
          'name': 'Astrologer G',
          'specialization': 'Career, Love',
          'experience': '11 years',
          'rating': 4.8,
          'rate': '₹620 / min',
          'image': 'images/astro1.jpg',
          'tags': ['Career', 'Love'],
        },
        {
          'name': 'Astrologer H',
          'specialization': 'Marriage, Kundli',
          'experience': '10 years',
          'rating': 4.4,
          'rate': '₹470 / min',
          'image': 'images/astro2.jpg',
          'tags': ['Marriage', 'Kundli'],
        },
        {
          'name': 'Astrologer I',
          'specialization': 'Marriage, Kundli',
          'experience': '10 years',
          'rating': 4.4,
          'rate': '₹470 / min',
          'image': 'images/astro1.jpg',
          'tags': ['Marriage', 'Kundli'],
        },
        {
          'name': 'Astrologer J',
          'specialization': 'Marriage, Kundli',
          'experience': '10 years',
          'rating': 4.4,
          'rate': '₹470 / min',
          'image': 'images/astro2.jpg',
          'tags': ['Kundli', 'Business'],
        },
        {
          'name': 'Astrologer K',
          'specialization': 'Marriage, Kundli',
          'experience': '10 years',
          'rating': 4.4,
          'rate': '₹470 / min',
          'image': 'images/astro1.jpg',
          'tags': ['Career', 'Love'],
        },
        {
          'name': 'Astrologer L',
          'specialization': 'Marriage, Kundli',
          'experience': '10 years',
          'rating': 4.4,
          'rate': '₹470 / min',
          'image': 'images/astro1.jpg',
          'tags': ['Business', 'Love'],
        },
        {
          'name': 'Astrologer M',
          'specialization': 'Marriage, Kundli',
          'experience': '10 years',
          'rating': 4.4,
          'rate': '₹470 / min',
          'image': 'images/astro1.jpg',
          'tags': ['Marriage', 'Kundli'],
        },
        {
          'name': 'Astrologer N',
          'specialization': 'Marriage, Kundli',
          'experience': '10 years',
          'rating': 4.4,
          'rate': '₹470 / min',
          'image': 'images/astro1.jpg',
          'tags': ['Business', 'Love'],
        },
        // Continue adding more astrologers with different tags
      ];
      _filteredAstrologers = _allAstrologers;
      _isLoading = false;
    });
  }

  void _onChipSelected(String chip) {
    setState(() {
      if (_selectedChips.contains(chip)) {
        _selectedChips.remove(chip);
      } else {
        _selectedChips.add(chip);
      }
      _filterAstrologers();
    });
  }

  void _filterAstrologers() {
    setState(() {
      if (_selectedChips.isEmpty) {
        _filteredAstrologers = _allAstrologers;
      } else {
        _filteredAstrologers = _allAstrologers.where((astrologer) {
          return _selectedChips
              .any((chip) => astrologer['tags'].contains(chip));
        }).toList();
      }
      _isLoading = true;
    });

    // Simulate network delay for API call
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget _buildChip(String label) {
    bool isSelected = _selectedChips.contains(label);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          _onChipSelected(label);
        },
        selectedColor: Colors.orange,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: isSelected ? Colors.orange : Colors.grey,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(5, (index) => _buildShimmerCard()),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150.0,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAstrologerCard(Map<String, dynamic> astrologer) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.orangeAccent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage(astrologer['image']),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    astrologer['name'],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(astrologer['specialization']),
                  Text('${astrologer['experience']} experience'),
                  Row(
                    children: [
                      _buildRating(astrologer['rating']),
                      SizedBox(width: 10.0),
                      Text(astrologer['rate']),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: () {
                    // Handle chat action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () {
                    // Handle call action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.orange, size: 16));
    }
    if (halfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.orange, size: 16));
    }
    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.orange, size: 16));
    }

    return Row(children: stars);
  }

  Widget _buildBannerSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: _banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage(banner),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildAstrologerList() {
    if (_isLoading) {
      return _buildShimmerEffect();
    }
    return Column(
      children: _filteredAstrologers.map((astrologer) {
        return _buildAstrologerCard(astrologer);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astrologer List'),
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
      body: Column(
        children: [
          Container(
            height: 60.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildChip('Business'),
                _buildChip('Education'),
                _buildChip('Marriage'),
                _buildChip('Love'),
                _buildChip('Kundli'),
                _buildChip('Career'),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          _buildBannerSlider(),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView(
              children: [
                _buildAstrologerList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
