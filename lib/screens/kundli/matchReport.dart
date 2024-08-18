import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/profileContent/callIntakeForm.dart';

class KundliMatchingResultScreen extends StatefulWidget {
  @override
  _KundliMatchingResultScreenState createState() =>
      _KundliMatchingResultScreenState();
}

class _KundliMatchingResultScreenState extends State<KundliMatchingResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
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
        title: Text('Kundli Matching Result'),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAnimatedCard(
                title: "Boy's Details",
                name: "Rahul Sharma",
                dob: "12 August 1990",
                timeOfBirth: "10:00 AM",
                placeOfBirth: "Delhi, India",
              ),
              SizedBox(height: 16),
              _buildAnimatedCard(
                title: "Girl's Details",
                name: "Priya Verma",
                dob: "25 December 1992",
                timeOfBirth: "3:00 PM",
                placeOfBirth: "Mumbai, India",
              ),
              SizedBox(height: 16),
              _buildResultCard(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallIntakeFormScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.orange,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text(
                  'Consult Our Astrologers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required String name,
    required String dob,
    required String timeOfBirth,
    required String placeOfBirth,
  }) {
    return ScaleTransition(
      scale: Tween(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(2.0, 4.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            Divider(color: Colors.white54),
            SizedBox(height: 8.0),
            _buildDetailRow('Name', name),
            _buildDetailRow('Date of Birth', dob),
            _buildDetailRow('Time of Birth', timeOfBirth),
            _buildDetailRow('Place of Birth', placeOfBirth),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            spreadRadius: 2.0,
            offset: Offset(2.0, 4.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kundli Matching Result',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.deepOrangeAccent,
            ),
          ),
          Divider(color: Colors.deepOrangeAccent),
          SizedBox(height: 8.0),
          Text(
            'The boy is not a Manglik; nor is the girl a Manglik. Mangal Dosha being absent in either horoscopes, there shall be no ill effect on their marriage. This match is recommended.\n\n'
            'Marriage between the prospective bride and groom is highly recommended. The couple would have a long-lasting relationship, which would be filled with happiness and affluence.',
            style: TextStyle(
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
