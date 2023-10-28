// To parse this JSON data, do
//
//     final paymentMethods = paymentMethodsFromJson(jsonString);

import 'dart:convert';

List<PaymentMethods> paymentMethodsFromJson(String str) => List<PaymentMethods>.from(json.decode(str).map((x) => PaymentMethods.fromJson(x)));

String paymentMethodsToJson(List<PaymentMethods> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentMethods {
  PaymentMethods({
    required this.status,
    required this.subtitle,
    required this.title,
    required this.id,
    required this.details,
  });

  String status;
  String subtitle;
  String title;
  int id;
  String details;

  factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
    status: json["status"],
    subtitle: json["subtitle"] == null ? null : json["subtitle"],
    title: json["title"],
    id: json["id"] == null ? null : json["id"],
    details: json["details"] == null ? null : json["details"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "subtitle": subtitle == null ? null : subtitle,
    "title": title,
    "id": id == null ? null : id,
    "details": details == null ? null : details,
  };
}
