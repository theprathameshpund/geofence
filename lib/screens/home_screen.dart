// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../services/geofence_service.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   Position? _currentPosition;
//   double _radius = 100; // default radius
//   GoogleMapController? _mapController;
//   final GeofenceService _geofenceService = GeofenceService();
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check service
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Location services are disabled.")),
//       );
//       return;
//     }
//
//     // Permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location permissions are denied")),
//         );
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Location permissions are permanently denied")),
//       );
//       return;
//     }
//
//     // Get current location
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() => _currentPosition = position);
//
//     _mapController?.animateCamera(
//       CameraUpdate.newLatLng(
//         LatLng(position.latitude, position.longitude),
//       ),
//     );
//
//     // Start geofence monitoring
//     _geofenceService.startMonitoring(
//       center: LatLng(position.latitude, position.longitude),
//       radius: _radius,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Geofence Demo"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(19.0760, 72.8777), // Default: Mumbai
//                 zoom: 14,
//               ),
//               onMapCreated: (controller) => _mapController = controller,
//               markers: _currentPosition != null
//                   ? {
//                 Marker(
//                   markerId: const MarkerId("current"),
//                   position: LatLng(
//                       _currentPosition!.latitude,
//                       _currentPosition!.longitude),
//                 ),
//               }
//                   : {},
//               circles: _currentPosition != null
//                   ? {
//                 Circle(
//                   circleId: const CircleId("geofence"),
//                   center: LatLng(_currentPosition!.latitude,
//                       _currentPosition!.longitude),
//                   radius: _radius,
//                   fillColor: Colors.blue.withOpacity(0.2),
//                   strokeColor: Colors.blue,
//                   strokeWidth: 2,
//                 )
//               }
//                   : {},
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: _getCurrentLocation,
//                   child: const Text("Set Current Location"),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Radius: "),
//                     Expanded(
//                       child: Slider(
//                         value: _radius,
//                         min: 50,
//                         max: 1000,
//                         divisions: 20,
//                         label: "${_radius.round()} m",
//                         onChanged: (value) {
//                           setState(() => _radius = value);
//                           if (_currentPosition != null) {
//                             _geofenceService.updateRadius(_radius);
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
