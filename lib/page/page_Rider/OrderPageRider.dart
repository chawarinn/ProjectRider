import 'package:flutter/material.dart';
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/model/response/rider_get_order_res.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_Rider/ProfileRiderPage.dart';
import 'package:mini_project_rider/page/page_Rider/order_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Orderpagerider extends StatefulWidget {
  final int riderId;
  Orderpagerider({Key? key, required this.riderId}) : super(key: key);

  @override
  _OrderpageriderState createState() => _OrderpageriderState();
}

class _OrderpageriderState extends State<Orderpagerider> {
  int _selectedIndex = 0;
  String url = '';
  List<RiderGetOrderResponse> riderOrderResponse = [];
  List<Product> riderOrder = [];
  final DatabaseReference _ordersRef =
      FirebaseDatabase.instance.ref().child('orders');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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
      final response = await http.get(Uri.parse('$url/riders/order'));

      if (response.statusCode == 200) {
        riderOrderResponse = riderGetOrderResponseFromJson(response.body);
        setState(() {
          riderOrder =
              riderOrderResponse.expand((order) => order.products).toList();
        });
        log(riderOrder.toString());
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
        automaticallyImplyLeading: false,
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const homeLogoPage()));
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
              SizedBox(
                height: 400,
                child: FirebaseAnimatedList(
                  query: _ordersRef,
                 // Item builder for FirebaseAnimatedList
itemBuilder: (context, snapshot, animation, index) {
  if (!snapshot.exists) {
    return const Text('No orders available.');
  }

  Map orders = snapshot.value as Map;
  String orderId = snapshot.key ?? 'Unknown';

  // Check if orders is null to avoid potential errors
  if (orders == null) {
    return const Text('Invalid data.');
  }

  // Check if the order status is 1 before displaying it
  if (orders['Status'] == '1') {
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
                        'Order ID: $orderId',
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
                              orders['Name'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Phone: ${orders['Phone']}'),
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
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderCard(
                  riderId: widget.riderId,
                  orderId: int.parse(orderId),
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
      ],
    );
  } else {
    return const SizedBox.shrink(); 
  }
}

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
