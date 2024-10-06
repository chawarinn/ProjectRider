// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mini_project_rider/page/page_Rider/GpsMap.dart';
import 'package:mini_project_rider/page/page_User/ConfirmOrder.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ปุ่มย้อนกลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: PPPP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Phone: 0999999999',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Address: Kham Riang, Kantha rawichai District, Maha Sarakham, 44150, Thailand',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Order: 12',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'โดนัท',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  'assets/images/Delivery.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10), 
                Text(
                  'ชานมไข่มุก',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
         
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
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        onTap: _onItemTapped,
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center( 
            child: Text('ยืนยันการรับงาน'), 
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:Color.fromARGB(255, 255, 255, 255), backgroundColor: const Color.fromARGB(255, 178, 178, 178), // เปลี่ยนสีตัวอักษรของปุ่ม NO
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
                    foregroundColor: Color.fromARGB(255, 255, 255, 255), backgroundColor:  Color.fromARGB(255, 178, 178, 178), 
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GPSandMapPage(),
      ),
    );
  }
}  
