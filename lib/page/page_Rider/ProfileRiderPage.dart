// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, no_leading_underscores_for_local_identifiers
import 'package:http/http.dart' as http;
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_Rider/OrderPageRider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class ProfileRiderPage extends StatefulWidget {
  final int riderId;  // ใช้ final เพราะค่า riderId ไม่ควรเปลี่ยนแปลง

  const ProfileRiderPage({super.key, required this.riderId});

  @override
  State<ProfileRiderPage> createState() => _ProfileRiderPageState();
}

class _ProfileRiderPageState extends State<ProfileRiderPage> {
  bool isLoading = true;
  int _selectedIndex = 1;
  late Map<String, dynamic> riderProfile;

  @override
  void initState() {
    super.initState();
    fetchRiderProfile(); // โหลดข้อมูลเมื่อหน้าเพจถูกสร้างขึ้น
  }
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


  Future<void> fetchRiderProfile() async {
    try {
      final response = await http.get(Uri.parse('$API_ENDPOINT/riders/rider?riderID=${widget.riderId}')).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> result = json.decode(response.body);
          riderProfile = result.isNotEmpty ? result[0] : {};  // ใช้ result[0] ถ้ามีข้อมูล
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading profile: $e');
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Profile',
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: riderProfile.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(riderProfile['photo'] ?? 'https://example.com/default-profile.png'), // รูปจาก Firebase
                        ),
                        SizedBox(height: 20),
                        Text(
                          riderProfile['name'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          riderProfile['phone'],
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Car: ${riderProfile['car']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    )
                  : Center(child: Text('No user data found')),
            ),
    );
  }
}
