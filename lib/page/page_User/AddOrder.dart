import 'package:flutter/material.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_User/ConfirmOrder.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
   int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        title: const Text(
          'Add Order',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
         actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black), // Logout icon
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const homeLogoPage(),
                            ),
                          );
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name : PPPP',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Phone : 0999999999',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5), 
                            SizedBox(
                              width: 300, 
                              child: Text(
                                'Address : Kham Riang, Kantha rawichai District, MahaSarakham, 44150, Thailand',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                softWrap: true, 
                                overflow: TextOverflow.visible, 
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 130,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    _showAddProductDialog(context); // เรียกฟังก์ชันแสดง pop-up
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 217, 217, 217),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
             const SizedBox(height: 20), 
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), 
                ),
                elevation: 5, 
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                       Image.asset(
                    'assets/images/Delivery.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover, 
                  ),
                      const SizedBox(width: 20),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ชานมไข่มุก',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: 100,
                height: 50,
                child: TextButton(
                    onPressed:
                     ConfrimOrder,
                 
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 50, 142, 53),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle),
            label: 'Rider',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Delivery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 126, 15),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color.fromARGB(255, 11, 102, 35),
        onTap: _onItemTapped,
      ),
    );
  }


void _showAddProductDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: 400, 
          height: 350, 
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Center(
                child: SizedBox(
                    width: 200, 
                    height: 200,
                  child: Card(
                    color: const Color.fromARGB(255, 220, 220, 220),
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo, size: 40), 
                      onPressed: () {
                      },
                    ),
                  ),
                ),
                
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail :',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(height: 10), // เพิ่มระยะห่าง
                    TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: const Text(
              'Cancel',
               style: TextStyle(fontSize: 18, color: Colors.black),),
          ),
          TextButton( 
            onPressed: () {
            },
            style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 50, 142, 53),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
            ),
            child: const Text(
              'OK',
               style: TextStyle(fontSize: 18, color: Colors.black),),
          ),
        ],
      );
    },
  );
}
ConfrimOrder(){
   Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ConfrimOrderPage(), 
                        ),
                      );
   }

}
