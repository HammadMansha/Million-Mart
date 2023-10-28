// To parse this JSON data, do
//
//     final promoCode = promoCodeFromJson(jsonString);

import 'dart:convert';

List<PromoCode> promoCodeFromJson(String str) => List<PromoCode>.from(json.decode(str).map((x) => PromoCode.fromJson(x)));

String promoCodeToJson(List<PromoCode> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PromoCode {
  PromoCode({
    this.used,
    this.times,
    this.code,
    this.type,
    this.price,
  });

  int? used;
  dynamic times;
  String? code;
  int? type;
  int? price;

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
    used: json["used"],
    times: json["times"],
    code: json["code"],
    type: json["type"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "used": used,
    "times": times,
    "code": code,
    "type": type,
    "price": price,
  };
}
