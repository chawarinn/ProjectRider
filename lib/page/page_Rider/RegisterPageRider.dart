import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project_rider/page/login.dart';
import 'package:path/path.dart';
import 'package:mini_project_rider/config/internet_config.dart';

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

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Image selection failed: $e");
    }
  }

  // Method to register rider
  Future<void> _registerRider(BuildContext context) async {
    // Validate inputs
    if (fullnameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        passwordCtl.text.isEmpty ||
        confirmpassCtl.text.isEmpty ||
        numberCtl.text.isEmpty) {
      _showAlertDialog(context, "กรอกข้อมูลไม่ครบ");
      return;
    }

    // Check if passwords match
    if (passwordCtl.text != confirmpassCtl.text) {
      _showAlertDialog(context, "รหัสผ่านไม่ตรงกัน");
      return;
    }

    // Check if image is added
    if (_image == null) {
      _showAlertDialog(context, "กรุณาเพิ่มรูปโปรไฟล์");
      return;
    }

    // Create a request for registering rider
    var uri = Uri.parse("$API_ENDPOINT/registerR");
    var request = http.MultipartRequest('POST', uri);

    // Add image to request
    var imageStream = http.ByteStream(_image!.openRead());
    var imageLength = await _image!.length();
    var multipartFile = http.MultipartFile('file', imageStream, imageLength,
        filename: basename(_image!.path));
    request.files.add(multipartFile);

    // Add user data to request
    request.fields['name'] = fullnameCtl.text;
    request.fields['phone'] = phoneCtl.text;
    request.fields['password'] = passwordCtl.text;
    request.fields['confirmPassword'] = confirmpassCtl.text;
    request.fields['car'] = numberCtl.text;

    // Send request and check response
    var response = await request.send();

    if (response.statusCode == 201) {
      _showAlertDialog(context, "สมัครสมาชิกสำเร็จ", onOkPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    } else {
      _showAlertDialog(
          context, "ไม่สามารถสมัครสมาชิกได้ เบอร์นี้ถูกใช้ไปแล้ว");
    }
  }

  // Alert dialog function
  void _showAlertDialog(BuildContext context, String message,
      {VoidCallback? onOkPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onOkPressed != null) {
                  onOkPressed();
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

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
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
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
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/images/Profile.png')
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color.fromRGBO(232, 234, 237, 1),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.black),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
                decoration: const InputDecoration(
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    'Car Number',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextField(
                    controller: numberCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 11, 102, 35),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _registerRider(context); // Pass context when registering
                },
                child: const Text("Register"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
