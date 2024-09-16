// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';

// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   String? _selectedGender;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   String? _selectedPlace;

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _placeController = TextEditingController();

//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     // Simulate a loading delay
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile Register'),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.orange, Colors.deepOrange],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildShimmeringWidget(_buildTextField('Name', _nameController)),
//             const SizedBox(height: 20),
//             _buildShimmeringWidget(_buildGenderDropdown()),
//             const SizedBox(height: 20),
//             _buildShimmeringWidget(_buildDatePicker()),
//             const SizedBox(height: 20),
//             _buildShimmeringWidget(_buildTimePicker()),
//             const SizedBox(height: 20),
//             _buildShimmeringWidget(_buildPlacePicker()),
//             const SizedBox(height: 40),
//             Center(
//               child: _buildShimmeringWidget(
//                 ElevatedButton(
//                   onPressed: _isLoading
//                       ? null
//                       : () {
//                           // Handle the submission
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 15, horizontal: 60),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: const Text(
//                     'Submit',
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         // labelStyle: TextStyle(color: Colors.grey[400]),
//         filled: true,
//         // fillColor: Colors.grey[850],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       ),
//     );
//   }

//   Widget _buildGenderDropdown() {
//     return DropdownButtonFormField<String>(
//       value: _selectedGender,
//       items: ['Male', 'Female', 'Others']
//           .map((gender) => DropdownMenuItem(
//                 value: gender,
//                 child:
//                     Text(gender, style: const TextStyle(color: Colors.white)),
//               ))
//           .toList(),
//       onChanged: _isLoading
//           ? null
//           : (value) {
//               setState(() {
//                 _selectedGender = value;
//               });
//             },
//       decoration: InputDecoration(
//         labelText: 'Gender',
//         labelStyle: TextStyle(color: Colors.grey[400]),
//         filled: true,
//         fillColor: Colors.grey[850],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       ),
//       dropdownColor: Colors.grey[850],
//     );
//   }

//   Widget _buildDatePicker() {
//     return TextField(
//       controller: TextEditingController(
//         text: _selectedDate == null
//             ? ''
//             : DateFormat('yyyy-MM-dd').format(_selectedDate!),
//       ),
//       readOnly: true,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: 'Date of Birth',
//         labelStyle: TextStyle(color: Colors.grey[400]),
//         filled: true,
//         fillColor: Colors.grey[850],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
//       ),
//       onTap: _isLoading
//           ? null
//           : () async {
//               DateTime? pickedDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(1900),
//                 lastDate: DateTime.now(),
//               );
//               if (pickedDate != null) {
//                 setState(() {
//                   _selectedDate = pickedDate;
//                 });
//               }
//             },
//     );
//   }

//   Widget _buildTimePicker() {
//     return TextField(
//       controller: TextEditingController(
//         text: _selectedTime == null ? '' : _selectedTime!.format(context),
//       ),
//       readOnly: true,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: 'Time of Birth',
//         labelStyle: TextStyle(color: Colors.grey[400]),
//         filled: true,
//         fillColor: Colors.grey[850],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         suffixIcon: const Icon(Icons.access_time, color: Colors.white),
//       ),
//       onTap: _isLoading
//           ? null
//           : () async {
//               TimeOfDay? pickedTime = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.now(),
//               );
//               if (pickedTime != null) {
//                 setState(() {
//                   _selectedTime = pickedTime;
//                 });
//               }
//             },
//     );
//   }

//   Widget _buildPlacePicker() {
//     return TextField(
//       controller: _placeController,
//       readOnly: true,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: 'Place of Birth',
//         labelStyle: TextStyle(color: Colors.grey[400]),
//         filled: true,
//         fillColor: Colors.grey[850],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         suffixIcon: const Icon(Icons.location_on, color: Colors.white),
//       ),
//       onTap: _isLoading
//           ? null
//           : () async {
//               // final selectedPlace = await Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => LocationPickerScreen(),
//               //   ),
//               // );

//               // if (selectedPlace != null) {
//               //   setState(() {
//               //     _selectedPlace = selectedPlace;
//               //     _placeController.text = _selectedPlace!;
//               //   });
//               // }
//             },
//     );
//   }

//   Widget _buildShimmeringWidget(Widget child) {
//     if (_isLoading) {
//       return Shimmer.fromColors(
//         baseColor: Colors.grey[800]!,
//         highlightColor: Colors.grey[700]!,
//         child: child,
//       );
//     } else {
//       return child;
//     }
//   }
// }
