import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; 
import 'package:http/http.dart' as http;
import 'package:path/path.dart'; 

class RegisterPageRider extends StatefulWidget {
  const RegisterPageRider({super.key});

  @override
  State<RegisterPageRider> createState() => _RegisterPageRiderState();
}

class _RegisterPageRiderState extends State<RegisterPageRider> {
  File? _image; 
  var fullnameCtl = TextEditingController();
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  var confirmpassCtl = TextEditingController();
  var numberCtl = TextEditingController(); 

  // Function to pick an image
  // Future<void> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
  //   if (image != null) {
  //     setState(() {
  //       _image = File(image.path);
  //     });
  //   }
  // }

  // Function to register the rider
  // Future<void> _registerRider() async {
  //   final value = await http.post(Uri.parse('$API_ENDPOINT/registerrider'); // Replace with your backend URL
  //   final request = http.MultipartRequest('POST', uri);

  //   request.fields['name'] = fullnameCtl.text;
  //   request.fields['phone'] = phoneCtl.text;
  //   request.fields['password'] = passwordCtl.text;
  //   request.fields['confirmPassword'] = confirmpassCtl.text;
  //   request.fields['number'] = numberCtl.text; // Car registration number

  //   if (_image != null) {
  //     request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
  //   }

  //   try {
  //     final response = await request.send();
  //     if (response.statusCode == 201) {
  //       final responseData = await http.Response.fromStream(response);
  //       // Handle successful registration
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Registration successful!')),
  //       );
  //     } else {
  //       final responseData = await http.Response.fromStream(response);
  //       // Handle error response
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Registration failed: ${responseData.body}')),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred. Please try again.')),
  //     );
  //   }
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
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/images/Profile2.jpg') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color.fromRGBO(232, 234, 237, 1),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.black),
                        onPressed:(){}
                        // onPressed: _pickImage, // Select image
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 60, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: fullnameCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
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
                    controller: passwordCtl,
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
                    controller: confirmpassCtl,
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
                    controller: numberCtl, // Car registration number
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
                  onPressed:(){},
                  // onPressed: _registerRider, // Call the register function
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
