// To parse this JSON data, do
//
//     final millionMallModel = millionMallModelFromJson(jsonString);

import 'dart:convert';

List<MillionMallModel> millionMallModelFromJson(String str) => List<MillionMallModel>.from(json.decode(str).map((x) => MillionMallModel.fromJson(x)));

String millionMallModelToJson(List<MillionMallModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MillionMallModel {
  MillionMallModel({
    this.id,
    this.banner,
    this.link,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? banner;
  String? link;
  String? position;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory MillionMallModel.fromJson(Map<String, dynamic> json) => MillionMallModel(
    id: json["id"],
    banner: json["banner"],
    link: json["link"],
    position: json["position"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "banner": banner,
    "link": link,
    "position": position,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
