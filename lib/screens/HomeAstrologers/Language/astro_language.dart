import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class AstrologerLangScreen extends StatefulWidget {
  @override
  _AstrologerLangScreenState createState() => _AstrologerLangScreenState();
}

class _AstrologerLangScreenState extends State<AstrologerLangScreen> {
  List<dynamic> langs = [];
  List<String> selectedLangIds = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchLanguage();
  }

  Future<void> fetchLanguage() async {
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
      'attribute': 'lang'
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        langs = data['all_langs'];
        selectedLangIds = langs
            .where((skill) => skill['checked'] == 1)
            .map<String>((skill) => skill['id'])
            .toList();
        isLoading = false;
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load Language')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendSkills(lang) async {
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
      'attribute': 'lang',
      'value': lang
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Language Updated"),
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
        const SnackBar(content: Text('Failed to Edit Language')),
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
        selectedLangIds.add(skillId);
      } else {
        selectedLangIds.remove(skillId);
      }
    });
  }

  void handleSubmit() {
    String selectedSkillsString = selectedLangIds.join(',');
    sendSkills(selectedSkillsString);
    print('Selected Language IDs: $selectedLangIds');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrologer Language'),
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
      body: langs.isEmpty || isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Your Language',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: langs.length,
                      itemBuilder: (context, index) {
                        final lang = langs[index];
                        return CheckboxListTile(
                          value: selectedLangIds.contains(lang['id']),
                          title: Text(
                            lang['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onChanged: (value) =>
                              handleCheckboxChange(value, lang['id']),
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
