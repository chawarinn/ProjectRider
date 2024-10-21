import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_Rider/OrderPageRider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:location/location.dart';


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
  File? _image;
  File? _image2;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseDatabase realtimeDb = FirebaseDatabase.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  Location _location = Location();


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _initLocation();
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
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
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
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

      await db.collection('orders').doc(widget.orderId.toString()).update(data);
      await realtimeDb.ref('orders/${widget.orderId}').update(data);
      
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

      await db.collection('orders').doc(widget.orderId.toString()).update(data);
      await realtimeDb.ref('orders/${widget.orderId}').update(data);
      
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
      await db.collection('orders').doc(widget.orderId.toString()).update(data);
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
        SnackBar(content: Text('Failed to update status. Please try again later.')),
      );
    }
  } catch (e) {
    log('Error updating status: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาดขณะอัปโหลด: $e')),
    );
  }
}

  Future<void> _initLocation() async {
    bool? _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return; // Early return if the service is not enabled
    }

    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return; // Early return if permission is denied
    }

    // Start listening to location changes
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
            Container(
              height: 500,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition ?? LatLng(13.7563, 100.5018), // Default position
                  zoom: 11.0,
                ),
                myLocationEnabled: true,
                markers: _currentPosition != null
                    ? {
                        Marker(
                          markerId: MarkerId('current_location'),
                          position: _currentPosition!,
                        ),
                      }
                    : {},
              ),
            ),
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
          style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 22, 12, 12)),
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
