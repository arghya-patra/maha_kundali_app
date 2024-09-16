// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:maha_kundali_app/apiManager/apiData.dart';
// import 'package:maha_kundali_app/screens/panchang/panchangScreen.dart';
// import 'package:maha_kundali_app/screens/panchang/panchang_model.dart';
// import 'package:maha_kundali_app/service/serviceManager.dart';
// import 'package:http/http.dart' as http;
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:place_picker/place_picker.dart';

// class KundliFormScreen extends StatefulWidget {
//   @override
//   _KundliFormScreenState createState() => _KundliFormScreenState();
// }

// class _KundliFormScreenState extends State<KundliFormScreen> {
//   DateTime selectedDate = DateTime.now();
//   String selectedHour = "1";
//   String selectedMinute = "1";
//   String selectedLanguage = "English";
//   String selectedTimezone = "IST";
//   String birthPlace = "kolkata";
//   String formattedDate = "";
//   submitData() async {
//     String url = APIData.login;
//     print(url.toString());
//     final response = await http.post(Uri.parse(url), body: {
//       'action': 'free-service-type',
//       'authorizationToken': ServiceManager.tokenID,
//       'type': 'panchang',
//       'date': formattedDate,
//       'hr': selectedHour,
//       'min': selectedMinute,
//       'pob': birthPlace,
//       'lang': 'en',
//       'lat': '22.54111111',
//       'lon': '88.33777778'
//     });
//     print(response.body);

//     if (response.statusCode == 200) {
//       return Panchang.fromJson(
//           jsonDecode(response.body)['panchang']['panchang']['response']);
//     } else {
//       throw Exception('Failed to load horoscope details');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Know Your Panchang"),
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildLabel('Select Date of Birth'),
//               GestureDetector(
//                 onTap: () => _selectDate(context),
//                 child: _buildFieldContainer(
//                   child: Text(
//                     "${selectedDate.toLocal()}".split(' ')[0],
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const SizedBox(height: 16),
//               _buildLabel('Reporting Language'),
//               _buildFieldContainer(
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   value: selectedLanguage,
//                   underline: const SizedBox(),
//                   items: ["English", "Hindi"].map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedLanguage = value!;
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               _buildLabel('Birth Place'),
//               GestureDetector(
//                 onTap: () async {
//                   // LocationResult result = await Navigator.of(context).push(
//                   //   MaterialPageRoute(
//                   //     builder: (context) => PlacePicker(
//                   //       "YOUR_GOOGLE_API_KEY",
//                   //     ),
//                   //   ),
//                   // );

//                   // setState(() {
//                   //   birthPlace = result.formattedAddress!;
//                   // });
//                 },
//                 child: _buildFieldContainer(
//                   child: Text(
//                     birthPlace.isEmpty ? "Pick a location" : birthPlace,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               _buildLabel('Timezone'),
//               _buildFieldContainer(
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   value: selectedTimezone,
//                   underline: const SizedBox(),
//                   items: ["IST", "GMT", "PST", "EST"].map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedTimezone = value!;
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     elevation: 5,
//                   ),
//                   onPressed: () async {
//                     //submitData();
//                     Panchang panchang = await submitData();
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               PanchangScreen(panchang: panchang)),
//                     );
//                     // Handle form submission
//                   },
//                   child: const Text(
//                     'Submit',
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
//         print(formattedDate);
//         print(selectedDate);
//       });
//     }
//   }

//   Widget _buildLabel(String label) {
//     return Text(
//       label,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     );
//   }

//   Widget _buildFieldContainer({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: child,
//     );
//   }
// }
