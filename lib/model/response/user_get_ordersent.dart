// To parse this JSON data, do
//
//     final userGetOrderSentResponse = userGetOrderSentResponseFromJson(jsonString);

import 'dart:convert';

List<UserGetOrderSentResponse> userGetOrderSentResponseFromJson(String str) => List<UserGetOrderSentResponse>.from(json.decode(str).map((x) => UserGetOrderSentResponse.fromJson(x)));

String userGetOrderSentResponseToJson(List<UserGetOrderSentResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserGetOrderSentResponse {
    int orderId;
    int userId;
    String name;
    String orderPhoto;
    String phone;
    String userPhoto;
    String address;
    List<Product> products;

    UserGetOrderSentResponse({
        required this.orderId,
        required this.userId,
        required this.name,
        required this.orderPhoto,
        required this.phone,
        required this.userPhoto,
        required this.address,
        required this.products,
    });

    factory UserGetOrderSentResponse.fromJson(Map<String, dynamic> json) => UserGetOrderSentResponse(
        orderId: json["orderID"],
        userId: json["userID"],
        name: json["name"],
        orderPhoto: json["orderPhoto"],
        phone: json["phone"],
        userPhoto: json["userPhoto"],
        address: json["address"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "userID": userId,
        "name": name,
        "orderPhoto": orderPhoto,
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
