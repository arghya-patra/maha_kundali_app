// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';

// class LocationPickerScreen extends StatefulWidget {
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }

// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   LatLng _initialPosition = LatLng(20.5937, 78.9629); // Default to India
//   late LatLng _pickedLocation;

//   late GoogleMapController _mapController;

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   void _selectLocation(LatLng position) {
//     setState(() {
//       _pickedLocation = position;
//     });
//   }

//   Future<String> _getAddressFromLatLng(LatLng position) async {
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//       position.latitude,
//       position.longitude,
//     );
//     if (placemarks.isNotEmpty) {
//       final place = placemarks.first;
//       return "${place.locality}, ${place.administrativeArea}, ${place.country}";
//     }
//     return "Unknown location";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pick a Location'),
//         backgroundColor: Colors.black,
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _initialPosition,
//           zoom: 5.0,
//         ),
//         onMapCreated: _onMapCreated,
//         onTap: _selectLocation,
//         markers: _pickedLocation == null
//             ? {}
//             : {
//                 Marker(
//                   markerId: MarkerId('selected-location'),
//                   position: _pickedLocation,
//                 ),
//               },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (_pickedLocation != null) {
//             String address = await _getAddressFromLatLng(_pickedLocation);
//             Navigator.of(context).pop(address);
//           }
//         },
//         child: Icon(Icons.check),
//         backgroundColor: Colors.black,
//       ),
//     );
//   }
// }
