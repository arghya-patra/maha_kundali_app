import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/components/util.dart';
import 'package:maha_kundali_app/screens/Book%20Puja/astrologers_model.dart';
import 'package:maha_kundali_app/screens/Home/dashboardScreen.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookingPujaScreen extends StatefulWidget {
  String? pujaName;
  String? astrologerId;
  BookingPujaScreen({required this.pujaName, required this.astrologerId});
  @override
  _BookingPujaScreenState createState() => _BookingPujaScreenState();
}

class _BookingPujaScreenState extends State<BookingPujaScreen> {
  TextEditingController pujaNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  DateTime? pujaStartDate;
  DateTime? pujaEndDate;
  TimeOfDay? pujaStartTime;
  TimeOfDay? pujaEndTime;
  bool isLoading = false;
  List<String> astrologerNames = [];
  Map<String, String> astrologerMap = {};
  String? selectedAstrologer;
  String? selectedAstrologerId;
  String samagri = "Yes";
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
    pujaNameController.text = widget.pujaName!;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Set to false when loading finishes
      });
    });
    // fetchAstrologers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Pooja'),
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
              SizedBox(
                height: 10,
              ),
              if (_isLoading) ...[
                // _buildShimmerTextField(pujaNameController, "Puja Name",
                //     enable: false),
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
                _buildTextField(pujaNameController, "Puja Name", enable: false),

                // _buildDropdownSearch<String>(
                //   label: "Select Astrologer",
                //   items: astrologerNames,
                //   onChanged: (value) {
                //     setState(() {
                //       selectedAstrologer = value;
                //       selectedAstrologerId = astrologerMap[value!];
                //     });
                //     print('Selected Astrologer ID: $selectedAstrologerId');
                //   },
                // ),
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
                _buildTextField(pincodeController, "Pin Code"),
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
                SizedBox(
                  height: 16,
                ),
                _buildDropdown(
                  context,
                  "Extra Samagri(Chargeble)",
                  ["Yes", "No"],
                  samagri,
                  (value) {
                    setState(() {
                      samagri = value!;
                    });
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                // Container(
                //   height: 60,
                //   decoration: BoxDecoration(
                //     border:
                //         Border.all(color: Colors.black), // Outline border color
                //     borderRadius: BorderRadius.circular(
                //         5.0), // Border radius for rounded corners
                //   ),
                //   child: DropdownButton<String>(
                //     isExpanded: true,
                //     value: samagri,
                //     underline:
                //         const SizedBox(), // Remove default underline for a cleaner look
                //     dropdownColor: Colors.white, // Dropdown menu color
                //     icon: const Icon(Icons.arrow_drop_down,
                //         color: Colors.deepOrange), // Custom dropdown icon
                //     items: ["Yes", "No"].map((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(
                //           value,
                //           style: TextStyle(
                //             color: Colors.grey[800], // Custom text color
                //             fontSize: 16,
                //           ),
                //         ),
                //       );
                //     }).toList(),
                //     onChanged: (value) {
                //       setState(() {
                //         samagri = value!;
                //       });
                //     },
                //   ),
                // ),
                // SizedBox(
                //   height: 16,
                // ),
                _buildTextField(commentController,
                    "Special Instrcution for Pooja [optional]",
                    maxlines: 4),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //   bookPuja(context);
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

  Widget _buildShimmerTextField(TextEditingController controller, String label,
      {enable}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: TextFormField(
        enabled: enable,
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

  Widget _buildTextField(TextEditingController controller, String label,
      {enable, maxlines}) {
    return TextFormField(
      controller: controller,
      enabled: enable,
      maxLines: maxlines,
      decoration: InputDecoration(
        //  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                  ? DateFormat('dd-MM-YYYY').format(selectedDate)
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
                ? DateFormat('dd-MM-yyyy').format(selectedDate)
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

  Widget _buildDropdown(BuildContext context, String label, List<String> items,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(label),
          value: selectedValue,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  bookPuja(context) async {
    print(pujaStartDate);
    print(pujaEndDate);
    print(pujaStartTime);
    print(pujaEndTime);

    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    print(url.toString());
    try {
      var res = await http.post(Uri.parse(url), body: {
        'action': 'booking-puja',
        'authorizationToken': ServiceManager.tokenID,
        'service': widget.pujaName,
        'astrologer_id': widget.astrologerId,
        'state_id': '1998',
        'city_id': '79974',
        'address': addressController.text,
        'pincode': pincodeController.text,
        'map_url': 'map',
        'puja_from_date': pujaStartDate,
        'puja_to_date': pujaEndDate,
        'puja_from_time': pujaStartTime,
        'puja_to_time': pujaEndDate,
        'comment': commentController.text,
        'samagri': samagri
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
