import 'package:flutter/material.dart';
import 'package:mini_project_rider/page/login.dart';
import 'package:mini_project_rider/page/register.dart';

class homeLogoPage extends StatefulWidget {
  const homeLogoPage({super.key});

  @override
  State<homeLogoPage> createState() => _homeLogoPageState();
}

class _homeLogoPageState extends State<homeLogoPage> {
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 146, 189, 150),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                   mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            height: 30), 
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 50, 142, 53),
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), 
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: (){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ));},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  const Color.fromARGB(0, 206, 199, 198),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 50, 142, 53),
                                width: 2.0,
                              ),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  login() {
  
  }

  register() {
   
  }
}
