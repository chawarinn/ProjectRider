import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/OrderReceiver.dart';
import 'package:mini_project_rider/page/page_User/Search.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   int _selectedIndex = 3;
  late Map<String, dynamic> userProfile;
  bool isLoading = true;

    void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchPage(userId: widget.userId)));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderPage(userId: widget.userId)));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderReceiver(userId: widget.userId)));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)));
        break;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await http.get(Uri.parse('$API_ENDPOINT/users/user?userID=${widget.userId}')).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> result = json.decode(response.body);
          userProfile = result.isNotEmpty ? result[0] : {};  // ใช้ result[0] ถ้ามีข้อมูล
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error, you can show a dialog or snackbar here
      print('Error loading profile: $e');
    }
  }

  // Future<void> deleteUserProfile() async {
  //   try {
  //     final response = await http.delete(Uri.parse('$API_ENDPOINT/users/deleteUser?userID=${widget.userId}')).timeout(Duration(seconds: 10));

  //     if (response.statusCode == 200) {
  //       // Successfully deleted the user
  //       Navigator.pop(context); // Close the profile page or navigate elsewhere
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('User and associated files deleted successfully')),
  //       );
  //     } else if (response.statusCode == 404) {
  //       // User not found
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('User not found')),
  //       );
  //     } else {
  //       // Other errors
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to delete profile')),
  //       );
  //     }
  //   } catch (e) {
  //     // Handle error, you can show a dialog or snackbar here
  //     print('Error deleting profile: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error deleting profile: $e')),
  //     );
  //   }
  // }

  // void showDeleteConfirmationDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Confirm Deletion'),
  //         content: Text('คุณต้องการที่จะลบบัญชีใช่หรือไม่?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('ไม่ใช่'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               deleteUserProfile(); // Call the delete function
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('ใช่'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  automaticallyImplyLeading: false,  // ปิดการใช้งานปุ่มย้อนกลับ
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center( // ใช้ Center เพื่อให้ทุกอย่างอยู่ตรงกลาง
              child: userProfile.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,  // จัดให้อยู่ตรงกลางในแนวตั้ง
                      crossAxisAlignment: CrossAxisAlignment.center,  // จัดให้อยู่ตรงกลางในแนวนอน
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(userProfile['photo'] ?? 'https://example.com/default-profile.png'), // รูปจาก Firebase
                        ),
                        SizedBox(height: 20),
                        Text(
                          userProfile['name'], 
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          userProfile['phone'], 
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Address: ${userProfile['address']}', 
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 20), // Space before the delete button
                        // ElevatedButton(
                        //   onPressed: showDeleteConfirmationDialog,
                        //   child: Text('ลบบัญชี'), // Button text for deleting account
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: const Color.fromARGB(255, 123, 119, 119), // Change button color to red
                        //   ),
                        // ),
                      ],
                    )
                  : Center(child: Text('No user data found')),
            ),
    );
  }
}
