import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/service/serviceManager.dart';

class SelectPujaScreen extends StatefulWidget {
  @override
  _SelectPujaScreenState createState() => _SelectPujaScreenState();
}

class _SelectPujaScreenState extends State<SelectPujaScreen> {
  List<dynamic> pujas = [];
  Map<String, dynamic> selectedPujas = {};
  bool isLoading = false;
  Map<String, TextEditingController> controllers = {};
  @override
  void initState() {
    super.initState();
    fetchPujas();
  }

  Future<void> fetchPujas() async {
    // Simulated API response
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
      'attribute': 'puja'
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        pujas = data['all_pujas'];
        for (var puja in pujas) {
          controllers[puja["id"]] = TextEditingController(
            text: puja["checked"] == 1 ? puja["price"].toString() : "",
          );
          if (puja['checked'] == 1) {
            selectedPujas[puja['id']] = puja['price'].toString();
          }
        }
        isLoading = false;
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load Puja')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleCheckboxChange(bool? value, String pujaId) {
    setState(() {
      if (value == true) {
        selectedPujas[pujaId] = controllers[pujaId]?.text ?? "";
      } else {
        selectedPujas.remove(pujaId);
        controllers[pujaId]?.clear();
      }
    });
  }

  void handlePriceChange(String value, String pujaId) {
    setState(() {
      selectedPujas[pujaId] = value;
    });
  }

  void handleSubmit() {
    print('Selected Pujas: $selectedPujas');
    String result = selectedPujas.entries
        .map((entry) => '${entry.key}:${entry.value}')
        .join(', ');
    sendPuja(result);
  }

  Future<void> sendPuja(puja) async {
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
      'attribute': 'puja',
      'value': puja
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Puja Selection Updated"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Puja'),
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
      body: pujas.isEmpty || isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: pujas.length,
                      itemBuilder: (context, index) {
                        final puja = pujas[index];
                        final isChecked = selectedPujas.containsKey(puja['id']);
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (value) =>
                                          handleCheckboxChange(
                                              value, puja['id']),
                                      activeColor: Colors.deepOrange,
                                      checkColor: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        puja['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isChecked)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 44.0),
                                    child: TextField(
                                      controller: controllers[puja["id"]],
                                      keyboardType: TextInputType.number,
                                      enabled:
                                          selectedPujas.containsKey(puja["id"]),
                                      decoration: const InputDecoration(
                                        labelText: "Price",
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      onChanged: (value) {
                                        if (selectedPujas
                                            .containsKey(puja["id"])) {
                                          selectedPujas[puja["id"]] = value;
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
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
