import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maha_kundali_app/apiManager/apiData.dart';

class MatchmakingScreen extends StatefulWidget {
  var apiData;
  MatchmakingScreen({this.apiData});
  @override
  _MatchmakingScreenState createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? ashtakootResponse;
  Map<String, dynamic>? aggregateResponse;
  Map<String, dynamic>? nakshatraResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _fetchDataForTab(0);
  }

  void _onTabChanged() {
    print(_tabController.index);
    if (_tabController.indexIsChanging)
      return; // Prevent multiple calls during transition
    _fetchDataForTab(_tabController.index);
  }

  Future<void> _fetchDataForTab(int index) async {
    switch (index) {
      case 0:
        await fetchAshtakootData('ashtakoot');
        break;
      case 1:
        await fetchAshtakootData('aggregate');
        break;
      // case 2:
      //   await fetchAshtakootData('rajju_vedha');
      //   break;
      case 2:
        await fetchAshtakootData('nakshatra_match');
        break;
        // case 3:
        //   await fetchAshtakootData('papasamaya_match');
        break;
      default:
        print('Invalid tab index');
    }
  }

  Future<void> fetchAshtakootData(page) async {
    const apiUrl = APIData.login; // Replace with your API endpoint
    var body = widget.apiData;
    body['page'] = page;
    try {
      final response = await http.post(Uri.parse(apiUrl), body: body);
      if (response.statusCode == 200) {
        setState(() {
          if (page == 'ashtakoot') {
            ashtakootResponse = json.decode(response.body);
            print(response.body);
            isLoading = false;
          }
          if (page == 'aggregate') {
            final data = json.decode(response.body) as Map<String, dynamic>;
            print(response.body);
            final aggregate = data['matchmaking']?['aggregate'];
            // Debugging the response
            if (aggregate != null) {
              setState(() {
                aggregateResponse = aggregate as Map<String, dynamic>;
                isLoading = false;
              });
            } else {
              print("Aggregate key is missing or null");
            }
            isLoading = false;
          }
          if (page == 'nakshatra_match') {
            final data = json.decode(response.body) as Map<String, dynamic>;
            print(response.body);
            final nakshatra = data['matchmaking']?['nakshatra_match'];
            // Debugging the response
            if (nakshatra != null) {
              setState(() {
                nakshatraResponse = nakshatra as Map<String, dynamic>;
                isLoading = false;
              });
            } else {
              print("Aggregate key is missing or null");
            }
            isLoading = false;
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(error.toString());
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("Matchmaking"),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: const [
            Tab(text: "Ashtakoot"),
            Tab(text: "Aggregate"),
            //Tab(text: "Rajju Vedha"),
            Tab(text: "Nakshatra Match"),
            //Tab(text: "Papasamaya Match"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Ashtakoot Tab
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ashtakootResponse != null
                      ? _buildAshtakootUI(ashtakootResponse!)
                      : const Center(
                          child:
                              CircularProgressIndicator()) //const Center(child: Text("No data available")),
                  ),
          // Other Tabs
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(5.0),
                  child: aggregateResponse != null
                      ? _buildAggregateUI()
                      : const Center(child: CircularProgressIndicator()),
                ),
          // const Center(child: Text("Rajju Vedha")),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(5.0),
                  child: nakshatraResponse != null
                      ? _buildNakshatraMatchUI(nakshatraResponse!)
                      : const Center(
                          child:
                              CircularProgressIndicator()) //const Center(child: Text("No data available")),
                  ),
          // const Center(child: Text("Papasamaya Match")),
        ],
      ),
    );
  }

  Widget _buildNakshatraMatchUI(Map<String, dynamic> nakshatraMatchResponse) {
    final response = nakshatraMatchResponse['response'];

    // Extract the bot response and overall score
    final botResponse = response['bot_response'] ?? "No response available";
    final score = response['score'] ?? 0;

    // Generate a list of all nakshatra matches
    final nakshatraMatches = [
      response['dina'],
      response['gana'],
      response['mahendra'],
      response['sthree'],
      response['yoni'],
      response['rasi'],
      response['rasiathi'],
      response['vasya'],
      response['rajju'],
      response['vedha'],
    ];

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Score
            _buildScoreCard("Overall Score", "$score / 10"),
            const SizedBox(height: 16.0),

            // Nakshatra Matches
            ...nakshatraMatches
                .map((nakshatra) => _buildNakshatraCard(nakshatra)),

            const SizedBox(height: 16.0),

            // Bot Response
            Text(
              botResponse,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNakshatraCard(Map<String, dynamic> nakshatra) {
    final boyDetail =
        "${nakshatra['boy_star'] ?? nakshatra['boy_gana'] ?? nakshatra['boy_yoni'] ?? nakshatra['boy_rasi'] ?? nakshatra['boy_lord'] ?? ''}";
    final girlDetail =
        "${nakshatra['girl_star'] ?? nakshatra['girl_gana'] ?? nakshatra['girl_yoni'] ?? nakshatra['girl_rasi'] ?? nakshatra['girl_lord'] ?? ''}";
    final description = nakshatra['description'] ?? "No description available";
    final score = nakshatra[nakshatra['name'].toLowerCase()] ?? 0;
    final fullScore = nakshatra['full_score'] ?? 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 214, 92),
            Color.fromARGB(255, 255, 227, 150)
          ], // Yellow gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.orange, // Border color
          width: 2.0, // Border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nakshatra Name
          Text(
            nakshatra['name'] ?? "Unknown Nakshatra",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8.0),

          // Description
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12.0),

          // Details for Boy and Girl
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailWithIcon("Boy", boyDetail, Icons.male, Colors.blue),
              _buildDetailWithIcon(
                  "Girl", girlDetail, Icons.female, Colors.pink),
            ],
          ),
          const SizedBox(height: 12.0),

          // Score with Progress Bar
          const Text(
            "Score",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: score / fullScore,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    score == fullScore ? Colors.green : Colors.orange,
                  ),
                  minHeight: 8.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                "$score / $fullScore",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: score == fullScore ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailWithIcon(
      String title, String detail, IconData icon, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20.0),
        const SizedBox(width: 6.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              detail,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAggregateUI() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (aggregateResponse == null) {
      return const Center(child: Text("No data available"));
    }

    final response = aggregateResponse!['response'];

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compatibility Scores
            _buildScoreCard("Ashtakoot Score", response['ashtakoot_score']),
            _buildScoreCard("Dashkoot Score", response['dashkoot_score']),
            const SizedBox(height: 16.0),

            // Dosha Analysis (Updated with more details)
            _buildDoshaCard(
              "Mangal Dosh",
              response['mangaldosh'] == false,
              response['mangaldosh'],
              response['mangaldosh_points'],
            ),
            _buildDoshaCard(
              "Pitra Dosh",
              response['pitradosh'] == false,
              response['pitradosh'],
              response['pitradosh_points'],
            ),
            _buildDoshaCard(
              "Kaal Sarp Dosh",
              response['kaalsarpdosh'] == false,
              response['kaalsarpdosh'],
              response['kaalsarp_points'],
            ),
            _buildDoshaCard(
              "Manglik dosh saturn",
              response['manglikdosh_saturn'] == false,
              response['manglikdosh_saturn'],
              response['manglikdosh_saturn_points'],
            ),
            _buildDoshaCard(
              "Manglik dosh rahuketu",
              response['manglikdosh_rahuketu'] == false,
              response['manglikdosh_rahuketu'],
              response['manglikdosh_rahuketu_points'],
            ),
            const SizedBox(height: 16.0),

            // Compatibility Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Compatibility Score",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${response['score']}%",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Extended Response
            Text(
              response['extended_response'] ?? "",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String title, String score) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)], // Green gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title Section
            Row(
              children: [
                Icon(
                  Icons.star, // Icon for aesthetics
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Score Section
            Text(
              score,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoshaCard(String title, dynamic status, String doshaText,
      Map<String, dynamic> points) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 204, 49),
            Color.fromARGB(255, 255, 227, 150)
          ], // Blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.orange, // Border color
          width: 2.0, // Border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  status == false ? Icons.check_circle : Icons.error,
                  color: status == false ? Colors.blue : Colors.redAccent,
                  size: 28,
                ),
              ],
            ),

            const SizedBox(height: 12.0),

            // Dosha Description
            Text(
              doshaText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16.0),

            // Boy's and Girl's Points Section
            if (points['boy'] != null)
              _buildDoshaPointsRow(
                "Boy's Points",
                points['boy'].toString(),
                status == false,
              ),
            if (points['girl'] != null)
              _buildDoshaPointsRow(
                "Girl's Points",
                points['girl'].toString(),
                status == false,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoshaPointsRow(String label, String value, bool isGood) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isGood ? Colors.blue : Colors.redAccent,
                ),
              ),
              const SizedBox(width: 6.0),
              Icon(
                isGood ? Icons.thumb_up : Icons.thumb_down,
                color: isGood ? Colors.blue : Colors.redAccent,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAshtakootUI(Map<String, dynamic> response) {
    final matchmaking = response['matchmaking'] as Map<String, dynamic>;
    final boyGirlDetails =
        matchmaking['boy_girl_details'] as Map<String, dynamic>;
    final ashtakoot =
        matchmaking['ashtakoot']['response'] as Map<String, dynamic>;

    final ashtakootData = [
      ashtakoot['tara'],
      ashtakoot['gana'],
      ashtakoot['yoni'],
      ashtakoot['bhakoot'],
      ashtakoot['grahamaitri'],
      ashtakoot['vasya'],
      ashtakoot['nadi'],
      ashtakoot['varna'],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEDF1F7), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle Section
          Text(
            response['sub_title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // Boy & Girl Details Section
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: const Color(0xFFF9FAFC),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Boy: ${boyGirlDetails['boy_name']} (${boyGirlDetails['boy_dob']})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Girl: ${boyGirlDetails['girl_name']} (${boyGirlDetails['girl_dob']})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 30,
            color: Colors.grey,
            thickness: 0.8,
          ),
          // Ashtakoot Details Section
          const Text(
            "Ashtakoot Details:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          ...ashtakootData.map((item) {
            return Card(
              elevation: 4, // Slightly increased elevation for depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 251, 226, 84),
                      Color.fromARGB(255, 251, 224, 151)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.orange, // Border color
                    width: 1.5, // Border width
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Score
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${item['tara'] ?? 0}/${item['full_score']}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      item['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Boy & Girl Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Boy: ${item['boy_tara'] ?? item['boy_gana'] ?? item['boy_yoni'] ?? item['boy_rasi'] ?? item['boy_lord'] ?? item['boy_vasya'] ?? item['boy_nadi'] ?? item['boy_varna']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Girl: ${item['girl_tara'] ?? item['girl_gana'] ?? item['girl_yoni'] ?? item['girl_rasi'] ?? item['girl_lord'] ?? item['girl_vasya'] ?? item['girl_nadi'] ?? item['girl_varna']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          // Total Score Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF7E0), Color(0xFFFFF0C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              ashtakoot['bot_response'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
