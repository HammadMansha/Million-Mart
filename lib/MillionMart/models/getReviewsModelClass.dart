// To parse this JSON data, do
//
//     final reviewsModelClass = reviewsModelClassFromJson(jsonString);

import 'dart:convert';

List<ReviewsModelClass> reviewsModelClassFromJson(String str) => List<ReviewsModelClass>.from(json.decode(str).map((x) => ReviewsModelClass.fromJson(x)));

String reviewsModelClassToJson(List<ReviewsModelClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewsModelClass {
  ReviewsModelClass({
    required this.id,
    required this.userId,
    required this.productId,
    this.review,
    this.rating,
    this.reviewDate,
    this.imagevideo,
  });

  int id;
  String userId;
  String productId;
  String? review;
  String? rating;
  DateTime? reviewDate;
  String? imagevideo;

  factory ReviewsModelClass.fromJson(Map<String, dynamic> json) => ReviewsModelClass(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    review: json["review"],
    rating: json["rating"],
    reviewDate: DateTime.parse(json["review_date"]),
    imagevideo: json["imagevideo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "review": review,
    "rating": rating,
    "review_date": reviewDate!.toIso8601String(),
    "imagevideo": imagevideo,
  };
}
