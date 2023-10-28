// To parse this JSON data, do
//
//     final shippingModel = shippingModelFromJson(jsonString);

import 'dart:convert';

List<ShippingModel> shippingModelFromJson(String str) => List<ShippingModel>.from(json.decode(str).map((x) => ShippingModel.fromJson(x)));

String shippingModelToJson(List<ShippingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShippingModel {
  ShippingModel({
    required this.title,
    required this.subtitle,
    required this.price,
  });

  String title;
  String subtitle;
  String price;

  factory ShippingModel.fromJson(Map<String, dynamic> json) => ShippingModel(
    title: json["title"],
    subtitle: json["subtitle"],
    price: json["price"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
    "price": price,
  };
}
