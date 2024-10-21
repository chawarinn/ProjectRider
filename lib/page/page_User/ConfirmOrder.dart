import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/response/user_get_order_res.dart';
import 'package:mini_project_rider/model/response/user_get_res.dart';
import 'package:mini_project_rider/model/response/user_put_order.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/OrderReceiver.dart';
import 'package:mini_project_rider/page/page_User/ProfilePage.dart';
import 'package:mini_project_rider/page/page_User/Search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

class ConfrimOrderPage extends StatefulWidget {
  int userId;
   int UserId;
  int orderId;
  ConfrimOrderPage({super.key, required this.userId, required this.orderId, required this.UserId});

  @override
  State<ConfrimOrderPage> createState() => _ConfrimOrderPageState();
}

class _ConfrimOrderPageState extends State<ConfrimOrderPage> {
  int _selectedIndex = 0;
  File? _image;
  String url = '';
  List<Product> userOrder = [];
  UserGetOrderResponse? userOrderResponse;
  var db = FirebaseFirestore.instance;
  UserPutOrderResponse? ResponsePhoto;
  UserGetResponse? userData;
  FirebaseDatabase realtimeDb = FirebaseDatabase.instance;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchPage(userId: widget.userId)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderPage(userId: widget.userId)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderReceiver(userId: widget.userId)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(userId: widget.userId)),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    }).catchError((err) {
      log(err.toString());
    });
    _fetchOrderDetails();
    _fetchAddress();
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
          SnackBar(content: Text('รูปภาพถูกเพิ่มสำเร็จ!')),
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
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเพิ่มรูปภาพก่อน')),
      );
      return;
    }

    try {
      String url = '$API_ENDPOINT/order/updatephotostatus/${widget.orderId}';
      var request = http.MultipartRequest('PUT', Uri.parse(url))
        ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        ResponsePhoto = userPutOrderResponseFromJson(responseData.body);
        log('Image uploaded successfully');
        
        if (ResponsePhoto != null && userData != null) {
          var data = {
            'Status': '1',
            'photo': ResponsePhoto!.imageUrl,
            'latLngUserSent': {
              'latitude': userData!.lat,
              'longitude': userData!.long
            },
          };
          await db.collection('orders').doc(widget.orderId.toString()).update(data);
          realtimeDb.ref('orders/${widget.orderId}').update(data);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderPage(userId: widget.userId)),
          );
        } else {
          log('ResponsePhoto หรือ userData มีค่าเป็น null');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('การอัปเดตข้อมูลไม่สำเร็จ')),
          );
        }
      } else {
        log('Failed to upload image: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถอัปโหลดรูปภาพได้: ${response.statusCode}')),
        );
      }
    } catch (e) {
      log('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดขณะอัปโหลด: $e')),
      );
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

  Future<void> _fetchAddress() async {
    try {
      var response = await http.get(Uri.parse(
          '$API_ENDPOINT/users/user?userID=${widget.userId}')); 
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          userData = UserGetResponse.fromJson(data[0]);
        });
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: false,  // ปิดการใช้งานปุ่มย้อนกลับ
  backgroundColor: const Color.fromARGB(255, 11, 102, 35),
  title: const Text(
    'Add Order',
    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.logout, color: Colors.black),
      onPressed: () {
        showDialog(
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const homeLogoPage()));
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      },
    ),
  ],
),
  
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (userOrderResponse != null)
                SizedBox(
                  child: Card(
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
                            'Name: ${userOrderResponse!.name}',
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
                )
              else
                const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 60),
              Text(
                'เพิ่มรูปภาพประกอบสถานะ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
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
                Center(
                  child: SizedBox(
                    width: 400,
                    height: 100,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
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
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      _Confirm(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 50, 142, 53),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 126, 15),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        onTap: _onItemTapped,
      ),
    );
  }

  void _Confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "ยืนยันการส่งสินค้า",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, 
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                  await _uploadImage(); 
                },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 50, 142, 53),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
