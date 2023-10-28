// // To parse this JSON data, do
// //
// //     final homeSectiontModel = homeSectiontModelFromJson(jsonString);
//
// import 'dart:convert';
//
// List<HomeSectiontModel> homeSectiontModelFromJson(String str) => List<HomeSectiontModel>.from(json.decode(str).map((x) => HomeSectiontModel.fromJson(x)));
//
// String homeSectiontModelToJson(List<HomeSectiontModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class HomeSectiontModel {
//   HomeSectiontModel({
//     required this.bestSeller,
//     required this.featured,
//     required this.hotProduct,
//   });
//
//   BestSeller? bestSeller;
//   BestSeller? featured;
//   BestSeller? hotProduct;
//
//   factory HomeSectiontModel.fromJson(Map<String, dynamic> json) => HomeSectiontModel(
//     bestSeller: json["Best Seller"] == null ? null : BestSeller.fromJson(json["Best Seller"]),
//     featured: json["Featured"] == null ? null : BestSeller.fromJson(json["Featured"]),
//     hotProduct: json["Hot Product"] == null ? null : BestSeller.fromJson(json["Hot Product"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Best Seller": bestSeller == null ? null : bestSeller!.toJson(),
//     "Featured": featured == null ? null : featured!.toJson(),
//     "Hot Product": hotProduct == null ? null : hotProduct!.toJson(),
//   };
// }
//
// class BestSeller {
//   BestSeller({
//     required this.product,
//     required this.title,
//     required this.sectionname,
//     required this.position,
//   });
//
//   List<Product> product;
//   String title;
//   String sectionname;
//   String position;
//
//   factory BestSeller.fromJson(Map<String, dynamic> json) => BestSeller(
//     product: List<Product>.from(json["Product"].map((x) => Product.fromJson(x))),
//     title: json["title"],
//     sectionname: json["sectionname"],
//     position: json["position"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Product": List<dynamic>.from(product.map((x) => x.toJson())),
//     "title": title,
//     "sectionname": sectionname,
//     "position": position,
//   };
// }
//
// class Product {
//   Product({
//     required this.id,
//     required this.name,
//     required this.slug,
//     required this.price,
//     required this.previousPrice,
//     required this.photo,
//     required this.rating,
//   });
//
//   int id;
//   String name;
//   String slug;
//   String price;
//   String previousPrice;
//   String photo;
//   List<Rating> rating;
//
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     id: json["id"],
//     name: json["name"],
//     slug: json["slug"],
//     price: json["price"],
//     previousPrice: json["previous_price"],
//     photo: json["photo"],
//     rating: List<Rating>.from(json["rating"].map((x) => Rating.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "slug": slug,
//     "price": price,
//     "previous_price": previousPrice,
//     "photo": photo,
//     "rating": List<dynamic>.from(rating.map((x) => x.toJson())),
//   };
// }
//
// class Rating {
//   Rating({
//     required this.id,
//     required this.userId,
//     required this.productId,
//     required this.review,
//     required this.rating,
//     required this.reviewDate,
//   });
//
//   int id;
//   String userId;
//   String productId;
//   String review;
//   String rating;
//   DateTime reviewDate;
//
//   factory Rating.fromJson(Map<String, dynamic> json) => Rating(
//     id: json["id"],
//     userId: json["user_id"],
//     productId: json["product_id"],
//     review: json["review"],
//     rating: json["rating"],
//     reviewDate: DateTime.parse(json["review_date"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_id": userId,
//     "product_id": productId,
//     "review": review,
//     "rating": rating,
//     "review_date": reviewDate.toIso8601String(),
//   };
// }
