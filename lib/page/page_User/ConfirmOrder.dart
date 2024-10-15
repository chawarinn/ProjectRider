import 'package:flutter/material.dart';
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/response/user_get_order_res.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/OrderReceiver.dart';
import 'package:mini_project_rider/page/page_User/ProfilePage.dart';
import 'package:mini_project_rider/page/page_User/Search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  
import 'dart:developer';
import 'package:flutter/services.dart';

class ConfrimOrderPage extends StatefulWidget {
  int userId;
  int orderId;
   ConfrimOrderPage({super.key,required this.userId, required this.orderId});

  @override
  State<ConfrimOrderPage> createState() => _ConfrimOrderPageState();
}

class _ConfrimOrderPageState extends State<ConfrimOrderPage> {
   int _selectedIndex = 0;
   String url = '';
  List<Product> userOrder = [];
  UserGetOrderResponse? userOrderResponse;

     void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage(userId: widget.userId)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderPage(userId: widget.userId)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderReceiver(userId: widget.userId)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
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
  }

  Future<void> _fetchOrderDetails() async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/order/addressorder/${widget.orderId}'));

    if (response.statusCode == 200) {
      userOrderResponse = userGetOrderResponseFromJson(response.body);
      log(userOrderResponse.toString());

      userOrder = userOrderResponse!.products;
      setState(() {}); // Call setState to refresh UI
    } else {
      print('Failed to load order details: ${response.statusCode}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Add Order',
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
            icon: const Icon(Icons.logout, color: Colors.black), // Logout icon
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
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
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
                const Center(child: CircularProgressIndicator()), // Show loading if no data

      
          const SizedBox(height: 60),
Text(
  'เพิ่มรูปภาพประกอบสถานะ',
  style: TextStyle(
    fontSize: 18,
  ),
),
const SizedBox(height: 20),
Center(
  child: SizedBox(
    width: 400,
    height: 100,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Center(  
        child: IconButton(
          icon: const Icon(Icons.add_a_photo, size: 40),
          onPressed: () {
          },
        ),
      ),
    ),
  ),
),const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      _Confirm(context); // เรียกใช้ _Confirm แทน ConfirmOrder
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // ทำให้ปุ่มห่างกัน
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด AlertDialog
                },
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderPage(userId: widget.userId)),
        );
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