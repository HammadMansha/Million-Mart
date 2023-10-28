// To parse this JSON data, do
//
//     final requestBargain = requestBargainFromJson(jsonString);

import 'dart:convert';

RequestBargain requestBargainFromJson(String str) => RequestBargain.fromJson(json.decode(str));

String requestBargainToJson(RequestBargain data) => json.encode(data.toJson());

class RequestBargain {
  RequestBargain({
    required this.slug,
    required this.competitorLink,
    required this.competitorPrice,
    required this.userId,
    required this.timestamp,
  });

  String slug;
  String competitorLink;
  String competitorPrice;
  String userId;
  DateTime timestamp;

  factory RequestBargain.fromJson(Map<String, dynamic> json) => RequestBargain(
    slug: json["slug"],
    competitorLink: json["competitor_link"],
    competitorPrice: json["competitor_price"],
    userId: json["user_id"],
    timestamp: DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "slug": slug,
    "competitor_link": competitorLink,
    "competitor_price": competitorPrice,
    "user_id": userId,
    "timestamp": timestamp.toIso8601String(),
  };
}
