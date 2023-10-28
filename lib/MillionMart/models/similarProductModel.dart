// To parse required this JSON data, do
//
//     final similarProductsModel = similarProductsModelFromJson(jsonString);

import 'dart:convert';

List<SimilarProductsModel> similarProductsModelFromJson(String str) =>
    List<SimilarProductsModel>.from(
        json.decode(str).map((x) => SimilarProductsModel.fromJson(x)));

String similarProductsModelToJson(List<SimilarProductsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SimilarProductsModel {
  SimilarProductsModel({
    required this.id,
    required this.sku,
    required this.productType,
    required this.affiliateLink,
    required this.userId,
    required this.categoryId,
    required this.subcategoryId,
    required this.childcategoryId,
    required this.attributes,
    required this.name,
    required this.slug,
    required this.photo,
    required this.thumbnail,
    required this.file,
    required this.size,
    required this.sizeQty,
    required this.sizePrice,
    required this.color,
    required this.price,
    required this.previousPrice,
    required this.details,
    required this.stock,
    required this.policy,
    required this.status,
    required this.views,
    required this.tags,
    required this.features,
    required this.colors,
    required this.productCondition,
    required this.ship,
    required this.isMeta,
    required this.metaTag,
    required this.metaDescription,
    required this.youtube,
    required this.type,
    required this.license,
    required this.licenseQty,
    required this.link,
    required this.platform,
    required this.region,
    required this.licenceType,
    required this.measure,
    required this.featured,
    required this.best,
    required this.top,
    required this.hot,
    required this.latest,
    required this.big,
    required this.trending,
    required this.sale,
    required this.createdAt,
    required this.updatedAt,
    required this.isDiscount,
    required this.discountDate,
    required this.wholeSellQty,
    required this.wholeSellDiscount,
    required this.isCatalog,
    required this.catalogId,
    required this.ratings,
  });

  int id;
  String sku;
  String productType;
  dynamic affiliateLink;
  int userId;
  int categoryId;
  int subcategoryId;
  dynamic childcategoryId;
  dynamic attributes;
  String name;
  String slug;
  String photo;
  String thumbnail;
  dynamic file;
  dynamic size;
  dynamic sizeQty;
  dynamic sizePrice;
  List<String> color;
  int price;
  int previousPrice;
  String details;
  dynamic stock;
  String policy;
  int status;
  int views;
  List<String> tags;
  String features;
  String colors;
  int productCondition;
  String ship;
  int isMeta;
  List<String> metaTag;
  String metaDescription;
  String youtube;
  String type;
  String license;
  String licenseQty;
  dynamic link;
  dynamic platform;
  dynamic region;
  dynamic licenceType;
  dynamic measure;
  int featured;
  int best;
  int top;
  int hot;
  int latest;
  int big;
  int trending;
  int sale;
  DateTime createdAt;
  DateTime updatedAt;
  int isDiscount;
  dynamic discountDate;
  List<String> wholeSellQty;
  List<String> wholeSellDiscount;
  int isCatalog;
  int catalogId;
  List<Rating> ratings;

  factory SimilarProductsModel.fromJson(Map<String, dynamic> json) =>
      SimilarProductsModel(
        id: json["id"],
        sku: json["sku"],
        productType: json["product_type"],
        affiliateLink: json["affiliate_link"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        childcategoryId: json["childcategory_id"],
        attributes: json["attributes"],
        name: json["name"],
        slug: json["slug"],
        photo: json["photo"],
        thumbnail: json["thumbnail"],
        file: json["file"],
        size: json["size"],
        sizeQty: json["size_qty"],
        sizePrice: json["size_price"],
        color: List<String>.from(json["color"].map((x) => x)),
        price: json["price"],
        previousPrice: json["previous_price"],
        details: json["details"],
        stock: json["stock"],
        policy: json["policy"],
        status: json["status"],
        views: json["views"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        features: json["features"],
        colors: json["colors"],
        productCondition: json["product_condition"],
        ship: json["ship"],
        isMeta: json["is_meta"],
        metaTag: List<String>.from(json["meta_tag"].map((x) => x)),
        metaDescription: json["meta_description"],
        youtube: json["youtube"],
        type: json["type"],
        license: json["license"],
        licenseQty: json["license_qty"],
        link: json["link"],
        platform: json["platform"],
        region: json["region"],
        licenceType: json["licence_type"],
        measure: json["measure"],
        featured: json["featured"],
        best: json["best"],
        top: json["top"],
        hot: json["hot"],
        latest: json["latest"],
        big: json["big"],
        trending: json["trending"],
        sale: json["sale"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isDiscount: json["is_discount"],
        discountDate: json["discount_date"],
        wholeSellQty: List<String>.from(json["whole_sell_qty"].map((x) => x)),
        wholeSellDiscount:
            List<String>.from(json["whole_sell_discount"].map((x) => x)),
        isCatalog: json["is_catalog"],
        catalogId: json["catalog_id"],
        ratings:
            List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "product_type": productType,
        "affiliate_link": affiliateLink,
        "user_id": userId,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "childcategory_id": childcategoryId,
        "attributes": attributes,
        "name": name,
        "slug": slug,
        "photo": photo,
        "thumbnail": thumbnail,
        "file": file,
        "size": size,
        "size_qty": sizeQty,
        "size_price": sizePrice,
        "color": List<dynamic>.from(color.map((x) => x)),
        "price": price,
        "previous_price": previousPrice,
        "details": details,
        "stock": stock,
        "policy": policy,
        "status": status,
        "views": views,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "features": features,
        "colors": colors,
        "product_condition": productCondition,
        "ship": ship,
        "is_meta": isMeta,
        "meta_tag": List<dynamic>.from(metaTag.map((x) => x)),
        "meta_description": metaDescription,
        "youtube": youtube,
        "type": type,
        "license": license,
        "license_qty": licenseQty,
        "link": link,
        "platform": platform,
        "region": region,
        "licence_type": licenceType,
        "measure": measure,
        "featured": featured,
        "best": best,
        "top": top,
        "hot": hot,
        "latest": latest,
        "big": big,
        "trending": trending,
        "sale": sale,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_discount": isDiscount,
        "discount_date": discountDate,
        "whole_sell_qty": List<dynamic>.from(wholeSellQty.map((x) => x)),
        "whole_sell_discount":
            List<dynamic>.from(wholeSellDiscount.map((x) => x)),
        "is_catalog": isCatalog,
        "catalog_id": catalogId,
        "ratings": List<dynamic>.from(ratings.map((x) => x.toJson())),
      };
}

class Rating {
  Rating({
    required this.id,
    required this.userId,
    required this.productId,
    required this.review,
    required this.rating,
    required this.reviewDate,
  });

  int id;
  int userId;
  int productId;
  String review;
  int rating;
  DateTime reviewDate;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        review: json["review"],
        rating: json["rating"],
        reviewDate: DateTime.parse(json["review_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "review": review,
        "rating": rating,
        "review_date": reviewDate.toIso8601String(),
      };
}
