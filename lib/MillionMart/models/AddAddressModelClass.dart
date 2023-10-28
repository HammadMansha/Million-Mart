// To parse this JSON data, do
//
//     final addAddress = addAddressFromJson(jsonString);

import 'dart:convert';

List<AddAddress> addAddressFromJson(String str) => List<AddAddress>.from(json.decode(str).map((x) => AddAddress.fromJson(x)));

String addAddressToJson(List<AddAddress> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddAddress {
  AddAddress({
    required this.address,
    required this.country,
    required this.city,
    required this.town,
    required this.userId,
    required this.zip
  });

  String address;
  String country;
  String city;
  String town;
  String userId;
  String zip;

  factory AddAddress.fromJson(Map<String, dynamic> json) => AddAddress(
    address: json["address"],
    country: json["country"],
    city: json["city"],
    town: json["town"],
    zip: json['zip'],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "country": country,
    "city": city,
    "town": town,
    "zip":zip,
    "user_id": userId,
  };
}
