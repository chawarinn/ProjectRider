import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

class GPSandMapPage extends StatefulWidget {
  final int riderId;
  final int orderId;

  GPSandMapPage({Key? key, required this.riderId, required this.orderId})
      : super(key: key);

  @override
  State<GPSandMapPage> createState() => _GPSandMapPageState();
}

class _GPSandMapPageState extends State<GPSandMapPage> {
  int _selectedIndex = 0;
  List<Product> userOrder = [];
  UserGetOrderResponse? userOrderResponse;
  UserGetOrderResponse? userSentOrderResponse;
  String url = '';
  File? _image;
  File? _image2;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseDatabase realtimeDb = FirebaseDatabase.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final DatabaseReference _ordersRef =
      FirebaseDatabase.instance.ref().child('orders');
Set<Marker> markers = {};
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    }).catchError((err) {
      log(err.toString());
    });
    _fetchOrderDetails();
    _determinePosition();
    _fetchOrderSent();
    _getCurrentLocation();
    // เรียกใช้ฟังก์ชันเพื่ออัปเดตตำแหน่งทุก ๆ 5 วินาที
    Stream.periodic(Duration(seconds: 5)).listen((_) {
      _getCurrentLocation();
    });
  }

 Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      print('Current Position: $currentPosition');
      _updateMarkers();
      _updateRiderLocation(); // อัปเดตตำแหน่งของไรเดอร์
    });
  }

