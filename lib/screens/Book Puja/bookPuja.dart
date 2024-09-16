import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Home/dashboardScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookingPujaScreen extends StatefulWidget {
  @override
  _BookingPujaScreenState createState() => _BookingPujaScreenState();
}

class _BookingPujaScreenState extends State<BookingPujaScreen> {
  TextEditingController pujaNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  DateTime? pujaStartDate;
  DateTime? pujaEndDate;
  TimeOfDay? pujaStartTime;
  TimeOfDay? pujaEndTime;
  bool isLoading = false;
  List<String> astrologerNames = [];
  Map<String, String> astrologerMap = {};
  String? selectedAstrologer;
  String? selectedAstrologerId;
  List<String> states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];

  Map<String, List<String>> citiesByState = {
    "Andhra Pradesh": ["Visakhapatnam", "Vijayawada", "Guntur", "Nellore"],
    "Maharashtra": ["Mumbai", "Pune", "Nagpur", "Thane"],
    "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai", "Tiruchirappalli"],
    // Add more states and cities here...
  };

  List<String> cities = [];
  bool _isLoading = true; // Add this variable

  @override
  void initState() {
    super.initState();
    // Simulate data loading
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Set to false when loading finishes
      });
    });
    fetchAstrologers();
  }

  Future<void> fetchAstrologers() async {
    print(ServiceManager.tokenID);
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    print(url.toString());
    try {
      var res = await http.post(Uri.parse(url), body: {
        'action': 'astrologer-list',
        'authorizationToken': ServiceManager.tokenID,
      });
      print(res.body);
      print(res.statusCode);
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        print(res.body);
        List<dynamic> astrologerList = data["list"];

        for (var astrologer in astrologerList) {
          String name = astrologer["Details"]["name"];
          String id = astrologer["Details"]["user_id"];
          astrologerNames.add(name);
          astrologerMap[name] = id;
        }

        setState(() {
          isLoading = false;
        });
        print(data['status']);
        print(data['authorizationToken']);
        //  toastMessage(message: 'Booking Successful!');
      } else {
        toastMessage(message: 'Something went wrong');
      }
    } catch (e) {
      toastMessage(message: e.toString());
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
        title: const Text('Book Puja'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading) ...[
                _buildShimmerTextField(pujaNameController, "Puja Name"),
                const SizedBox(height: 16),
                _buildShimmerDropdownSearch<String>(
                  label: "Select Astrologer",
                  items: astrologerNames,
                  onChanged: (value) {
                    setState(() {
                      selectedAstrologer = value;
                      selectedAstrologerId = astrologerMap[value!];
                    });
                    print('Selected Astrologer ID: $selectedAstrologerId');
                  },
                ),
                const SizedBox(height: 16),
                _buildShimmerDropdownSearch<String>(
                  label: "Select State",
                  items: states,
                  onChanged: (state) {},
                ),
                const SizedBox(height: 16),
                _buildShimmerDropdownSearch<String>(
                  label: "Select City",
                  items: cities,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                _buildShimmerTextField(addressController, "Address"),
                const SizedBox(height: 16),
                _buildShimmerDatePicker(
                  context: context,
                  label: "Puja Start Date",
                  selectedDate: pujaStartDate,
                  onDateSelected: (date) {},
                ),
                const SizedBox(height: 16),
                _buildShimmerDatePicker(
                  context: context,
                  label: "Puja End Date",
                  selectedDate: pujaEndDate,
                  onDateSelected: (date) {},
                ),
                const SizedBox(height: 16),
                _buildShimmerTimePicker(
                  context: context,
                  label: "Puja Start Time",
                  selectedTime: pujaStartTime,
                  onTimeSelected: (time) {},
                ),
                const SizedBox(height: 16),
                _buildShimmerTimePicker(
                  context: context,
                  label: "Puja End Time",
                  selectedTime: pujaEndTime,
                  onTimeSelected: (time) {},
                ),
              ] else ...[
                _buildTextField(pujaNameController, "Puja Name"),
                const SizedBox(height: 16),
                _buildDropdownSearch<String>(
                  label: "Select Astrologer",
                  items: astrologerNames,
                  onChanged: (value) {
                    setState(() {
                      selectedAstrologer = value;
                      selectedAstrologerId = astrologerMap[value!];
                    });
                    print('Selected Astrologer ID: $selectedAstrologerId');
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownSearch<String>(
                  label: "Select State",
                  items: states,
                  onChanged: (state) {
                    setState(() {
                      cities = citiesByState[state!] ?? [];
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownSearch<String>(
                  label: "Select City",
                  items: cities,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                _buildTextField(addressController, "Address"),
                const SizedBox(height: 16),
                _buildDatePicker(
                  context: context,
                  label: "Puja Start Date",
                  selectedDate: pujaStartDate,
                  onDateSelected: (date) => setState(() {
                    pujaStartDate = date;
                  }),
                ),
                const SizedBox(height: 16),
                _buildDatePicker(
                  context: context,
                  label: "Puja End Date",
                  selectedDate: pujaEndDate,
                  onDateSelected: (date) => setState(() {
                    pujaEndDate = date;
                  }),
                ),
                const SizedBox(height: 16),
                _buildTimePicker(
                  context: context,
                  label: "Puja Start Time",
                  selectedTime: pujaStartTime,
                  onTimeSelected: (time) => setState(() {
                    pujaStartTime = time;
                  }),
                ),
                const SizedBox(height: 16),
                _buildTimePicker(
                  context: context,
                  label: "Puja End Time",
                  selectedTime: pujaEndTime,
                  onTimeSelected: (time) => setState(() {
                    pujaEndTime = time;
                  }),
                ),
              ],
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    bookPuja(context);
                    // Handle form submission
                  },
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerTextField(
      TextEditingController controller, String label) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildShimmerDropdownSearch<T>({
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: DropdownSearch<T>(
        items: items,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        popupProps: const PopupProps.dialog(
          showSearchBox: true,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownSearch<T>({
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownSearch<T>(
      items: items,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      popupProps: const PopupProps.dialog(
        showSearchBox: true,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildShimmerDatePicker({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required ValueChanged<DateTime?> onDateSelected,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GestureDetector(
        onTap: () {},
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            controller: TextEditingController(
              text: selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedDate)
                  : '',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required ValueChanged<DateTime?> onDateSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          controller: TextEditingController(
            text: selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(selectedDate)
                : '',
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerTimePicker({
    required BuildContext context,
    required String label,
    required TimeOfDay? selectedTime,
    required ValueChanged<TimeOfDay?> onTimeSelected,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GestureDetector(
        onTap: () {},
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            controller: TextEditingController(
              text: selectedTime != null ? selectedTime.format(context) : '',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required String label,
    required TimeOfDay? selectedTime,
    required ValueChanged<TimeOfDay?> onTimeSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (time != null) {
          onTimeSelected(time);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          controller: TextEditingController(
            text: selectedTime != null ? selectedTime.format(context) : '',
          ),
        ),
      ),
    );
  }

  bookPuja(context) async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    print(url.toString());
    try {
      var res = await http.post(Uri.parse(url), body: {
        'action': 'booking-puja',
        'authorizationToken': ServiceManager.tokenID,
        'service': 'Asht Lakshmi Pooja',
        'astrologer_id': '605',
        'state_id': '1998',
        'city_id': '79974',
        'address': 'Ab 97 sealdah',
        'pincode': '700100',
        'map_url': 'map',
        'puja_from_date': '10-08-2024',
        'puja_to_date': '15-08-2024',
        'puja_from_time': '06:47',
        'puja_to_time': '09:43',
        'comment': 'message for book puja from app',
        'samagri': 'yes'
      });
      var data = jsonDecode(res.body);
      if (data['status'] == 200) {
        print(data['status']);
        print(data['authorizationToken']);
        toastMessage(message: 'Booking Successful!');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
            (route) => false);
      } else {
        toastMessage(message: 'Something went wrong');
      }
    } catch (e) {
      toastMessage(message: e.toString());
      setState(() {
        isLoading = false;
      });
    }

    return 'Success';
  }
}
