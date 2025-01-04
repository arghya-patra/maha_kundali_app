import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NumberDetailScreen extends StatefulWidget {
  final int number;
  const NumberDetailScreen({required this.number});

  @override
  _NumberDetailScreenState createState() => _NumberDetailScreenState();
}

class _NumberDetailScreenState extends State<NumberDetailScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  AnimationController? _imageAnimationController;
  Animation<double>? _imageAnimation;

  @override
  void initState() {
    super.initState();

    // Simulate loading delay for shimmer effect
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });

    // Initialize animation for the image
    _imageAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _imageAnimation = CurvedAnimation(
      parent: _imageAnimationController!,
      curve: Curves.easeInOut,
    );

    _imageAnimationController?.forward();
  }

  @override
  void dispose() {
    _imageAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number ${widget.number} Details'),
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
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: 150,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 15,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 15,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 15,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number ${widget.number}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ScaleTransition(
                      scale: _imageAnimation!,
                      child: Center(
                        child: Image.asset(
                          'images/number_${widget.number}.webp',
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. '
                      'Sed nisi. Nulla quis sem at nibh elementum imperdiet. '
                      'Duis sagittis ipsum. Praesent mauris.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Curabitur sodales ligula in libero. '
                      'Sed dignissim lacinia nunc. '
                      'Curabitur tortor. Pellentesque nibh. Aenean quam. '
                      'In scelerisque sem at dolor. Maecenas mattis. '
                      'Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. '
                      'Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. '
                      'Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. ',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
