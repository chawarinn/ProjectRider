import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'; // เพิ่มการนำเข้า geolocator
import 'dart:async';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? currentLocation;
  late CameraPosition initPosition;
  Set<Marker> markers = {};
  final TextEditingController addressCtl = TextEditingController();
  List<Placemark> placemarks = [];

  @override
  void initState() {
    super.initState();
    _determinePosition(); // เรียกใช้ฟังก์ชันเพื่อกำหนดตำแหน่งปัจจุบัน
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ตรวจสอบว่าบริการตำแหน่งถูกเปิดใช้งานหรือไม่
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // บริการตำแหน่งถูกปิดให้แจ้งผู้ใช้
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // ขอการอนุญาตจากผู้ใช้
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ผู้ใช้ปฏิเสธการอนุญาต
        return Future.error('Location permissions are denied');
      }
    }

    // ตอนนี้สามารถเข้าถึงตำแหน่งได้แล้ว
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentLocation = LatLng(position.latitude, position.longitude);
    
    initPosition = CameraPosition(
      target: currentLocation!,
      zoom: 15,
    );

    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: currentLocation!,
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );

    // Update the map
    setState(() {});

    // Log the address
    placemarks = await placemarkFromCoordinates(
      currentLocation!.latitude,
      currentLocation!.longitude,
    );

    if (placemarks.isNotEmpty) {
      print('Address: ${placemarks[0].street}, ${placemarks[0].locality}');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Location',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: currentLocation == null // เช็คว่าตำแหน่งปัจจุบันมีค่าไหม
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: initPosition,
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onCameraMove: (CameraPosition position) {
                    setState(() {
                      initPosition = position; 
                    });
                  },
                ),
                Positioned(
                  bottom: 25,
                  left: 100,
                  right: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      // ฟังก์ชันการยืนยันตำแหน่ง
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7723), // เปลี่ยนสีปุ่มถ้าต้องการ
                    ),
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}




//       body: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: FlutterMap(
//               mapController: mapController,
//               options: MapOptions(
//                 initialCenter: latLng,
//                 initialZoom: 15.0,
//                 onTap: (tapPosition, point) {
//                   setState(() {
//                     latLng = point; 
//                   });
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', 
//                   userAgentPackageName: 'com.example.app',
//                 ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: latLng,
//                       width: 40,
//                       height: 40,
//                       child: Container(
//                         color: Colors.amber,
//                         child: const Icon(Icons.pin_drop, color: Colors.red, size: 40), 
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // Success button
//           const SizedBox(height: 10),
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, latLng); 
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 11, 102, 35),
//                 padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               ),
//               child: const Text(
//                 'Save',
//                 style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 22, 12, 12)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }
// }