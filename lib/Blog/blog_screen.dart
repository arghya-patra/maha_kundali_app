import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AstrologyBlogScreen extends StatefulWidget {
  @override
  _AstrologyBlogScreenState createState() => _AstrologyBlogScreenState();
}

class _AstrologyBlogScreenState extends State<AstrologyBlogScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Simulate a delay for loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildShimmerBlogItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Container(
                width: 150,
                height: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrology Blog'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Latest Blog',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? _buildShimmerBlogItem()
                  : const BlogItem(
                      imageUrl:
                          'https://via.placeholder.com/400', // Replace with actual image URL
                      title: 'Astrology and Your Future',
                      description:
                          'Explore how astrology can give you insights into your future and help you make better decisions.',
                      fullDescription:
                          'Explore how astrology can give you insights into your future and help you make better decisions. Astrology, an ancient science, helps to understand the cosmic forces that influence our lives. By analyzing the positions of celestial bodies, astrologers can offer guidance on various aspects of life such as career, relationships, and personal growth. It’s believed that by aligning with cosmic rhythms, individuals can make more informed decisions and improve their quality of life.',
                    ),
              const SizedBox(height: 20),
              const Text(
                'Other Blogs',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? _buildShimmerBlogItem()
                  : const Column(
                      children: [
                        BlogItem(
                          imageUrl:
                              'https://via.placeholder.com/400', // Replace with actual image URL
                          title: 'The Power of Zodiac Signs',
                          description:
                              'Discover the influence of zodiac signs on your personality and relationships.',
                          fullDescription:
                              'Discover the influence of zodiac signs on your personality and relationships. Each zodiac sign has its own unique characteristics and influences on your life. By understanding these traits, you can gain deeper insights into your strengths and weaknesses. Zodiac signs can also shed light on your compatibility with others and provide guidance on improving your relationships.',
                        ),
                        SizedBox(height: 20),
                        BlogItem(
                          imageUrl:
                              'https://via.placeholder.com/400', // Replace with actual image URL
                          title: 'Astrology in the Modern World',
                          description:
                              'Learn how astrology is being integrated into modern society and its growing popularity.',
                          fullDescription:
                              'Learn how astrology is being integrated into modern society and its growing popularity. Modern astrology has evolved to include various branches such as psychological astrology, which focuses on personal development and self-awareness. The growing interest in astrology reflects a desire for meaning and connection in today’s fast-paced world.',
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String fullDescription;

  const BlogItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.fullDescription,
  }) : super(key: key);

  @override
  _BlogItemState createState() => _BlogItemState();
}

class _BlogItemState extends State<BlogItem>
    with SingleTickerProviderStateMixin {
  bool _showMore = false;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _showMore ? widget.fullDescription : widget.description,
                maxLines: _showMore ? null : 2,
                overflow:
                    _showMore ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showMore = !_showMore;
                  });
                },
                child: Text(
                  _showMore ? 'Show Less' : 'Show More',
                  style: const TextStyle(color: Colors.deepOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
