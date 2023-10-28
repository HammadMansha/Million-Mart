// To parse this JSON data, do
//
//     final ordersData = ordersDataFromJson(jsonString);

import 'dart:convert';

List<OrdersData> ordersDataFromJson(String str) => List<OrdersData>.from(json.decode(str).map((x) => OrdersData.fromJson(x)));

String ordersDataToJson(List<OrdersData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrdersData {
  OrdersData({
    this.id,
    this.orderNumber,
    this.status,
    this.createdAt,
    this.currencySign,
    this.payAmount,
  });

  int? id;
  String? orderNumber;
  String? status;
  DateTime? createdAt;
  String? currencySign;
  int? payAmount;

  factory OrdersData.fromJson(Map<String, dynamic> json) => OrdersData(
    id: json["id"],
    orderNumber: json["order_number"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    currencySign: json["currency_sign"],
    payAmount: json["pay_amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_number": orderNumber,
    "status": status,
    "created_at": createdAt!.toIso8601String(),
    "currency_sign": currencySign,
    "pay_amount": payAmount,
  };
}
