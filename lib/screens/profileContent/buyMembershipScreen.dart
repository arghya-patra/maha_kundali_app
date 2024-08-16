import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuyMembershipScreen extends StatefulWidget {
  @override
  _BuyMembershipScreenState createState() => _BuyMembershipScreenState();
}

class _BuyMembershipScreenState extends State<BuyMembershipScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<Map<String, dynamic>> _membershipPlans = [];

  late AnimationController _animationController;
  late Animation<Color?> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    // Simulate loading time for shimmer effect
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _membershipPlans = _fetchMembershipPlans();
      });
    });

    // Initialize animation controller for blinking effect
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _blinkAnimation = ColorTween(begin: Colors.orange, end: Colors.deepOrange)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _fetchMembershipPlans() {
    return [
      {
        'title': 'Silver Membership',
        'features': ['Feature 1', 'Feature 2', 'Feature 3'],
        'price': '₹499 / 30 days',
        'details': 'Full details of Silver Membership Plan...'
      },
      {
        'title': 'Gold Membership',
        'features': ['Feature 1', 'Feature 2', 'Feature 3', 'Feature 4'],
        'price': '₹999 / 30 days',
        'details': 'Full details of Gold Membership Plan...'
      },
      {
        'title': 'Platinum Membership',
        'features': ['Feature 1', 'Feature 2', 'Feature 3', 'Feature 4'],
        'price': '₹1499 / 30 days',
        'details': 'Full details of Platinum Membership Plan...'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Membership'),
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
      body: _isLoading ? _buildShimmerEffect() : _buildMembershipList(),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        children: List.generate(3, (index) => _buildShimmerCard()),
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

  Widget _buildMembershipList() {
    return ListView.builder(
      itemCount: _membershipPlans.length,
      itemBuilder: (context, index) {
        return _buildMembershipCard(_membershipPlans[index]);
      },
    );
  }

  Widget _buildMembershipCard(Map<String, dynamic> plan) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.orangeAccent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan['title'],
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 10.0),
            ...plan['features'].map<Widget>((feature) {
              return Text(
                '- $feature',
                style: TextStyle(fontSize: 16.0),
              );
            }).toList(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _showPlanDetails(plan['details']),
                child: Text('More details'),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan['price'],
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blinkAnimation.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Handle Buy Now action
                  },
                  child: AnimatedBuilder(
                    animation: _blinkAnimation,
                    builder: (context, child) {
                      return Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPlanDetails(String details) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Plan Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              SizedBox(height: 10.0),
              Text(details),
            ],
          ),
        );
      },
    );
  }
}
