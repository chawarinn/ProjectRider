import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/OrderReceiver.dart';
import 'package:mini_project_rider/page/page_User/ProfilePage.dart';
import 'package:mini_project_rider/page/page_User/Search.dart';

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

  LatLng _center = const LatLng(0, 0); // เริ่มต้นที่ (0, 0)
  Set<Marker> _markers = {};

  // ฟังก์ชันสำหรับอัพเดตตำแหน่งปัจจุบัน
  void _updateCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _updateMarkers(); // อัพเดท Marker
      mapController.animateCamera(CameraUpdate.newLatLng(_center)); // เลื่อนกล้องไปที่ตำแหน่งใหม่
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updateMarkers();
  }

  void _updateMarkers() {
    _markers.clear(); // เคลียร์ Marker เก่า

    // เพิ่ม Marker สำหรับตำแหน่งปัจจุบัน
    _markers.add(
      Marker(
        markerId: MarkerId('currentLocation'),
        position: _center,
        infoWindow: InfoWindow(title: 'ตำแหน่งปัจจุบัน'),
      ),
    );

    // เพิ่ม Marker อื่น ๆ ตามต้องการ
    _markers.add(
      Marker(
        markerId: MarkerId('start'),
        position: LatLng(13.7563, 100.5018),
        infoWindow: InfoWindow(title: 'จุดเริ่มต้น'),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('end'),
        position: LatLng(13.7653, 100.5247),
        infoWindow: InfoWindow(title: 'จุดปลายทาง'),
      ),
    );

    setState(() {}); // อัปเดต UI
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;

    // อัปเดตตำแหน่งผู้ใช้ทุกครั้งที่มีการเปลี่ยนแปลงตำแหน่ง
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // กำหนดความแม่นยำ
      distanceFilter: 10, // อัปเดตทุกครั้งที่เปลี่ยนตำแหน่ง 10 เมตร
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
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

  Widget _buildStatusItem(String status, String? imagePath, {bool showRiderDetails = false}) {
    return ListTile(
      leading: Icon(Icons.check_circle, color: Colors.green),
      title: Text(status),
      subtitle: showRiderDetails ? _buildRiderDetails() : (imagePath != null ? Image.asset(imagePath, height: 50) : null),
    );
  }

  Widget _buildRiderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ชื่อไรเดอร์: สมชาย'),
        const Text('เบอร์โทร: 080-123-4567'),
        const Text('ทะเบียนรถ: 1234 ABC'),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Status',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
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
                Polyline(
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
          // รายการสถานะการจัดส่ง
          Expanded(
            child: ListView(
              children: [
                _buildStatusItem('รอไรเดอร์มารับสินค้า', 'images/delivery.png'),
                _buildStatusItem('ไรเดอร์รับงาน', null, showRiderDetails: true),
                _buildStatusItem('กำลังจัดส่ง', null),
                _buildStatusItem('จัดส่งสำเร็จ', null),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex!,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
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
      ),
    );
  }
}
