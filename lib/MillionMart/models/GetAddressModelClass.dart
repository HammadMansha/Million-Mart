// To parse this JSON data, do
//
//     final getAddress = getAddressFromJson(jsonString);

import 'dart:convert';

GetAddress getAddressFromJson(String str) => GetAddress.fromJson(json.decode(str));

String getAddressToJson(GetAddress data) => json.encode(data.toJson());

class GetAddress {
  GetAddress({
    required this.id,
    required this.userId,
    required this.city,
    required this.town,
    required this.address,
    required this.country,
  });

  int id;
  String userId;
  String city;
  String town;
  String address;
  String country;

  factory GetAddress.fromJson(Map<String, dynamic> json) => GetAddress(
    id: json["id"],
    userId: json["user_id"],
    city: json["city"],
    town: json["town"],
    address: json["address"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "city": city,
    "town": town,
    "address": address,
    "country": country,
  };
}
