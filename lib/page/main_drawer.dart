// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/Search.dart';

class MainDrawerPage extends StatefulWidget {
  const MainDrawerPage({super.key});

  @override
  State<MainDrawerPage> createState() => _MainDrawerPageState();
}

class _MainDrawerPageState extends State<MainDrawerPage> {
  Widget currentPage = Container();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        log('Saving data before log out');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Main Drawer"),
        ),
        body: currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
          const BottomNavigationBarItem(icon: Icon(Icons.abc),label: 'ABC'),
          const BottomNavigationBarItem(icon: Icon(Icons.ac_unit),label: 'ZZZ')
        ],
        onTap: (value) {
          log(value.toString());
          if (value == 0) {
            currentPage = const SearchPage();
          }else if (value == 1){
            currentPage = const OrderPage();
          }
          setState(() {});
        },),
      ),
    );
  }
}
