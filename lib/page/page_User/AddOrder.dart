import 'package:flutter/material.dart';
import 'package:mini_project_rider/config/config.dart';
import 'package:mini_project_rider/config/internet_config.dart';
import 'package:mini_project_rider/model/response/user_get_product.dart';
import 'package:mini_project_rider/model/response/user_get_res.dart';
import 'package:mini_project_rider/page/home.dart';
import 'package:mini_project_rider/page/page_User/ConfirmOrder.dart';
import 'package:mini_project_rider/page/page_User/Order.dart';
import 'package:mini_project_rider/page/page_User/OrderReceiver.dart';
import 'package:mini_project_rider/page/page_User/ProfilePage.dart';
import 'package:mini_project_rider/page/page_User/Search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddOrderPage extends StatefulWidget {
final int userId; 
  final int UserId; 

  AddOrderPage({super.key, required this.userId, required this.UserId});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  int _selectedIndex = 0;
  File? _image;
  String url = '';
  UserGetResponse? userData; 
  final detailCtl = TextEditingController();
    List<UserGetProductResponse> userProduct  = [];
  List<UserGetProductResponse> filteredProduct  = []; 
    bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    }).catchError((err) {
      log(err.toString());
    });
    loadDataAsync();
    fetchProducts();
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
      log('Image selection failed: $e');
    }
  }


  Future<void> loadDataAsync() async {
    try {
      var response = await http.get(Uri.parse('$API_ENDPOINT/users/user?userID=${widget.UserId}')); // Use the url variable
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          userData = UserGetResponse.fromJson(data[0]); 
        });
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
  }

Future<void> fetchProducts() async {
  try {
    var response = await http.get(
      Uri.parse('$API_ENDPOINT/order/products?userID=${widget.UserId}&userIDSender=${widget.userId}')
    );
 if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      userProduct = jsonData.map((e) => UserGetProductResponse.fromJson(e)).toList();

      setState(() {
        filteredProduct = userProduct; // Update the UI with the latest products
        log(filteredProduct.toString());
      });
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  } catch (e) {
    log(e.toString());
  }
}
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage(userId: widget.userId)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderPage(userId: widget.userId)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderReceiver(userId: widget.userId)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
        );
        break;
    }
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
             Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage(userId: widget.userId)),
        );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black), 
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
                          Navigator.of(context).pop(); 
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name : ${userData?.name ?? "Loading..."}', // Handle null case
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Phone : ${userData?.phone ?? "Loading..."}', // Handle null case
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5), 
                            SizedBox(
                              width: 300, 
                              child: Text(
                                'Address : ${userData?.address ?? "Loading..."}', // Handle null case
                                style: const TextStyle(
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
                    _showAddProductDialog(context);
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
  filteredProduct.isEmpty
            ? const Center(child: Text('There are no products'))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProduct.length,
                itemBuilder: (context, index) {
                  var user = filteredProduct[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          if (user != null) 
                            Image.network(
                              user!.photo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          else
                            const CircularProgressIndicator(), 
                          const SizedBox(width: 20),
                          Expanded(
                            child: user != null
                                ? Text(
                                    user!.detail,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const Text('Loading...'), // Placeholder text while loading
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: TextButton(
                  onPressed: confirmOrder, 
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
          BottomNavigationBarItem(icon: Icon(Icons.motorcycle), label: 'Rider'),
          BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: 'Delivery'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
       currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 126, 15),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

 Future<void> confirmOrder() async {
    setState(() {
      isLoading = true; 
      errorMessage = null; 
    });
   try {
      final response = await http.post(
        Uri.parse('$API_ENDPOINT/order/addorder'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'userID': widget.UserId,
          'userIDSender': widget.userId,
          'Status': '0', 
          'photo': '0', 
          'products': [], 
        }),
      );

      if (response.statusCode == 201) {
        print(response.statusCode);
        final orderId = jsonDecode(response.body)['orderId'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfrimOrderPage(userId: widget.userId, orderId: orderId),
          ),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        setState(() {
          errorMessage = errorResponse['error'] ?? 'Unknown error occurred';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error connecting to server: $e';
      });
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }
void _showAddProductDialog(BuildContext context) {
 showDialog(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: AlertDialog(
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
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail:',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: detailCtl,
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                insertProduct();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    },
  );
}
void insertProduct() async {
    String url = '$API_ENDPOINT/order/product';
    String orderId = "0"; 

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['orderID'] = orderId
      ..fields['detail'] = detailCtl.text
      ..fields['userID'] = widget.UserId.toString()
      ..fields['userIDSender'] = widget.userId.toString(); 

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _image!.path,
        filename: 'image.png',
      ));
    }

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(responseData.body);
        print('Insert Product successfully: ${jsonResponse['message']}');
        print('Image URL: ${jsonResponse['imageUrl']}');
        await fetchProducts(); 
        
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  AddOrderPage(userId: widget.userId,UserId:widget.UserId )),
        );
      } else {
        print('Failed to insert product: ${responseData.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
