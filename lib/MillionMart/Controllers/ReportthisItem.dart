import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';

Future reportItemController(String pTitle,String pId,String uID, String detail) async {
  var url = Constants.baseUrl;
  final response = await http.post(Uri.parse(url + '/report-product'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body:{
          "note": detail,
          "user_id": uID,
          "product_id": pId,
          "title": pTitle
      });
  if (response.statusCode == 200) {
    if (response.body.contains('Successfully')) {
      Get.back();
      Get.snackbar(
        "success".tr,
        "repDes".tr,
        backgroundColor: notificationBackground,
        colorText: notificationTextColor,
      );

      print("API reposonse is : "+response.body.toString());
      return response.body;
    } else {
      Get.snackbar(
        "error".tr,
        "try_again".tr,
        backgroundColor: notificationBackground,
        colorText: notificationTextColor,
      );
      print("Api error "+response.body.toString());
      return response.body;
    }
    // print(response.body);
    // return Signup.fromJson(jsonDecode(response.body));
  } else {
    print(response.body);
    throw Exception('Failed to save Data.');
  }
}
