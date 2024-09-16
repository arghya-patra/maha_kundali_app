import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/Numerology/num_model.dart';
import 'package:shimmer/shimmer.dart';

class NumerologyDetailsScreen extends StatefulWidget {
  final Future<NumerologyResponse> futureNumerology;

  // Constructor to receive the future from the previous screen
  NumerologyDetailsScreen({required this.futureNumerology});

  @override
  State<NumerologyDetailsScreen> createState() =>
      _NumerologyDetailsScreenState();
}

class _NumerologyDetailsScreenState extends State<NumerologyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Numerology Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<NumerologyResponse>(
        future: widget.futureNumerology,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildShimmerEffect();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return buildDetailsList(snapshot.data!.numerology.response);
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget buildShimmerEffect() {
    return ListView.builder(
      itemCount: 7,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Container(
                  height: 20,
                  color: Colors.grey,
                ),
                subtitle: Container(
                  height: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDetailsList(NumerologyDetails numerologyDetails) {
    List<NumerologyItem> items = [
      numerologyDetails.destiny,
      numerologyDetails.personality,
      numerologyDetails.attitude,
      numerologyDetails.character,
      numerologyDetails.soul,
      numerologyDetails.agenda,
      numerologyDetails.purpose,
    ];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return buildNumerologyCard(items[index]);
      },
    );
  }

  Widget buildNumerologyCard(NumerologyItem item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.title} (${item.number})',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                item.meaning,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                item.description,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
