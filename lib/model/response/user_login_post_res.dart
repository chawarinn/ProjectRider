// To parse this JSON data, do
//
//     final usersLoginPostResponse = usersLoginPostResponseFromJson(jsonString);

import 'dart:convert';

UsersLoginPostResponse usersLoginPostResponseFromJson(String str) => UsersLoginPostResponse.fromJson(json.decode(str));

String usersLoginPostResponseToJson(UsersLoginPostResponse data) => json.encode(data.toJson());

class UsersLoginPostResponse {
    String message;
    User user;

    UsersLoginPostResponse({
        required this.message,
        required this.user,
    });

    factory UsersLoginPostResponse.fromJson(Map<String, dynamic> json) => UsersLoginPostResponse(
        message: json["message"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
    };
}

class User {
    int userId;
    String name;
    String phone;
    String password;
    String photo;
    String address;
    String map;

    User({
        required this.userId,
        required this.name,
        required this.phone,
        required this.password,
        required this.photo,
        required this.address,
        required this.map,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userID"],
        name: json["name"],
        phone: json["phone"],
        password: json["password"],
        photo: json["photo"],
        address: json["address"],
        map: json["map"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "name": name,
        "phone": phone,
        "password": password,
        "photo": photo,
        "address": address,
        "map": map,
    };
}
