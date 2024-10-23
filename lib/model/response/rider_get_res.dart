// To parse this JSON data, do
//
//     final riderResponse = riderResponseFromJson(jsonString);

import 'dart:convert';

RiderResponse riderResponseFromJson(String str) => RiderResponse.fromJson(json.decode(str));

String riderResponseToJson(RiderResponse data) => json.encode(data.toJson());

class RiderResponse {
    String orderId;
    int riderId;
    String riderName;
    String riderPhone;
    String riderPhoto;
    String riderCar;

    RiderResponse({
        required this.orderId,
        required this.riderId,
        required this.riderName,
        required this.riderPhone,
        required this.riderPhoto,
        required this.riderCar,
    });

    factory RiderResponse.fromJson(Map<String, dynamic> json) => RiderResponse(
        orderId: json["orderID"],
        riderId: json["riderID"],
        riderName: json["riderName"],
        riderPhone: json["riderPhone"],
        riderPhoto: json["riderPhoto"],
        riderCar: json["riderCar"],
    );

    Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "riderID": riderId,
        "riderName": riderName,
        "riderPhone": riderPhone,
        "riderPhoto": riderPhoto,
        "riderCar": riderCar,
    };
}
