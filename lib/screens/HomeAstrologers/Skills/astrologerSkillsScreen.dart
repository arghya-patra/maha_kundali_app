import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class AstrologerSkillsScreen extends StatefulWidget {
  @override
  _AstrologerSkillsScreenState createState() => _AstrologerSkillsScreenState();
}

class _AstrologerSkillsScreenState extends State<AstrologerSkillsScreen> {
  List<dynamic> skills = [];
  List<String> selectedSkillIds = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchSkills();
  }

  Future<void> fetchSkills() async {
    setState(() {
      isLoading = true;
    });
    // Simulated API call
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'astrologer-skill-puja-lang',
      'authorizationToken': ServiceManager.tokenID,
      'mode': 'view',
      'attribute': 'skill'
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        skills = data['all_skills'];
        selectedSkillIds = skills
            .where((skill) => skill['checked'] == 1)
            .map<String>((skill) => skill['id'])
            .toList();
        isLoading = false;
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load skills')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendSkills(skills) async {
    setState(() {
      isLoading = true;
    });
    // Simulated API call
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'astrologer-skill-puja-lang',
      'authorizationToken': ServiceManager.tokenID,
      'mode': 'edit',
      'attribute': 'skill',
      'value': skills
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Skills Updated"),
      ));
      // setState(() {
      //   skills = data['all_skills'];
      // });
      setState(() {
        isLoading = false;
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to Edit skills')),
      );
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void handleCheckboxChange(bool? value, String skillId) {
    setState(() {
      if (value == true) {
        selectedSkillIds.add(skillId);
      } else {
        selectedSkillIds.remove(skillId);
      }
    });
  }

  void handleSubmit() {
    String selectedSkillsString = selectedSkillIds.join(',');
    sendSkills(selectedSkillsString);
    print('Selected Skill IDs: $selectedSkillIds');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrologer Skills'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: skills.isEmpty || isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Your Skills',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: skills.length,
                      itemBuilder: (context, index) {
                        final skill = skills[index];
                        return CheckboxListTile(
                          value: selectedSkillIds.contains(skill['id']),
                          title: Text(
                            skill['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onChanged: (value) =>
                              handleCheckboxChange(value, skill['id']),
                          activeColor: Colors.deepOrange,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
