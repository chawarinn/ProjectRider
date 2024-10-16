// To parse this JSON data, do
//
//     final userPostOrderResponse = userPostOrderResponseFromJson(jsonString);

import 'dart:convert';

UserPostOrderResponse userPostOrderResponseFromJson(String str) => UserPostOrderResponse.fromJson(json.decode(str));

String userPostOrderResponseToJson(UserPostOrderResponse data) => json.encode(data.toJson());

class UserPostOrderResponse {
    String message;
    int orderId;

    UserPostOrderResponse({
        required this.message,
        required this.orderId,
    });

    factory UserPostOrderResponse.fromJson(Map<String, dynamic> json) => UserPostOrderResponse(
        message: json["message"],
        orderId: json["orderId"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "orderId": orderId,
    };
}