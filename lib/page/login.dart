import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/request/user_login_post_req.dart';
import 'package:mini_project_rider/model/response/rider_login_post_res.dart';
import 'package:mini_project_rider/model/response/user_login_post_res.dart';
import 'package:mini_project_rider/page/page_Rider/OrderPageRider.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/Search.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  String text = '';
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
        // log(config ['apiEndpoint']);
      },
    ).catchError((err) {
      log(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/Profile.png'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phone',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    TextField(
                      controller: phoneCtl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    TextField(
                      controller: passwordCtl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (phoneCtl.text.isEmpty || passwordCtl.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('ข้อมูลไม่ถูกต้อง',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      fontWeight: FontWeight.bold)),
                              content: const Text(
                                  'กรุณากรอกเบอร์โทรและรหัสผ่านให้ครบถ้วน'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('ตกลง',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      } else {
                        showRoleSelectionDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 50, 142, 53),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับแสดง Popup
  void showRoleSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: loginU,
                child: SizedBox(
                  width: 130,
                  height: 100,
                  child: Card(
                    color: const Color.fromARGB(255, 10, 151, 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/Person.webp',
                          height: 60,
                          width: 60,
                        ),
                        const Text('User'),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: loginR,
                child: SizedBox(
                  width: 130,
                  height: 100,
                  child: Card(
                    color: const Color.fromARGB(255, 10, 151, 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/Delivery.png',
                          height: 60,
                          width: 60,
                        ),
                        const Text('Rider'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void loginU() async {
    log(phoneCtl.text);
    log(passwordCtl.text);
    try {
      var data = UsersLoginPostRequest(
          phone: phoneCtl.text, password: passwordCtl.text);

      var value = await http.post(Uri.parse('$API_ENDPOINT/loginU'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: usersLoginPostRequestToJson(data));

      UsersLoginPostResponse users = usersLoginPostResponseFromJson(value.body);
      log(value.body);
    int? userId = users.user?.userId; // Use nullable int to handle possible null value
      if (userId == null) {
        throw Exception('User ID is null'); // Handle case where userId is null
      }
      
      log(userId.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  SearchPage(userId: userId),
          ));
    } catch (error) {
      log(error.toString() + 'eiei');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ข้อมูลไม่ถูกต้อง',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 0, 0),
                    fontWeight: FontWeight.bold)),
            content: const Text('เบอร์โทรหรือรหัสผ่านไม่ถูกต้อง'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'ตกลง',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );

      setState(() {
        text = 'phone no or password incorrect';
      });
    }
  }

  void loginR() async {
    log(phoneCtl.text);
    log(passwordCtl.text);
    try {
      var data = UsersLoginPostRequest(
          phone: phoneCtl.text, password: passwordCtl.text);
      var value = await http.post(Uri.parse('$API_ENDPOINT/loginR'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: usersLoginPostRequestToJson(data));

      RidersLoginPostResponse riders = ridersLoginPostResponseFromJson(value.body);
      log(value.body);
      log(riders.rider.riderId.toString());
      setState(() {
        text = '';
      });

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Orderpagerider(),
          ));
    } catch (eeee) {
      log(eeee.toString() + 'eiei');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ข้อมูลไม่ถูกต้อง',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 0, 0),
                    fontWeight: FontWeight.bold)),
            content: const Text('เบอร์โทรหรือรหัสผ่านไม่ถูกต้อง'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'ตกลง',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
      setState(() {
        text = 'phone no or password incorrect';
      });
    }
  }
}
