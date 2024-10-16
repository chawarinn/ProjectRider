import 'dart:core';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/response/user_search_get_res.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_User/AddOrder.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/OrderReceiver.dart';
import 'package:mini_project_rider/page/page_User/ProfilePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  

class SearchPage extends StatefulWidget {
  final int userId;

  SearchPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex = 0;
  String _searchPhone = ''; // เก็บข้อมูลที่พิมพ์ในช่องค้นหา
  String url = '';
  List<UserSearchGetResponse> userPhone = [];
  List<UserSearchGetResponse> filteredUserPhone = []; // สำหรับเก็บข้อมูลที่ผ่านการกรองแล้ว

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    }).catchError((err) {
      log(err.toString());
    });
    loadDataAsync();
  }

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

 void AddOrder(int userId, int otherUserId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddOrderPage(userId: userId, UserId: otherUserId),  // ส่งทั้งสองพารามิเตอร์
    ),
  );
}
  Future<void> loadDataAsync() async {
    try {
      var response = await http.get(Uri.parse('$API_ENDPOINT/users/userPhone?userID=${widget.userId}'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        userPhone = jsonData.map((e) => UserSearchGetResponse.fromJson(e)).toList();
        setState(() {
          filteredUserPhone = userPhone; 
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _filterUserList(String query) {
    setState(() {
      filteredUserPhone = userPhone.where((user) {
        return user.phone.contains(query); 
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
  automaticallyImplyLeading: false,  // ปิดการใช้งานปุ่มย้อนกลับ
  backgroundColor: const Color.fromARGB(255, 11, 102, 35),
  title: const Text(
    'Search',
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
     body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                _searchPhone = value;
                _filterUserList(value); 
              },
              decoration: InputDecoration(
                hintText: 'Search Phone',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded( 
              child: filteredUserPhone.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: filteredUserPhone.length,
                      itemBuilder: (context, index) {
                        var user = filteredUserPhone[index];
                        return SizedBox(
                          width: 400,
                          height: 110,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      user.photo,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Phone: ${user.phone}'),
                                    ],
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        AddOrder(widget.userId, user.userId);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/images/package.png',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}