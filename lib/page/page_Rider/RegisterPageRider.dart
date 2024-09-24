import 'package:flutter/material.dart';

class RegisterPageRider extends StatefulWidget {
  const RegisterPageRider({super.key});

  @override
  State<RegisterPageRider> createState() => _RegisterPageRiderState();
}

class _RegisterPageRiderState extends State<RegisterPageRider> {
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView()
    );
  }
}