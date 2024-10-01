import 'package:flutter/material.dart';
import 'package:mini_project_rider/page/page_Rider/RegisterPageRider.dart';
import 'package:mini_project_rider/page/page_User/RegisterPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 102, 35),
          title: const Text(
            'Register',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
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
                  padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
                  child: Text(
                    "ท่านสนใจสมัครสมาชิกเป็น",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RegisterPageRider(), 
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 280,
                      height: 180,
                      child: Card(
                        color: const Color.fromARGB(255, 10, 151, 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                child: Text(
                                  "Rider",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

              Image.asset(
                'assets/images/Delivery.png',
                width: 100,  
                height: 100, 
              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                   child: GestureDetector(  // ใช้ GestureDetector เพื่อรองรับการคลิก
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPageUser(), // หน้าปลายทาง
        ),
      );
    },
                    child: SizedBox(
                      width: 280,
                      height: 180,
                      child: Card(
                        color: const Color.fromARGB(255, 10, 151, 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child:  Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                child: Text(
                                  "User",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

              Image.asset(
                'assets/images/Person.webp',
                width: 100,  
                height: 100, 
              ),
                            ],
                          ),
                          
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
