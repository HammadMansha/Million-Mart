// To parse this JSON data, do
//
//     final getBargain = getBargainFromJson(jsonString);

import 'dart:convert';

List<GetBargain> getBargainFromJson(String str) => List<GetBargain>.from(json.decode(str).map((x) => GetBargain.fromJson(x)));

String getBargainToJson(List<GetBargain> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetBargain {
  GetBargain({
    required this.id,
    required this.slug,
    required this.userId,
    required this.competitorPrice,
    required this.competitorLink,
    this.prodcut_name,
    this.photo,
  });

  String id;
  String slug;
  String userId;
  String competitorPrice;
  String competitorLink;
  String? prodcut_name;
  String? photo;

  factory GetBargain.fromJson(Map<String, dynamic> json) => GetBargain(
    id: json["id"],
    slug: json["slug"],
    userId: json["user_id"],
    competitorPrice: json["competitor_price"],
    competitorLink: json["competitor_link"],
    prodcut_name: json["prodcut_name"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "user_id": userId,
    "competitor_price": competitorPrice,
    "competitor_link": competitorLink,
    "photo": photo,
    "prodcut_name": prodcut_name,
  };
}
