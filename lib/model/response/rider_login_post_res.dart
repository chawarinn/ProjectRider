// To parse this JSON data, do
//
//     final ridersLoginPostResponse = ridersLoginPostResponseFromJson(jsonString);

import 'dart:convert';

RidersLoginPostResponse ridersLoginPostResponseFromJson(String str) => RidersLoginPostResponse.fromJson(json.decode(str));

String ridersLoginPostResponseToJson(RidersLoginPostResponse data) => json.encode(data.toJson());

class RidersLoginPostResponse {
    String message;
    Rider rider;

    RidersLoginPostResponse({
        required this.message,
        required this.rider,
    });

    factory RidersLoginPostResponse.fromJson(Map<String, dynamic> json) => RidersLoginPostResponse(
        message: json["message"],
        rider: Rider.fromJson(json["rider"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "rider": rider.toJson(),
    };
}

class Rider {
    int riderId;
    String name;
    String phone;
    String password;
    String photo;
    String car;

    Rider({
        required this.riderId,
        required this.name,
        required this.phone,
        required this.password,
        required this.photo,
        required this.car,
    });

    factory Rider.fromJson(Map<String, dynamic> json) => Rider(
        riderId: json["riderID"],
        name: json["name"],
        phone: json["phone"],
        password: json["password"],
        photo: json["photo"],
        car: json["car"],
    );

    Map<String, dynamic> toJson() => {
        "riderID": riderId,
        "name": name,
        "phone": phone,
        "password": password,
        "photo": photo,
        "car": car,
    };
}
