// To parse this JSON data, do
//
//     final userPutOrderResponse = userPutOrderResponseFromJson(jsonString);

import 'dart:convert';

UserPutOrderResponse userPutOrderResponseFromJson(String str) => UserPutOrderResponse.fromJson(json.decode(str));

String userPutOrderResponseToJson(UserPutOrderResponse data) => json.encode(data.toJson());

class UserPutOrderResponse {
    String message;
    String imageUrl;

    UserPutOrderResponse({
        required this.message,
        required this.imageUrl,
    });

    factory UserPutOrderResponse.fromJson(Map<String, dynamic> json) => UserPutOrderResponse(
        message: json["message"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "imageUrl": imageUrl,
    };
}
