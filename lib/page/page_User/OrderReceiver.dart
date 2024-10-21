import 'package:flutter/material.dart';
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/response/user_get_orderReceiver.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/ProfilePage.dart';
import 'package:mini_project_rider/page/page_User/Search.dart';
import 'package:mini_project_rider/page/page_User/Status.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'dart:io';

class OrderReceiver extends StatefulWidget {
  int userId;
  OrderReceiver({super.key, required this.userId});

  @override
  State<OrderReceiver> createState() => _OrderReceiverState();
}

class _OrderReceiverState extends State<OrderReceiver> {
  int _selectedIndex = 2;
  String url = ' ';
  List<UserGetOrderReceiverResponse> userOrderReceiverResponse = [];
  List<Product> userReceiverOrder = [];

  void _onItemTapped(int _selectedIndex) {
    switch (_selectedIndex) {
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
    _fetchOrdersent();
  }

  Future<void> _fetchOrdersent() async {
    try {
      final response = await http
          .get(Uri.parse('$API_ENDPOINT/users/orderreceiver/${widget.userId}'));

      if (response.statusCode == 200) {
        userOrderReceiverResponse =
            userGetOrderReceiverResponseFromJson(response.body);
        setState(() {
          userReceiverOrder = userOrderReceiverResponse
              .expand((order) => order.products)
              .toList();
        });
        log(userReceiverOrder.toString());
      } else if (response.statusCode == 404) {
        print('No orders found for user.');
      } else {
        print('Failed to load order details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
  automaticallyImplyLeading: false,  // ปิดการใช้งานปุ่มย้อนกลับ
  backgroundColor: const Color.fromARGB(255, 11, 102, 35),
  title: const Text(
    'Order',
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
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userOrderReceiverResponse.length,
                  itemBuilder: (context, index) {
                    final order = userOrderReceiverResponse[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Order ID: ${order.orderId}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StatusPage(
                                          userId: widget.userId,
                                          selectedIndex: _selectedIndex,
                                          orderId: order.orderId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.local_shipping,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.network(
                                  order.orderPhoto,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Phone: ${order.phone}'),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            const Text('Order:'),
                                            ...order.products.map((product) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                child:
                                                    Text('${product.detail}'),
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      ),
                                      Align(
          alignment: Alignment.bottomRight,
                                    child: Text(
                                      order.status == '1' 
                                        ? 'รอไรเดอร์รับงาน' 
                                        : order.status == '2' 
                                          ? 'กำลังจัดส่ง' 
                                          : order.status == '4' 
                                          ? 'จัดส่งเสร็จสิ้น' 
                                          : '',
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                    ],

                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
