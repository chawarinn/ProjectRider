import 'package:flutter/material.dart';
import 'dart:io';

class RegisterPageRider extends StatefulWidget {
  const RegisterPageRider({super.key});

  @override
  State<RegisterPageRider> createState() => _RegisterPageRiderState();
}

class _RegisterPageRiderState extends State<RegisterPageRider> {
  File? _image; // ตัวแปรสำหรับเก็บรูปที่เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Register Rider',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black),
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
                    // controller: emailCtl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextField(
                    // controller: passwordCtl,
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
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextField(
                    // controller: passwordCtl,
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
            //        Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const SizedBox(height: 10),
            //       Center(
            //         child: _image == null
            //             ? const Text('No image selected.')
            //             : Image.file(
            //                 _image!,
            //                 width: 150,
            //                 height: 150,
            //               ),
            //       ),
            //       const SizedBox(height: 10),
            //       Center(
            //         child: ElevatedButton(
            //           onPressed: (){},
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: const Color.fromARGB(255, 50, 142, 53),
            //           ),
            //           child: const Text('Attach Image'),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Car registration',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextField(
                    // controller: passwordCtl,
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
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add register logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 50, 142, 53),
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
