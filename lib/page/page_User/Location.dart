import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295); // Default location
  MapController mapController = MapController();

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
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: latLng,
                initialZoom: 15.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    latLng = point; 
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OpenStreetMap
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
                        child: const Icon(Icons.pin_drop, color: Colors.red, size: 40), // Change to a pin icon
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Success button
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, latLng); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 11, 102, 35),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 22, 12, 12)),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}