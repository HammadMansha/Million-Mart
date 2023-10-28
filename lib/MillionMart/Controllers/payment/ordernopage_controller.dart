import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:encrypt/encrypt.dart'
as EncryptPack;
import 'package:crypto/crypto.dart'
as CryptoPack;
import 'dart:convert'
as ConvertPack;

class OrderNoController extends GetxController {
  bool isLoading = true;

  TextEditingController no = TextEditingController(text: "111");

  String hashkey = "";
  int n = 0;

  var mapdata;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady()async {
    await check1stStep();
    isLoading = false;
    update();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> check1stStep() async {
    print("checj");
    var data = await http.post(Uri.parse("http://192.168.100.203/mm/check.php"));

    var res = json.decode(data.body);
    // Get.log(res);
    print(res);
    mapdata = res;
    update();

    // await checkData(hashkey);

    await checkData();

  }

  Future<void> checkData() async
  {
    var data = await http.post(Uri.parse("https://sandbox.bankalfalah.com/SSO/SSO/SSO"),
    body: {
      "AuthToken" : "${mapdata['Auth']['AuthToken']}",
      "RequestHash" : "${mapdata['hashRequest']}",
      "ChannelId" : "1001",
      "Currency" : "PKR",
      "IsBIN" : "0",
      "ReturnURL" : "http://192.168.100.187/million_final_code/checkout/payment/return",
      "MerchantId" : "9728",
      "StoreId" : "017342",
      "MerchantHash" : "zWsOsg0VNuBwmQH5oZC9rh3mM5b4chnMUbQ8aTqX5wOjyyOeZnrlG6G6gD3nSe5oa4M2JmBb/P3IXb4twlGH8tWMxWbBU4A7",
      "MerchantUsername" : "exigam",
      "MerchantPassword" : "lf2M9I11h8JvFzk4yqF7CA==",
      "TransactionTypeId" : "3",
      "TransactionReferenceNumber" : "456",
      "TransactionAmount" : "342"
    });
    var r = json.decode(data.body);
    print(r);

  }




}


