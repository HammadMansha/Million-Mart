// To parse this JSON data, do
//
//     final paginationProducts = paginationProductsFromJson(jsonString);

import 'dart:convert';

PaginationProducts paginationProductsFromJson(String str) => PaginationProducts.fromJson(json.decode(str));

String paginationProductsToJson(PaginationProducts data) => json.encode(data.toJson());

class PaginationProducts {
  PaginationProducts({
    required this.id,
    this.sku,
    required this.productType,
    this.affiliateLink,
    required this.userId,
    required this.categoryId,
    this.subcategoryId,
    this.childcategoryId,
    this.attributes,
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
    this.stock,
    required this.policy,
    required this.status,
    required this.views,
    required this.tags,
    required this.features,
    required this.colors,
    required this.productCondition,
    this.ship,
    required this.isMeta,
    required this.metaTag,
    required this.metaDescription,
    required this.youtube,
    required this.type,
    required this.license,
    required this.licenseQty,
    this.link,
    this.platform,
    this.region,
    this.licenceType,
    this.measure,
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
    this.discountDate,
    required this.wholeSellQty,
    required this.wholeSellDiscount,
    required this.isCatalog,
    required this.catalogId,
  });

  int id;
  dynamic sku;
  String productType;
  dynamic affiliateLink;
  int userId;
  int categoryId;
  dynamic subcategoryId;
  dynamic childcategoryId;
  dynamic attributes;
  String name;
  String slug;
  String photo;
  String thumbnail;
  String file;
  String size;
  String sizeQty;
  String sizePrice;
  String color;
  double price;
  double previousPrice;
  String details;
  dynamic stock;
  String policy;
  int status;
  int views;
  List<String> tags;
  String features;
  String colors;
  int productCondition;
  dynamic ship;
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
  String wholeSellQty;
  String wholeSellDiscount;
  int isCatalog;
  int catalogId;

  factory PaginationProducts.fromJson(Map<String, dynamic> json) => PaginationProducts(
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
    color: json["color"],
    price: json["price"].toDouble(),
    previousPrice: json["previous_price"].toDouble(),
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
    wholeSellQty: json["whole_sell_qty"],
    wholeSellDiscount: json["whole_sell_discount"],
    isCatalog: json["is_catalog"],
    catalogId: json["catalog_id"],
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
    "color": color,
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
    "whole_sell_qty": wholeSellQty,
    "whole_sell_discount": wholeSellDiscount,
    "is_catalog": isCatalog,
    "catalog_id": catalogId,
  };
}
