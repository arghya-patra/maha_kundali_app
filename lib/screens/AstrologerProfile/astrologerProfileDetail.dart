import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/chats/chatMessageScreen.dart';
import 'package:shimmer/shimmer.dart';

class AstrologerProfileScreen extends StatefulWidget {
  @override
  _AstrologerProfileScreenState createState() =>
      _AstrologerProfileScreenState();
}

class _AstrologerProfileScreenState extends State<AstrologerProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFollow = false;

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
        title: const Text('Astrologer Profile'),
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
      body: Stack(
        children: [
          _isLoading ? _buildShimmerEffect() : _buildProfileContent(),
          _buildFloatingBottomTab(),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerBox(height: 150),
            const SizedBox(height: 16),
            _buildShimmerBox(height: 20),
            const SizedBox(height: 8),
            _buildShimmerBox(height: 20),
            const SizedBox(height: 8),
            _buildShimmerBox(height: 20),
            const SizedBox(height: 16),
            _buildShimmerBox(height: 100),
            const SizedBox(height: 16),
            _buildShimmerBox(height: 50),
            const SizedBox(height: 8),
            _buildShimmerBox(height: 50),
            const SizedBox(height: 8),
            _buildShimmerBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBox({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.white,
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
          left: 16, right: 16, bottom: 100), // Added bottom padding
      child: FadeTransition(
        opacity: _animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildProfileSection(),
            const SizedBox(height: 16),
            _buildDescriptionSection(),
            const SizedBox(height: 16),
            _buildReviewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(
              'images/astro3.jpg'), // Replace with actual image asset
          child: Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.verified, color: Colors.blue, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Astrologer Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('Vedic Astrologer | 10+ years of Experience',
                  style: TextStyle(color: Colors.black)),
              const Text('Languages: Hindi, English',
                  style: TextStyle(color: Colors.black)),
              const SizedBox(height: 8),
              const Text('₹500 / minute',
                  style: TextStyle(fontSize: 18, color: Colors.orange)),
              const SizedBox(height: 8),
              _buildRating(3),
            ],
          ),
        ),
        Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              onPressed: () {
                setState(() {
                  isFollow = !isFollow;
                });
              },
              child: isFollow ? Text('Unfollow') : Text('Follow'),
            ),
            const SizedBox(height: 8),
            const Text('5000 Followers', style: TextStyle(color: Colors.black)),
          ],
        ),
      ],
    );
  }

  Widget _buildRating(double rating) {
    int fullStars = rating.floor(); // Number of full stars
    bool hasHalfStar =
        (rating - fullStars) >= 0.5; // Check if there's a half star
    int emptyStars =
        5 - fullStars - (hasHalfStar ? 1 : 0); // Remaining empty stars

    return Row(
      children: [
        // Full Stars
        for (int i = 0; i < fullStars; i++)
          const Icon(Icons.star, color: Colors.orange, size: 16),

        // Half Star
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.orange, size: 16),

        // Empty Stars
        for (int i = 0; i < emptyStars; i++)
          const Icon(Icons.star_border, color: Colors.grey, size: 16),

        // Rating Text
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Astrologer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'This astrologer has 10+ years of experience in Vedic astrology. He has guided thousands of people with his accurate predictions and insightful advice...',
          maxLines: _isExpanded ? null : 3,
          overflow: TextOverflow.fade,
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'Show less' : 'Show more',
            style: const TextStyle(
                color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'User Reviews',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
            'John Doe',
            'Great advice! Really helped me in making life decisions.',
            5,
            '2024-08-07'),
        const SizedBox(height: 16),
        _buildReviewCard('Jane Smith',
            'Very accurate predictions, highly recommend!', 4, '2024-08-06'),
        const SizedBox(height: 16),
        _buildReviewCard('Samuel Green',
            'Good experience, but a bit expensive.', 3, '2024-08-05'),
      ],
    );
  }

  Widget _buildReviewCard(String name, String review, int rating, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'images/profile.jpeg'), // Replace with actual image asset
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                _buildStarRating(rating),
              ],
            ),
            const Spacer(),
            Text(date, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),
        Text(review),
      ],
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating) {
          return const Icon(Icons.star, color: Colors.orange, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 16);
        }
      }),
    );
  }

  Widget _buildFloatingBottomTab() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.call),
                label: const Text('Call'),
                onPressed: () {
                  // Handle call action
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.chat),
                label: const Text('Chat'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: "1"),
                    ),
                  );
                  // Handle chat action
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
