// To parse this JSON data, do
//
//     final userGetOrderReceiverResponse = userGetOrderReceiverResponseFromJson(jsonString);

import 'dart:convert';

List<UserGetOrderReceiverResponse> userGetOrderReceiverResponseFromJson(String str) => List<UserGetOrderReceiverResponse>.from(json.decode(str).map((x) => UserGetOrderReceiverResponse.fromJson(x)));

String userGetOrderReceiverResponseToJson(List<UserGetOrderReceiverResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserGetOrderReceiverResponse {
    int orderId;
    int userIdSender;
    String name;
    String orderPhoto;
    String phone;
    String userPhoto;
    String address;
    String status;
    List<Product> products;

    UserGetOrderReceiverResponse({
        required this.orderId,
        required this.userIdSender,
        required this.name,
        required this.orderPhoto,
        required this.phone,
        required this.userPhoto,
        required this.address,
        required this.status,
        required this.products,
    });

    factory UserGetOrderReceiverResponse.fromJson(Map<String, dynamic> json) => UserGetOrderReceiverResponse(
        orderId: json["orderID"],
        userIdSender: json["userIDSender"],
        name: json["name"],
        orderPhoto: json["orderPhoto"],
        phone: json["phone"],
        userPhoto: json["userPhoto"],
        address: json["address"],
        status: json["Status"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "userIDSender": userIdSender,
        "name": name,
        "orderPhoto": orderPhoto,
        "phone": phone,
        "userPhoto": userPhoto,
        "address": address,
        "Status": status,
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
