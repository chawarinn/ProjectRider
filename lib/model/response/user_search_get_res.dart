// To parse this JSON data, do
//
//     final userSearchGetResponse = userSearchGetResponseFromJson(jsonString);

import 'dart:convert';

List<UserSearchGetResponse> userSearchGetResponseFromJson(String str) => List<UserSearchGetResponse>.from(json.decode(str).map((x) => UserSearchGetResponse.fromJson(x)));

String userSearchGetResponseToJson(List<UserSearchGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserSearchGetResponse {
    int userId;
    String name;
    String phone;
    String password;
    String photo;
    String address;

    UserSearchGetResponse({
        required this.userId,
        required this.name,
        required this.phone,
        required this.password,
        required this.photo,
        required this.address,
    });

    factory UserSearchGetResponse.fromJson(Map<String, dynamic> json) => UserSearchGetResponse(
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
