import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/match_Making/matchMakingModel.dart';

class MatchmakingResultScreen extends StatelessWidget {
  final Matchmaking matchmaking;

  MatchmakingResultScreen({required this.matchmaking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matchmaking Result'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBoyGirlDetails(),
            SizedBox(height: 16),
            _buildAshtakootScore(),
            SizedBox(height: 16),
            _buildAshtakootDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildBoyGirlDetails() {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.male, color: Colors.blue, size: 28),
                SizedBox(width: 8),
                Text(
                  'Boy: ${matchmaking.boyGirlDetails.boyName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text('DOB: ${matchmaking.boyGirlDetails.boyDob}',
                style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.female, color: Colors.pink, size: 28),
                SizedBox(width: 8),
                Text(
                  'Girl: ${matchmaking.boyGirlDetails.girlName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text('DOB: ${matchmaking.boyGirlDetails.girlDob}',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildAshtakootScore() {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ashtakoot Score',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${matchmaking.ashtakoot.score}/36',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                Icon(Icons.check_circle, color: Colors.green, size: 30),
              ],
            ),
            SizedBox(height: 8),
            Text(
              matchmaking.ashtakoot.botResponse,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAshtakootDetails() {
    return Column(
      children: matchmaking.ashtakoot.details.entries.map((entry) {
        final detail = entry.value;
        return Card(
          elevation: 6.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: EdgeInsets.only(bottom: 8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${detail.name} (${detail.score}/${detail.fullScore})',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.male, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Boy: ${detail.boyValue}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.female, color: Colors.pink),
                    SizedBox(width: 8),
                    Text(
                      'Girl: ${detail.girlValue}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  detail.description,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
