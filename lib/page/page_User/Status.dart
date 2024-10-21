import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/OrderReceiver.dart';
import 'package:mini_project_rider/page/page_User/ProfilePage.dart';
import 'package:mini_project_rider/page/page_User/Search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class StatusPage extends StatefulWidget {
  final int selectedIndex;
  final int userId;
  final int orderId;

  StatusPage({
    Key? key,
    required this.userId,
    required this.selectedIndex,
    required this.orderId,
  }) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  int? _currentIndex;
  late GoogleMapController mapController;
  final DatabaseReference _ordersRef =
      FirebaseDatabase.instance.ref().child('orders');

  LatLng _center = const LatLng(0, 0);
  Set<Marker> _markers = {};

  void _updateCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _updateMarkers();
      mapController.animateCamera(CameraUpdate.newLatLng(_center));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updateMarkers();
  }

  void _updateMarkers() {
    _markers.clear();

    _markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: _center,
        infoWindow: const InfoWindow(title: 'ตำแหน่งปัจจุบัน'),
      ),
    );

    _markers.add(
      const Marker(
        markerId: MarkerId('start'),
        position: LatLng(13.7563, 100.5018),
        infoWindow: InfoWindow(title: 'จุดเริ่มต้น'),
      ),
    );

    _markers.add(
      const Marker(
        markerId: MarkerId('end'),
        position: LatLng(13.7653, 100.5247),
        infoWindow: InfoWindow(title: 'จุดปลายทาง'),
      ),
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;

    final locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, // กำหนดความแม่นยำ
      distanceFilter: 10, // อัปเดตทุกครั้งที่เปลี่ยนตำแหน่ง 10 เมตร
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _updateMarkers(); // อัปเดต Marker ด้วยตำแหน่งใหม่
        if (mapController != null) {
          mapController.animateCamera(CameraUpdate.newLatLng(_center));
        }
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SearchPage(userId: widget.userId)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OrderPage(userId: widget.userId)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OrderReceiver(userId: widget.userId)),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(userId: widget.userId)),
        );
        break;
    }
  }

  Widget _buildLogoutDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ปิด Dialog
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const homeLogoPage(),
              ),
            );
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Status',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildLogoutDialog(context);
                },
              );
            },
          ),
        ],
      ),
       bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle),
            label: 'Rider',
          ),
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
        currentIndex:_currentIndex!,
        selectedItemColor: const Color.fromARGB(255, 0, 126, 15),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      body: Column(
        children: [
          // ส่วนของแผนที่
          Container(
            height: 300,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _markers,
              polylines: {
                const Polyline(
                  polylineId: PolylineId('route'),
                  points: [
                    LatLng(13.7563, 100.5018),
                    LatLng(13.7653, 100.5247),
                  ],
                  color: Colors.blue,
                  width: 5,
                ),
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: _ordersRef,
              itemBuilder: (context, snapshot, animation, index) {
                // Check if the snapshot exists
                if (!snapshot.exists) {
                  return const Center(
                    child: Text('No orders available.'),
                  );
                }

                // Extract orderId from snapshot
                int orderId = int.tryParse(snapshot.key ?? '0') ?? 0;

                log(" AA ${orderId}, ${widget.orderId.toString()}");

                if (orderId != widget.orderId) {
                  return const SizedBox.shrink();
                }

                Map orders = snapshot.value as Map;

                if (orders['Status'] == '1') {
                  return ListTile(
                    title: Text('Order ID: $orderId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('รอไรเดอร์มารับสินค้า'),
                          subtitle: Row(
                            children: [
                              Image.network(
                                orders['photo'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('ไรเดอร์รับงาน'),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('กำลังจัดส่ง'),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('จัดส่งสำเร็จ'),
                        ),
                      ],
                    ),
                  );
                } else if (orders['Status'] == '2'){
                  return ListTile(
                    title: Text('Order ID: $orderId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('รอไรเดอร์มารับสินค้า'),
                          subtitle: Row(
                            children: [
                              Image.network(
                                orders['photo'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color:  Colors.green),
                          title: Text('ไรเดอร์รับงาน'),
                          subtitle: Row(
                            children: [
                             Text(orders['riderID']),
                            ],
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('กำลังจัดส่ง'),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('จัดส่งสำเร็จ'),
                        ),
                      ],
                    ),
                  );
                } else if (orders['Status'] == '3'){
                  return ListTile(
                    title: Text('Order ID: $orderId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('รอไรเดอร์มารับสินค้า'),
                          subtitle: Row(
                            children: [
                              Image.network(
                                orders['photo'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color:  Colors.green),
                          title: Text('ไรเดอร์รับงาน'),
                          subtitle: Row(
                            children: [
                             Text(orders['riderID']),
                            ],
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('กำลังจัดส่ง'),
                          subtitle: Row(
                            children: [
                              Image.network(
                                orders['photo2'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('จัดส่งสำเร็จ'),
                          
                        ),
                      ],
                    ),
                  );
                }else if (orders['Status'] == '2'){
                  return ListTile(
                    title: Text('Order ID: $orderId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('รอไรเดอร์มารับสินค้า'),
                          subtitle: Row(
                            children: [
                              Image.network(
                                orders['photo'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color:  Colors.green),
                          title: Text('ไรเดอร์รับงาน'),
                          subtitle: Row(
                            children: [
                             Text(orders['riderID']),
                            ],
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('กำลังจัดส่ง'),
                          subtitle: Row(
                            children: [
                              Image.network(
                                orders['photo2'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('จัดส่งสำเร็จ'),
                          subtitle: Row(
                            children: [
                              Image.network(
                                orders['photo3'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
