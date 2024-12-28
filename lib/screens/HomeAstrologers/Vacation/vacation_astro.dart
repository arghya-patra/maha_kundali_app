import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/service/serviceManager.dart';

class VacationListScreen extends StatefulWidget {
  @override
  _VacationListScreenState createState() => _VacationListScreenState();
}

class _VacationListScreenState extends State<VacationListScreen> {
  // Mock vacation list (to be replaced by API data)
  List<dynamic> vacationList = [];

  // Controllers for the form fields
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // Date format
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchVacationList();
  }

  Future<void> fetchVacationList() async {
    // Simulating API call
    setState(() {
      isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-vacation',
        'authorizationToken': ServiceManager.tokenID,
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) {
          print(["&*&*&*&*", data]);
          setState(() {
            vacationList = data['list'] ?? [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching products: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> addVcation(startDate, endDate) async {
    // Simulating API call
    setState(() {
      isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-vacation',
        'authorizationToken': ServiceManager.tokenID,
        'from_date': startDate,
        'to_date': endDate
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) {
          print(["&*&*&*&*", data]);
          setState(() {
            //  vacationList = data['list'] ?? [];
            fetchVacationList();
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching Vacations: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteVcation(id) async {
    // Simulating API call
    setState(() {
      isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-vacation',
        'authorizationToken': ServiceManager.tokenID,
        'delete_id': id
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) {
          print(["&*&*&*&*", data]);
          setState(() {
            //  vacationList = data['list'] ?? [];
            fetchVacationList();
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching Vacations: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void _showAddVacationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Vacation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Start Date Picker
              TextField(
                controller: startDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Start Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    startDateController.text = dateFormat.format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 16),

              // End Date Picker
              TextField(
                controller: endDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "End Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    endDateController.text = dateFormat.format(pickedDate);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Print the vacation data
                print("Start Date: ${startDateController.text}");
                print("End Date: ${endDateController.text}");
                String formattedStartDate = DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(startDateController.text));
                String formattedEndDate = DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(endDateController.text));
                addVcation(formattedStartDate, formattedEndDate);

                // Add the vacation to the list (temporary mock, replace with API call)
                // setState(() {
                //   vacationList.add({
                //     "id": DateTime.now().millisecondsSinceEpoch.toString(),
                //     "from_date": startDateController.text,
                //     "to_date": endDateController.text,
                //   });
                // });

                // Clear controllers and close dialog
                startDateController.clear();
                endDateController.clear();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteVacation(String id) {
    print("Delete Vacation ID: $id");
    deleteVcation(id);
    // setState(() {
    //   vacationList.removeWhere((vacation) => vacation["id"] == id);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vacation List"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddVacationDialog,
            tooltip: "Add Vacation",
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : vacationList.isEmpty
              ? const Center(child: Text("No vacations found."))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text(
                            'From Date',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'To Date',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Actions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                      rows: vacationList.map((vacation) {
                        return DataRow(
                          cells: [
                            DataCell(Text(
                              vacation['from_date']!,
                              style: const TextStyle(fontSize: 14),
                            )),
                            DataCell(Text(
                              vacation['to_date']!,
                              style: const TextStyle(fontSize: 14),
                            )),
                            DataCell(
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deleteVacation(vacation["id"]!),
                                tooltip: "Delete Vacation",
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}
