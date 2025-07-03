import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:maha_kundali_app/screens/AstrologerProfile/astrologerProfileDetail.dart';

class LiveAstrologerListScreen extends StatefulWidget {
  bool isChat = false;
  LiveAstrologerListScreen({super.key, required this.isChat});
  @override
  _LiveAstrologerListScreenState createState() =>
      _LiveAstrologerListScreenState();
}

class _LiveAstrologerListScreenState extends State<LiveAstrologerListScreen> {
  Future<List<dynamic>>? astrologers;
  List<dynamic> astrologerList = [];
  List<dynamic> filteredList = [];

  Set<String> selectedSkills = {};
  Set<String> selectedLanguages = {};
  Set<String> allSkills = {};
  Set<String> allLanguages = {};

  @override
  void initState() {
    super.initState();
    astrologers = fetchAstrologers();
  }

  Future<List<dynamic>> fetchAstrologers() async {
    var body1 = {
      'action': 'astrologer-list',
      'authorizationToken': ServiceManager.tokenID,
      'sortby': 'live'
    };
    var body2 = {
      'action': 'astrologer-list',
      'authorizationToken': ServiceManager.tokenID,
    };
    final response = await http.post(Uri.parse(APIData.login),
        body: widget.isChat! ? body1 : body2);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      astrologerList = data['list'];
      filteredList = List.from(astrologerList);

      for (var astro in astrologerList) {
        for (var skill in astro['skills']) {
          allSkills.add(skill['name']);
        }
        for (var lang in astro['langs']) {
          allLanguages.add(lang['name']);
        }
      }

      return filteredList;
    } else {
      throw Exception('Failed to load astrologers');
    }
  }

  void _applyFilters() {
    setState(() {
      filteredList = astrologerList.where((astro) {
        final astroSkills = astro['skills'].map((s) => s['name']).toSet();
        final astroLangs = astro['langs'].map((l) => l['name']).toSet();

        final skillMatch = selectedSkills.isEmpty ||
            selectedSkills.intersection(astroSkills).isNotEmpty;
        final langMatch = selectedLanguages.isEmpty ||
            selectedLanguages.intersection(astroLangs).isNotEmpty;

        return skillMatch && langMatch;
      }).toList();
    });
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter by Skills",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          /// Scrollable row for skills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: allSkills.map((skill) {
                final isSelected = selectedSkills.contains(skill);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        isSelected
                            ? selectedSkills.remove(skill)
                            : selectedSkills.add(skill);
                        _applyFilters();
                      });
                    },
                    selectedColor: Colors.orange,
                    checkmarkColor: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
          const Text(
            "Filter by Languages",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          /// Scrollable row for languages
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: allLanguages.map((lang) {
                final isSelected = selectedLanguages.contains(lang);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(lang),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        isSelected
                            ? selectedLanguages.remove(lang)
                            : selectedLanguages.add(lang);
                        _applyFilters();
                      });
                    },
                    selectedColor: Colors.deepOrange,
                    checkmarkColor: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Astrologers'),
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
        body: FutureBuilder<List<dynamic>>(
          future: astrologers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return astrologerList.isEmpty
                  ? Center(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.orange.shade50,
                        margin: const EdgeInsets.all(24),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 32, horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_off,
                                size: 60,
                                color: Colors.deepOrange,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No Astrologers Available",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Please check back later or try refreshing.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFilterChips(), // filters now scroll with rest of content
                          const SizedBox(height: 12),
                          ListView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), // disable internal scroll
                            shrinkWrap:
                                true, // let ListView take only needed space
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final astrologer = filteredList[index];
                              return _buildAstrologerCard(astrologer);
                            },
                          ),
                        ],
                      ),
                    );
            }
          },
        ));
  }

  Widget _buildAstrologerCard(Map astrologer) {
    int totalRate = int.tryParse(astrologer['Details']['total_rate']) ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AstrologerProfileScreen(
              id: astrologer['Details']['user_id'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                astrologer['Details']['logo'],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 0,
                            left: 0,
                            child: Icon(Icons.verified,
                                color: Colors.blue, size: 20),
                          ),
                          widget.isChat!
                              ? const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                      radius: 8, backgroundColor: Colors.green),
                                )
                              : const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                      radius: 8, backgroundColor: Colors.red),
                                ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < totalRate ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
                      ),
                      Text(
                        '(${astrologer['Details']['total_review']} Reviews)',
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          astrologer['Details']['name'],
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Experience: ${astrologer['Details']['experience']}',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[700]),
                        ),
                        Text(
                          'Specialization: ${_getSkills(astrologer['skills'])}',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[700]),
                        ),
                        Text(
                          'Languages: ${_getLanguages(astrologer['langs'])}',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${astrologer['Details']['call_rate']}/min',
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: const Color(0xFFE0F7EF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        icon: const Icon(Icons.chat, color: Color(0xFF07A91E)),
                        label: const Text(
                          'Chat',
                          style: TextStyle(
                              color: Color(0xFF07A91E),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: const Color(0xFFE0F7EF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        icon: const Icon(Icons.phone, color: Color(0xFF07A91E)),
                        label: const Text(
                          'Call',
                          style: TextStyle(
                              color: Color(0xFF07A91E),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSkills(List<dynamic> skills) {
    return skills.map((skill) => skill['name']).join(', ');
  }

  String _getLanguages(List<dynamic> langs) {
    return langs.map((lang) => lang['name']).join(', ');
  }
}
