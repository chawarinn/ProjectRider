import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:developer';
import 'dart:convert';  
import 'package:http/http.dart' as http;
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/response/user_get_address.dart';
import 'package:path/path.dart' as path;
import 'package:mini_project_rider/page/login.dart';
import 'package:mini_project_rider/page/page_User/Location.dart';

class RegisterPageUser extends StatefulWidget {
  const RegisterPageUser({super.key});

  @override
  State<RegisterPageUser> createState() => _RegisterPageUserState();
}

class _RegisterPageUserState extends State<RegisterPageUser> {
  File? _image;
  String url = '';
  final fullnameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final confirmpassCtl = TextEditingController();
  final addressCtl = TextEditingController();
  final db = FirebaseFirestore.instance;

  String? selectedLocation;
  double? selectedLatitude;
  double? selectedLongitude;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    }).catchError((err) {
      log(err.toString());
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showAlertDialog(context, "Image selection failed: $e");
    }
  }

  Future<void> _registerUser(BuildContext context) async {
    if (fullnameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        passwordCtl.text.isEmpty ||
        confirmpassCtl.text.isEmpty ||
        addressCtl.text.isEmpty) {
      _showAlertDialog(context, "กรอกข้อมูลไม่ครบ");
      return;
    }

    if (passwordCtl.text != confirmpassCtl.text) {
      _showAlertDialog(context, "รหัสผ่านไม่ตรงกัน");
      return;
    }

    if (_image == null) {
      _showAlertDialog(context, "กรุณาเพิ่มรูปโปรไฟล์");
      return;
    }

    var uri = Uri.parse("$API_ENDPOINT/registerU");
    var request = http.MultipartRequest('POST', uri);

    var imageStream = http.ByteStream(_image!.openRead());
    var imageLength = await _image!.length();
    var multipartFile = http.MultipartFile(
      'file',
      imageStream,
      imageLength,
      filename: path.basename(_image!.path),
    );

    request.files.add(multipartFile);

    request.fields['name'] = fullnameCtl.text;
    request.fields['phone'] = phoneCtl.text;
    request.fields['password'] = passwordCtl.text;
    request.fields['confirmPassword'] = confirmpassCtl.text;
    request.fields['address'] = addressCtl.text;
    request.fields['lat'] = selectedLatitude?.toString() ?? '';
    request.fields['long'] = selectedLongitude?.toString() ?? '';

    try {
      var response = await request.send();

      if (response.statusCode == 201) {
        var data = await response.stream.bytesToString();
        log(data);
        var userData = userGetAddressResponseFromJson(data);

        _showAlertDialog(context, "สมัครสมาชิกสำเร็จ", onOkPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      } else {
        var errorData = await response.stream.bytesToString(); 
        _showAlertDialog(context, "ไม่สามารถสมัครสมาชิกได้ เบอร์นี้ถูกใช้ไปแล้ว ");
      }
    } catch (e) {
      _showAlertDialog(context, "Error during registration: $e");
    }
  }

  void _showAlertDialog(BuildContext context, String message, {VoidCallback? onOkPressed}) {
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

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationPage(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedLatitude = result['latitude'];
        selectedLongitude = result['longitude'];
        selectedLocation = "$selectedLatitude, $selectedLongitude"; // แสดงผลตำแหน่งที่เลือก
        addressCtl.text = result['Address'] ?? ''; // กำหนดค่าที่อยู่จากตำแหน่ง
      });
      log('Selected Location: $selectedLocation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Register User',
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
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/images/Profile.png') as ImageProvider,
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
            _buildTextField('Name', fullnameCtl),
            _buildTextField('Phone', phoneCtl, keyboardType: TextInputType.phone),
            _buildTextField('Password', passwordCtl, obscureText: true),
            _buildTextField('Confirm Password', confirmpassCtl, obscureText: true),
            _buildTextField('Address', addressCtl),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  const Spacer(),
                  if (selectedLocation != null) ...[
                    Text(
                      selectedLocation!,
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _selectLocation,
                      child: const Icon(
                        Icons.add_location_alt_rounded,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: _selectLocation,
                      child: const Icon(
                        Icons.add_location_alt_rounded,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 11, 102, 35),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () => _registerUser(context),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 20),
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