class UserSearchGetResponse {
  int userId;
  String name;
  String phone;
  String password;
  String photo;
  String address;
  double lat;  // Change int to double
  double long; // Change int to double

  UserSearchGetResponse({
    required this.userId,
    required this.name,
    required this.phone,
    required this.password,
    required this.photo,
    required this.address,
    required this.lat,
    required this.long,
  });

  factory UserSearchGetResponse.fromJson(Map<String, dynamic> json) => UserSearchGetResponse(
        userId: json["userID"],
        name: json["name"],
        phone: json["phone"],
        password: json["password"],
        photo: json["photo"],
        address: json["address"],
        lat: (json["lat"] as num).toDouble(),  // Cast lat to double
        long: (json["long"] as num).toDouble(), // Cast long to double
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
