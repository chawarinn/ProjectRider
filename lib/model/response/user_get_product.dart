// To parse this JSON data, do
//
//     final userGetProductResponse = userGetProductResponseFromJson(jsonString);

import 'dart:convert';

List<UserGetProductResponse> userGetProductResponseFromJson(String str) => List<UserGetProductResponse>.from(json.decode(str).map((x) => UserGetProductResponse.fromJson(x)));

String userGetProductResponseToJson(List<UserGetProductResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserGetProductResponse {
    int productId;
    String photo;
    String detail;
    int orderId;
    int userId;

    UserGetProductResponse({
        required this.productId,
        required this.photo,
        required this.detail,
        required this.orderId,
        required this.userId,
    });

    factory UserGetProductResponse.fromJson(Map<String, dynamic> json) => UserGetProductResponse(
        productId: json["productID"],
        photo: json["photo"],
        detail: json["detail"],
        orderId: json["orderID"],
        userId: json["userID"],
    );

    Map<String, dynamic> toJson() => {
        "productID": productId,
        "photo": photo,
        "detail": detail,
        "orderID": orderId,
        "userID": userId,
    };
}
