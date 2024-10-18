// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/response/user_get_order_res.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_Rider/GpsMap.dart';
import 'package:mini_project_rider/page/page_Rider/OrderPageRider.dart';
import 'package:mini_project_rider/page/page_Rider/ProfileRiderPage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCard extends StatefulWidget {
  final int riderId;
  final int orderId;

  OrderCard({super.key, required this.riderId, required this.orderId});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  int _selectedIndex = 0;
  String url = '';
  List<Product> userOrder = [];
  UserGetOrderResponse? userOrderResponse;
   var db = FirebaseFirestore.instance;
FirebaseDatabase realtimeDb = FirebaseDatabase.instance;

  void _onItemTapped(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Orderpagerider(riderId: widget.riderId)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileRiderPage(riderId: widget.riderId)),
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
      setState(() {}); 
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
          'Order',
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
                          Navigator.of(context).pop(); 
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
                const Center(
                  child: CircularProgressIndicator(),
                ),
              const SizedBox(height: 20),

              ...userOrder.map((product) => Center(
                child: SizedBox(
                  width: 300,
                  height: 100,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Image.network(
                            product.productPhoto, 
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              product.detail,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )).toList(),
              
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 11, 102, 35),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'รับงาน',
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 22, 12, 12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('ยืนยันการรับงาน')),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(255, 178, 178, 178),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text('NO'),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ConfrimOrder();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: Color.fromARGB(255, 178, 178, 178),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text('YES'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

void ConfrimOrder() {
  final url = '$API_ENDPOINT/order/updaterider/${widget.riderId}/${widget.orderId}'; 
  http.put(Uri.parse(url)).then((response) {
    if (response.statusCode == 200) {
      var data = {
        'Status': '2',
        'riderID': widget.riderId,
      };

      db.collection('orders').doc(widget.orderId.toString()).update(data);
      realtimeDb.ref('orders/${widget.orderId}').update(data);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GPSandMapPage(riderId: widget.riderId, orderId: widget.orderId),
        ),
      );
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating order: ${response.body}')),
      );
    }
  }).catchError((error) {
    print("Error: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error occurred: $error')),
    );
  });
}

}
