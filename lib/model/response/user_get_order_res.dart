// To parse this JSON data, do
//
//     final userGetOrderResponse = userGetOrderResponseFromJson(jsonString);

import 'dart:convert';

UserGetOrderResponse userGetOrderResponseFromJson(String str) => UserGetOrderResponse.fromJson(json.decode(str));

String userGetOrderResponseToJson(UserGetOrderResponse data) => json.encode(data.toJson());

class UserGetOrderResponse {
    String orderId;
    int userId;
    String name;
    String phone;
    String userPhoto;
    String address;
    List<Product> products;

    UserGetOrderResponse({
        required this.orderId,
        required this.userId,
        required this.name,
        required this.phone,
        required this.userPhoto,
        required this.address,
        required this.products,
    });

    factory UserGetOrderResponse.fromJson(Map<String, dynamic> json) => UserGetOrderResponse(
        orderId: json["orderID"],
        userId: json["userID"],
        name: json["name"],
        phone: json["phone"],
        userPhoto: json["userPhoto"],
        address: json["address"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "userID": userId,
        "name": name,
        "phone": phone,
        "userPhoto": userPhoto,
        "address": address,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    int productId;
    String productPhoto;
    String detail;

    Product({
        required this.productId,
        required this.productPhoto,
        required this.detail,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productID"],
        productPhoto: json["productPhoto"],
        detail: json["detail"],
    );

    Map<String, dynamic> toJson() => {
        "productID": productId,
        "productPhoto": productPhoto,
        "detail": detail,
    };
}
