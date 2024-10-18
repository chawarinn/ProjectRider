import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/response/rider_get_order_res.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_Rider/ProfileRiderPage.dart';
import 'package:mini_project_rider/page/page_Rider/order_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' ;


class Orderpagerider extends StatefulWidget {
  int riderId;
  Orderpagerider({super.key, required this.riderId});

  @override
  State<Orderpagerider> createState() => _Orderpagerider();
}

class _Orderpagerider extends State<Orderpagerider> {
  int _selectedIndex = 0;
  String url = '';
  List<RiderGetOrderResponse> RiderOrderResponse = [];
  List<Product> RiderOrder = [];
  var realtimeDb = FirebaseDatabase.instance.ref().child('orders');

  void _onItemTapped(int _selectedIndex) {
    switch (_selectedIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Orderpagerider(riderId: widget.riderId)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileRiderPage(riderId: widget.riderId)),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'];
      });
    }).catchError((err) {
      log(err.toString());
    });
    _fetchOrderRider();
  }

  Future<void> _fetchOrderRider() async {
    try {
      final response = await http.get(Uri.parse('$API_ENDPOINT/riders/order'));

      if (response.statusCode == 200) {
        RiderOrderResponse = riderGetOrderResponseFromJson(response.body);
        setState(() {
          RiderOrder =
              RiderOrderResponse.expand((order) => order.products).toList();
        });
        log(RiderOrder.toString());
      } else if (response.statusCode == 404) {
        log('No orders found for rider.');
      } else {
        log('Failed to load order details: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching order details: $e');
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
            icon: Icon(Icons.assignment),
            label: 'Orders',
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
            children: [
              // Wrapping the FirebaseAnimatedList in a SizedBox to provide height constraints
         SizedBox(
  height: 400,  
  child: FirebaseAnimatedList(
    query: realtimeDb,
    itemBuilder: (context, snapshot, animation, index) {
      Map orders = snapshot.value as Map;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Card(
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
                          'Order ID: ${orders['orderID']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Image.network(
                          orders['photo'] ?? 'https://via.placeholder.com/100',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orders['name'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Phone: ${orders['phone']}'),
                              // SizedBox(
                              //   height: 50,  // Provide a constrained height for ListView.builder
                              //   child: ListView.builder(
                              //     shrinkWrap: true,
                              //     physics: const NeverScrollableScrollPhysics(),
                              //     itemCount: RiderOrderResponse.length,
                              //     itemBuilder: (context, index) {
                              //       final order = RiderOrderResponse[index];
                              //       return SingleChildScrollView(
                              //         scrollDirection: Axis.horizontal,
                              //         child: Row(
                              //           children: [
                              //             const Text('Order:'),
                              //             ...order.products.map((product) {
                              //               return Padding(
                              //                 padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              //                 child: Text('${product.detail}'),
                              //               );
                              //             }).toList(),
                              //           ],
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 50,  
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: RiderOrderResponse.length,
              itemBuilder: (context, index) {
                final order = RiderOrderResponse[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 50, left: 0, right: 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderCard(
                              riderId: widget.riderId,
                              orderId: order.orderId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                        minimumSize: const Size(50, 50),
                        backgroundColor: const Color.fromARGB(255, 255, 17, 17),
                      ),
                      child: const Icon(
                        Icons.flash_on,
                        size: 30,
                        color: Color.fromARGB(255, 255, 170, 22),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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