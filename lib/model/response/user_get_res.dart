// To parse this JSON data, do
//
//     final userGetResponse = userGetResponseFromJson(jsonString);

import 'dart:convert';

UserGetResponse userGetResponseFromJson(String str) => UserGetResponse.fromJson(json.decode(str));

String userGetResponseToJson(UserGetResponse data) => json.encode(data.toJson());

class UserGetResponse {
    int userId;
    String name;
    String phone;
    String password;
    String photo;
    String address;

    UserGetResponse({
        required this.userId,
        required this.name,
        required this.phone,
        required this.password,
        required this.photo,
        required this.address,
    });

    factory UserGetResponse.fromJson(Map<String, dynamic> json) => UserGetResponse(
        userId: json["userID"],
        name: json["name"],
        phone: json["phone"],
        password: json["password"],
        photo: json["photo"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "name": name,
        "phone": phone,
        "password": password,
        "photo": photo,
        "address": address,
    };
}
