// To parse this JSON data, do
//
//     final userGetResponse = userGetResponseFromJson(jsonString);

import 'dart:convert';

List<UserGetResponse> userGetResponseFromJson(String str) => List<UserGetResponse>.from(json.decode(str).map((x) => UserGetResponse.fromJson(x)));

String userGetResponseToJson(List<UserGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserGetResponse {
    int userId;
    String name;
    String phone;
    String password;
    String photo;
    String address;
    double lat;
    double long;

    UserGetResponse({
        required this.userId,
        required this.name,
        required this.phone,
        required this.password,
        required this.photo,
        required this.address,
        required this.lat,
        required this.long,
    });

    factory UserGetResponse.fromJson(Map<String, dynamic> json) => UserGetResponse(
        userId: json["userID"],
        name: json["name"],
        phone: json["phone"],
        password: json["password"],
        photo: json["photo"],
        address: json["address"],
        lat: json["lat"]?.toDouble(),
        long: json["long"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "name": name,
        "phone": phone,
        "password": password,
        "photo": photo,
        "address": address,
        "lat": lat,
        "long": long,
    };
}
