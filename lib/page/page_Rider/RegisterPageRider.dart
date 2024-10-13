import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for input formatters
import 'dart:io';

class RegisterPageRider extends StatefulWidget {
  const RegisterPageRider({super.key});

  @override
  State<RegisterPageRider> createState() => _RegisterPageRiderState();
}

class _RegisterPageRiderState extends State<RegisterPageRider> {
  File? _image; // Variable to hold the selected image
  var fullnameCtl = TextEditingController();
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  var confirmpassCtl = TextEditingController();

  @override
  // void dispose() {
  //   fullnameCtl.dispose();
  //   phoneCtl.dispose();
  //   emailCtl.dispose();
  //   passwordCtl.dispose();
  //   confirmpassCtl.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Register Rider',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 60, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextField(
                    // Controller for full name
                    decoration: InputDecoration(
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
                    'Phone',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextField(
                    controller: phoneCtl, // Set the controller
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Only allow digits
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1),
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
                    controller: passwordCtl, // Set the controller
                    obscureText: true,
                    decoration: InputDecoration(
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
                    'Confirm Password',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextField(
                    controller: confirmpassCtl, // Set the controller
                    obscureText: true,
                    decoration: InputDecoration(
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
                    'Car registration',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextField(
                    // Assuming you want this field to be text only
                    decoration: InputDecoration(
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
                    // Add register logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 50, 142, 53),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Register',
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
    );
  }
}
