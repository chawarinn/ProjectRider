// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_Rider/GpsMap.dart';
import 'package:mini_project_rider/page/page_Rider/OrderPageRider.dart';
import 'package:mini_project_rider/page/page_Rider/ProfileRiderPage.dart';
import 'package:mini_project_rider/page/page_User/ConfirmOrder.dart';

class OrderCard extends StatefulWidget {
  int riderId;
  OrderCard({super.key,required this.riderId});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  int _selectedIndex = 0;

 void _onItemTapped(int _selectedIndex) {
    switch (_selectedIndex) {
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
        builder: (context) => GPSandMapPage(riderId: widget.riderId,),
      ),
    );
  }
}  