import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/models/SignUpModelClass.dart';

Future signUpController(Signup _signUp) async {
  var url = Constants.baseUrl;
  final response = await http.post(Uri.parse(url + '/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(_signUp.toJson()));
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    if (response.body.contains('already')) {
      Get.snackbar(
        "error".tr,
        "alreadySignUp".tr,
        backgroundColor: notificationBackground,
        colorText: notificationTextColor,
      );
      return response.body;
    } else {
      Get.snackbar(
        "successSignUpTitle".tr,
        "successSignUpDes".tr,
        backgroundColor: notificationBackground,
        colorText: notificationTextColor,
      );
      Constants.signUpCheck.value = true;
      return response.body;
    }
    // print(response.body);
    // return Signup.fromJson(jsonDecode(response.body));
  } else {
    print(response.body);
    throw Exception('Failed to save Data.');
  }
}
