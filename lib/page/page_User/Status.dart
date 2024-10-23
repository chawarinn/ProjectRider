import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mini_project_rider/model/response/rider_get_res.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/response/user_get_order_res.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_Rider/OrderPageRider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
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
  List<Product> userOrder = [];
  List<Product> RiderOrder = [];
  UserGetOrderResponse? userOrderResponse;
  UserGetOrderResponse? userSentOrderResponse;
  RiderResponse? riderResponse;
  late GoogleMapController mapController;
  final DatabaseReference _ordersRef =
      FirebaseDatabase.instance.ref().child('orders');
  String url = '';

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    }).catchError((err) {
      log(err.toString());
    });
    _fetchOrderDetails();
    _fetchOrderSent();
    _fetchRider();
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

  Future<void> _fetchOrderDetails() async {
    final response = await http
        .get(Uri.parse('$API_ENDPOINT/order/addressorder/${widget.orderId}'));

    if (response.statusCode == 200) {
      userOrderResponse = userGetOrderResponseFromJson(response.body);
      log(userOrderResponse.toString());

      userOrder = userOrderResponse!.products;
      setState(() {});
    } else {
      print('Failed to load order details: ${response.statusCode}');
    }
  }

  Future<void> _fetchOrderSent() async {
    final response = await http.get(
        Uri.parse('$API_ENDPOINT/order/addressorderSent/${widget.orderId}'));

    if (response.statusCode == 200) {
      userSentOrderResponse = userGetOrderResponseFromJson(response.body);
      log(userSentOrderResponse.toString());

      userOrder = userSentOrderResponse!.products;
      log(userSentOrderResponse!.toString());
      setState(() {});
    } else {
      print('Failed to load order details: ${response.statusCode}');
    }
  }

  Future<void> _fetchRider() async {
    final response = await http
        .get(Uri.parse('$API_ENDPOINT/order/addressRider/${widget.orderId}'));

    if (response.statusCode == 200) {
      riderResponse = riderResponseFromJson(response.body);
      log(riderResponseFromJson.toString());

      setState(() {});
    } else {
      print('Failed to load order details: ${response.statusCode}');
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
        currentIndex: _currentIndex!,
        selectedItemColor: const Color.fromARGB(255, 0, 126, 15),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            child: FirebaseAnimatedList(
              query: _ordersRef,
              itemBuilder: (context, snapshot, animation, index) {
                if (!snapshot.exists) {
                  return const Center(child: Text('No orders available.'));
                }

                Map data = snapshot.value as Map;
                String orderId = snapshot.key ?? 'Unknown';

                if (orderId == widget.orderId.toString()) {
                  Map? latLngUser = data['latLngUser'] as Map?;
                  Map? latLngUserSent = data['latLngUserSent'] as Map?;
                  Map? latLngRider = data['latLngRider'] as Map?;

                  if (latLngUser != null && latLngUserSent != null) {
                    double lat1 = latLngUser['latitude'] ?? 0;
                    double lng1 = latLngUser['longitude'] ?? 0;
                    double lat2 = latLngUserSent['latitude'] ?? 0;
                    double lng2 = latLngUserSent['longitude'] ?? 0;
                    double? lat3 = latLngRider?['latitude'];
                    double? lng3 = latLngRider?['longitude'];

                    double midLat = (lat1 + lat2) / 2;
                    double midLng = (lng1 + lng2) / 2;

                    // เพิ่มมาร์กเกอร์ที่ผู้ใช้
                    if (userOrderResponse != null) {
                      markers.add(Marker(
                        markerId: MarkerId('userMarker'),
                        position: LatLng(lat1, lng1),
                        infoWindow: InfoWindow(
                            title: userOrderResponse!.name,
                            snippet: userOrderResponse!.address),
                      ));
                    }

                    if (userSentOrderResponse != null) {
                      markers.add(Marker(
                        markerId: MarkerId('sentMarker'),
                        position: LatLng(lat2, lng2),
                        infoWindow: InfoWindow(
                          title: userSentOrderResponse?.name,
                          snippet: userSentOrderResponse?.address,
                        ),
                      ));
                    }

                    // เช็คว่า latLngRider ไม่เป็น null ก่อนที่จะเพิ่มมาร์กเกอร์
                    if (lat3 != null && lng3 != null && riderResponse != null) {
                      markers.add(Marker(
                        markerId: MarkerId('Rider'),
                        position: LatLng(lat3, lng3),
                        infoWindow: InfoWindow(
                            title: riderResponse!.riderName,
                            snippet: 'Car: ${riderResponse!.riderCar}'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                      ));
                    }

                    return Container(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(midLat, midLng),
                          zoom: 15,
                        ),
                        markers: Set<Marker>.of(
                            markers), // แสดงมาร์กเกอร์ที่สร้างขึ้น
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        mapType: MapType.normal,
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
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
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID: $orderId'),
                        ElevatedButton(
                          onPressed: () {
                            detail();
                          },
                          child: Text('รายละเอียด'),
                        ),
                      ],
                    ),
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
                          leading: Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('ไรเดอร์รับงาน'),
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('กำลังจัดส่ง'),
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('จัดส่งสำเร็จ'),
                        ),
                      ],
                    ),
                  );
                } else if (orders['Status'] == '2') {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID: $orderId'),
                        ElevatedButton(
                          onPressed: () {
                            detail();
                          },
                          child: Text('รายละเอียด'),
                        ),
                      ],
                    ),
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
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('ไรเดอร์รับงาน'),
                          subtitle: Row(
                            children: [
                              Text("riderID : ${orders['riderID'].toString()}"),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('กำลังจัดส่ง'),
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('จัดส่งสำเร็จ'),
                        ),
                      ],
                    ),
                  );
                } else if (orders['Status'] == '3') {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID: $orderId'),
                        ElevatedButton(
                          onPressed: () {
                            detail();
                          },
                          child: Text('รายละเอียด'),
                        ),
                      ],
                    ),
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
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('ไรเดอร์รับงาน'),
                          subtitle: Row(
                            children: [
                              Text("riderID : ${orders['riderID'].toString()}"),
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
                          leading: Icon(Icons.check_circle, color: Colors.grey),
                          title: Text('จัดส่งสำเร็จ'),
                        ),
                      ],
                    ),
                  );
                } else if (orders['Status'] == '4') {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID: $orderId'),
                        ElevatedButton(
                          onPressed: () {
                            detail();
                          },
                          child: Text('รายละเอียด'),
                        ),
                      ],
                    ),
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
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text('ไรเดอร์รับงาน'),
                          subtitle: Row(
                            children: [
                              Text("riderID : ${orders['riderID'].toString()}"),
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
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  detail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รายละเอียด'),
          content: SingleChildScrollView(
            child: Container(
              // ตรวจสอบว่า userOrderResponse และ userSentOrderResponse ไม่เป็น null
              child: userOrderResponse != null && userSentOrderResponse != null
                  ? Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (riderResponse != null) ...[
                              ClipOval(
                                child: Image.network(
                                  riderResponse!.riderPhoto,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                'Rider: ${riderResponse!.riderName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Phone: ${riderResponse!.riderPhone}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  'Car: ${riderResponse!.riderCar}',
                                  style: const TextStyle(fontSize: 16),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ] else ...[
                              // ถ้า riderResponse เป็น null ให้แสดงข้อความนี้
                              Text(
                                'ยังไม่มี rider รับงาน',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        Colors.red), // ปรับสีข้อความตามต้องการ
                              ),
                            ],
                            Container(
                              width: 300,
                              height: 1,
                              color: Colors.black,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            Text(
                              'Sender: ${userSentOrderResponse!.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Phone: ${userSentOrderResponse!.phone}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 300,
                              child: Text(
                                'Address: ${userSentOrderResponse!.address}',
                                style: const TextStyle(fontSize: 16),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Container(
                              width: 300,
                              height: 1,
                              color: Colors.black,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            Text(
                              'Receiver: ${userOrderResponse!.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Phone: ${userOrderResponse!.phone}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 300,
                              child: Text(
                                'Address: ${userOrderResponse!.address}',
                                style: const TextStyle(fontSize: 16),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Container(
                              width: 300,
                              height: 1,
                              color: Colors.black,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            Text(
                              'Product:',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...userOrderResponse!.products.map((product) => Row(
                                  children: [
                                    Image.network(
                                      product.productPhoto,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      product.detail,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด popup
              },
              child: Text('ปิด'),
            ),
          ],
        );
      },
    );
  }
}
