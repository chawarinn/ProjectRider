import 'dart:convert';


List<RiderGetProductResponse> riderGetProductResponseFromJson(String str) =>
    List<RiderGetProductResponse>.from(
        json.decode(str).map((x) => RiderGetProductResponse.fromJson(x))
    );


String riderGetProductResponseToJson(List<RiderGetProductResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RiderGetProductResponse {

    int productId;
    String photo;
    String detail;
    int orderId;
    int userId;

    RiderGetProductResponse({
        required this.productId,
        required this.photo,
        required this.detail,
        required this.orderId,
        required this.userId,
    });

    factory RiderGetProductResponse.fromJson(Map<String, dynamic> json) => RiderGetProductResponse(
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
