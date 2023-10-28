import 'dart:convert';

List<PlaceholderModel> placeholderModelFromJson(String str) => List<PlaceholderModel>.from(json.decode(str).map((x) => PlaceholderModel.fromJson(x)));

String placeholderModelToJson(List<PlaceholderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaceholderModel {
  PlaceholderModel({
    required this.id,
    required this.placeholderTitle,
    required this.placeholderImage,
    required this.placeholderPosition,
    required this.placeholderLink,
  });

  String id;
  String placeholderTitle;
  String placeholderImage;
  int placeholderPosition;
  String placeholderLink;

  factory PlaceholderModel.fromJson(Map<String, dynamic> json) => PlaceholderModel(
    id: json["id"],
    placeholderTitle: json["placeholder_title"],
    placeholderImage: json["placeholder_image"],
    placeholderPosition: json["placeholder_position"],
    placeholderLink: json["placeholder_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "placeholder_title": placeholderTitle,
    "placeholder_image": placeholderImage,
    "placeholder_position": placeholderPosition,
    "placeholder_link": placeholderLink,
  };
}