void _updateMarkers() {
    markers.clear(); // เคลียร์มาร์กเกอร์ก่อน

    // ตรวจสอบว่าตำแหน่งปัจจุบันไม่ใช่ null
    if (currentPosition != null) {
      markers.add(Marker(
        markerId: MarkerId('Rider'),
        position: currentPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: 'Current Location'),
      ));
    }
  }


  Future<void> _determinePosition() async {
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
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      _updateMarkers(); // อัปเดตมาร์กเกอร์เมื่อได้ตำแหน่งเริ่มต้น
    });
  }


  Future<void> _updateRiderLocation() async {
    if (currentPosition != null) {
      // สร้างข้อมูลที่จะอัปเดตใน Firebase
      Map<String, dynamic> data = {
        'latLngRider': {
          'latitude': currentPosition!.latitude,
          'longitude': currentPosition!.longitude,
        }
      };
 await db.collection('orders').doc(widget.orderId.toString()).update(data);
          realtimeDb.ref('orders/${widget.orderId}').update(data);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      setState(() {});
    } else {
      print('Failed to load order details: ${response.statusCode}');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('รูปภาพถูกเพิ่มสำเร็จ!')),
        );
      }
    } catch (e) {
      log('Image selection failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถถ่ายรูปได้: $e')),
      );
    }
  }

  Future<void> _pickImage2() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image2 = File(pickedFile.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('รูปภาพถูกเพิ่มสำเร็จ!')),
        );
      }
    } catch (e) {
      log('Image selection failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถถ่ายรูปได้: $e')),
      );
    }
  }

  Future<void> _uploadImage() async {
    String url = '$API_ENDPOINT/order/_uploadImage';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _image!.path,
        filename: 'image.png',
      ));
    } else {
      print('No image selected for upload.');
      return;
    }

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(responseData.body);

        print('Insert Product successfully: ${jsonResponse['message']}');
        print('Image URL: ${jsonResponse['imageUrl']}');

        String uploadedImageUrl = jsonResponse['imageUrl'];
        log(uploadedImageUrl);

        var data = {
          'Status': '3',
          'photo2': uploadedImageUrl,
        };

        await db
            .collection('orders')
            .doc(widget.orderId.toString())
            .update(data);
        await realtimeDb.ref('orders/${widget.orderId}').update(data);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มรูปภาพอัปเดตสถานะสำเร็จ!')),
        );
      } else {
        print('Failed to insert product: ${responseData.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _uploadImage2() async {
    String url = '$API_ENDPOINT/order/_uploadImage';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    if (_image2 != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _image2!.path,
        filename: 'image.png',
      ));
    } else {
      print('No image selected for upload.');
      return;
    }

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(responseData.body);

        print('Insert Product successfully: ${jsonResponse['message']}');
        print('Image URL: ${jsonResponse['imageUrl']}');

        String uploadedImageUrl = jsonResponse['imageUrl'];
        log(uploadedImageUrl);

        var data = {
          'photo3': uploadedImageUrl,
        };

        await db
            .collection('orders')
            .doc(widget.orderId.toString())
            .update(data);
        await realtimeDb.ref('orders/${widget.orderId}').update(data);
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มรูปภาพอัปเดตสถานะสำเร็จ!')),
        );
      } else {
        print('Failed to insert product: ${responseData.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _updateStatus() async {
    try {
      String url = '$API_ENDPOINT/order/updatestatus/${widget.orderId}';

      // ส่งค่า Status = 4 ใน body ของ request
      var response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Status': '4',
        }),
      );

      if (response.statusCode == 200) {
        var data = {
          'Status': '4',
        };

        // อัปเดตข้อมูลใน Firestore
        await db
            .collection('orders')
            .doc(widget.orderId.toString())
            .update(data);
        // อัปเดตข้อมูลใน Realtime Database
        await realtimeDb.ref('orders/${widget.orderId}').update(data);

        // นำทางไปยังหน้า Orderpagerider
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Orderpagerider(riderId: widget.riderId),
          ),
        );
      } else {
        log('Failed to update status. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update status. Please try again later.')),
        );
      }
    } catch (e) {
      log('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดขณะอัปโหลด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Status',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              _showLogoutDialog(context);
            },
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 126, 15),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Google Map Container
Container(
      height: 400, // ความสูงที่ชัดเจน
      child: FirebaseAnimatedList(
        query: _ordersRef,
        itemBuilder: (context, snapshot, animation, index) {
          if (!snapshot.exists) {
            return const Center(child: Text('No orders available.'));
          }

          Map data = snapshot.value as Map;
          String orderId = snapshot.key ?? 'Unknown';

          if (orderId == userOrderResponse?.orderId) {
            Map? latLngUser = data['latLngUser'] as Map?;
            Map? latLngUserSent = data['latLngUserSent'] as Map?;

            if (latLngUser != null && latLngUserSent != null) {
              double lat1 = latLngUser['latitude'];
              double lng1 = latLngUser['longitude'];
              double lat2 = latLngUserSent['latitude'];
              double lng2 = latLngUserSent['longitude'];

              double midLat = (lat1 + lat2) / 2;
              double midLng = (lng1 + lng2) / 2;

              // เพิ่มมาร์กเกอร์ที่ผู้ใช้และส่ง
              markers.add(Marker(
                markerId: MarkerId('userMarker'),
                position: LatLng(lat1, lng1),
                infoWindow: InfoWindow(title: userOrderResponse!.name, snippet: userOrderResponse!.address),
              ));
              markers.add(Marker(
                markerId: MarkerId('sentMarker'),
                position: LatLng(lat2, lng2),
                infoWindow: InfoWindow(title: userOrderResponse!.name, snippet: userOrderResponse!.address),
              ));

              return Container(
                height: 400,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(midLat, midLng),
                    zoom: 5,
                  ),
                  markers: markers, // แสดงหมุดที่อัปเดต
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    if (currentPosition != null) {
                      controller.animateCamera(CameraUpdate.newLatLng(currentPosition!));
                    }
                  },
                ),
              );
          }
        }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 20),
            // Card ที่แสดงข้อมูลต่าง ๆ
            if (userOrderResponse != null && userSentOrderResponse != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 5),
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
                      const SizedBox(height: 5),
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
                        'Order ID: ${userOrderResponse!.orderId}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...userOrderResponse!.products.map((product) => Text(
                            product.detail,
                            style: const TextStyle(fontSize: 16),
                          )),
                    ],
                  ),
                ),
              ),
            // เพิ่มการแสดงผลภาพและปุ่มที่คุณต้องการ
            _buildImagePicker(),
            _buildImagePicker2(),
            const SizedBox(height: 20),
            _buildSuccessButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (_image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Center(
                        child: SizedBox(
                          width: 400,
                          height: 100,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _uploadImage,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker2() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (_image2 != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                      _image2!,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _pickImage2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Center(
                        child: SizedBox(
                          width: 400,
                          height: 100,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _uploadImage2,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _updateStatus,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 11, 102, 35),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        child: const Text(
          'Success',
          style:
              TextStyle(fontSize: 18, color: Color.fromARGB(255, 22, 12, 12)),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
      },
    );
  }
}