import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/productDetailController.dart';
import 'package:millionmart_cleaned/MillionMart/models/RequestBargainModelClass.dart';
import 'package:get/get.dart';

Future requestBargainController(RequestBargain _bargainData) async {
  var url = Constants.baseUrl;
  final response = await http.post(Uri.parse(url + '/bargain'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(_bargainData.toJson()));
  if (response.statusCode == 200) {
    if (response.body.contains('success')) {
      var data = json.decode(response.body);
      Get.back();
      Get.snackbar(
        "success".tr,
        "barDes".tr,
        backgroundColor: notificationBackground,
        colorText: notificationTextColor,
      );
      print('Bargain Result.....${data.toString()}');
    } else {
      Get.snackbar(
        "error".tr,
        "try_again".tr,
        backgroundColor: notificationBackground,
        colorText: notificationTextColor,
      );
      print("Something is Wrong");
      print(response.body);
    }
  } else {
    throw ("Error Occur");
  }
}
