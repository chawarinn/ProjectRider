// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GPSandMapPage extends StatefulWidget {
  const GPSandMapPage({super.key});

  @override
  State<GPSandMapPage> createState() => _GPSandMapPageState();
}

class _GPSandMapPageState extends State<GPSandMapPage> {
   int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'navigation map',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ปุ่มย้อนกลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: Column(
        children: [
          // Map section
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: latLng,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OpenStreetMap
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: latLng,
                      width: 40,
                      height: 40,
                      child: Container(
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // First image upload section
          //  Text('เพิ่มรูปภาพ ประกอบสถานะ'),
          Padding(
            
            padding: const EdgeInsets.all(10.0),
            child: Row(
              
              children: [
                
                Expanded(
                  
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      
                      children: const [
                        
                        Icon(Icons.add, size: 50),
                      
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Save image logic
                  },
                  child: const Text('บันทึก'),
                ),
              ],
            ),
          ),
          // Second image upload section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                   
                    child: Column(
                      children: const [
                        Icon(Icons.add, size: 50),
                        // Text('เพิ่มรูปภาพ ประกอบสถานะ'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: const Text('บันทึก'),
                ),
              ],
            ),
          ),
          // Finish button
        const SizedBox(height: 20),
            Center( 
              child: ElevatedButton(
               onPressed: () {
                    
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 11, 102, 35),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                
                child: const Text(
                  'รับงาน',
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 22, 12, 12)),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
         
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Delivery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 126, 15),
        unselectedItemColor: Colors.grey,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        onTap: _onItemTapped,
      ),
    );
  }

  // Determine current GPS position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
