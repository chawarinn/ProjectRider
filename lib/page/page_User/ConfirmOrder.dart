import 'package:flutter/material.dart';

class ConfrimOrderPage extends StatefulWidget {
  const ConfrimOrderPage({super.key});

  @override
  State<ConfrimOrderPage> createState() => _ConfrimOrderPageState();
}

class _ConfrimOrderPageState extends State<ConfrimOrderPage> {
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
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Name : PPPP',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Phone : 0999999999',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const SizedBox(
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
                            Container(
                              width: 300, // เส้นยาวเต็มความกว้าง
                              height: 1, // ความสูงของเส้น
                              color: Colors.black, // สีของเส้น
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10), // ระยะห่าง
                            ),
                            const Text(
                              'Order : 12',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'ชานมไข่มุก',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
               Text(
                            'เพิ่มรูปภาพประกอบสถานะ',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 400,
                  height: 100,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                   
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: TextButton(
                  onPressed: ConfrimOrder,
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
                        onPressed: () {},
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
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {},
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
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  ConfrimOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfrimOrderPage(),
      ),
    );
  }
}
