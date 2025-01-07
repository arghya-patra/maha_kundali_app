import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart'; // for formatting date/time
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/service/serviceManager.dart';

class AstrologerAvailability extends StatefulWidget {
  const AstrologerAvailability({Key? key}) : super(key: key);

  @override
  State<AstrologerAvailability> createState() => _AstrologerAvailabilityState();
}

class _AstrologerAvailabilityState extends State<AstrologerAvailability> {
  List<dynamic> availabilities = [];
  bool isLoading = false;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? selDate = '';

  @override
  void initState() {
    super.initState();
    fetchAvailability();
  }

  Future<void> fetchAvailability() async {
    // Simulating API call
    setState(() {
      isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-availability',
        'authorizationToken': ServiceManager.tokenID,
      });
      print(response);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) {
          // print(["&*&*&*&*", data]);
          setState(() {
            availabilities = data['availability_list'] ?? [];
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
      debugPrint('Error fetching List: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void addAvailability(String? day, String startTime, String endTime) async {
    // TODO: Implement API call to add availability
    print("Adding availability: $day, $startTime - $endTime");
    setState(() {
      isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-availability',
        'authorizationToken': ServiceManager.tokenID,
        'day': day,
        'start_time': startTime,
        'end_time': endTime
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) {
          print(["_____", data]);
          setState(() {
            //  vacationList = data['list'] ?? [];
            fetchAvailability();
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Availability Updated"),
              backgroundColor: Colors.green,
            ),
          );
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
      debugPrint('Error fetching Data: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void deleteAvailabilityBYId(id) async {
    // TODO: Implement API call to add availability
    print(["rrrrr", id]);
    setState(() {
      isLoading = true;
    });
    try {
      String url = APIData.login;
      var response = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-availability',
        'authorizationToken': ServiceManager.tokenID,
        'delete_id': id
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) {
          print(["+++++++", data]);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Availability deleted"),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            //  vacationList = data['list'] ?? [];
            fetchAvailability();
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
      debugPrint('Error fetching Data: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void deleteAvailability(id) {
    // TODO: Implement API call to delete availability
    deleteAvailabilityBYId(id);
    print("Deleting availability with id: $id");
  }

  void showAddAvailabilityDialog(BuildContext context) {
    final days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Center(
            child: Text(
              'Add Availability',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: days[0],
                items: days
                    .map(
                        (day) => DropdownMenuItem(value: day, child: Text(day)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selDate = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Select Day",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: startTimeController,
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _startTime = picked;
                      String formattedStartTime =
                          "${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00";
                      startTimeController.text = formattedStartTime;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "Start Time (HH:MM)",
                  hintText: 'Select Start Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                readOnly: true,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: endTimeController,
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _endTime = picked;
                      String formattedEndTime =
                          "${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00";
                      endTimeController.text = formattedEndTime;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "End Time (HH:MM)",
                  hintText: 'Select End Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                readOnly: true,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    final day = selDate;
                    final startTime = _startTime.toString();
                    addAvailability(
                        day, startTimeController.text, endTimeController.text);
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Availability',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
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
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => showAddAvailabilityDialog(context),
            tooltip: "Add Availability",
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
              ),
            )
          : availabilities.isEmpty
              ? const Center(
                  child: Text(
                    "No Availabilities found.",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: availabilities.length,
                  itemBuilder: (context, index) {
                    final availability = availabilities[index];
                    final formattedStartTime = DateFormat.Hm().format(DateTime(
                      2000,
                      1,
                      1,
                      int.parse(availability["start_time"].split(":")[0]),
                      int.parse(availability["start_time"].split(":")[1]),
                    ));
                    final formattedEndTime = DateFormat.Hm().format(DateTime(
                      2000,
                      1,
                      1,
                      int.parse(availability["end_time"].split(":")[0]),
                      int.parse(availability["end_time"].split(":")[1]),
                    ));

                    return Card(
                      elevation: 6.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side:
                            BorderSide(color: Colors.orangeAccent, width: 1.5),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          child: Text(
                            availability["day"][0],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          '${availability["day"]} - $formattedStartTime to $formattedEndTime',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              deleteAvailability(availability["id"]),
                          tooltip: "Delete Availability",
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
