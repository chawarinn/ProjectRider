import 'package:flutter/material.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_Rider/OrderPageRider.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/ProfilePage.dart';
import 'package:mini_project_rider/page/page_User/Status.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProfilePage()
    );
  }
}
