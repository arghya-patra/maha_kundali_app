import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerList.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Numerology/num_model.dart';
import 'package:shimmer/shimmer.dart';

class NumerologyDetailsScreen extends StatefulWidget {
  String? name;
  final Future<NumerologyResponse> futureNumerology;

  // Constructor to receive the future from the previous screen
  NumerologyDetailsScreen({required this.futureNumerology, required this.name});

  @override
  State<NumerologyDetailsScreen> createState() =>
      _NumerologyDetailsScreenState();
}

class _NumerologyDetailsScreenState extends State<NumerologyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numerology Details'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Numerology of ${widget.name}",
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange),
          ),
          const SizedBox(height: 5),
          const Text(
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
            "Numerology is a relationship between number & coinciding events. It is the study of numerical value of letters in words, names.",
            textAlign: TextAlign.center,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AstrologerListScreen()));
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => VideoCallScreen()));
              },
              child: const Text(
                'To know more talk to our Astrologers',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<NumerologyResponse>(
              future: widget.futureNumerology,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildShimmerEffect();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return buildDetailsList(snapshot.data!.numerology.response);
                } else {
                  return const Center(child: Text('No data found'));
                }
              },
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, Colors.deepOrange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white
              .withOpacity(0.8), // Semi-transparent white for effect
          elevation: 0, // Set to 0 since the container provides shadow
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.deepOrange, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${item.title} (${item.number})',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 1,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 10),
                Text(
                  item.meaning,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5, // Increase line height for readability
                  ),
                ),
                const SizedBox(height: 15),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.deepOrange, // Background color
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     child: const Text('Learn More'),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
