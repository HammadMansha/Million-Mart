import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/GetAddressController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';
import 'package:millionmart_cleaned/MillionMart/models/AddAddressModelClass.dart';

var addressAdded = [].obs;
Future<void> addAddressController(AddAddress _addAddress) async {

  print('Address ${_addAddress.toJson()}');

  final HomeController homeController = Get.find<HomeController>();
  var url = Constants.baseUrl;
  final response = await http.post(Uri.parse(url + '/multiaddress'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(_addAddress.toJson()));
  if (response.statusCode == 200) {
    // addressAdded.value = jsonDecode(response.body);
    if (response.body.contains('success')) {
      getAddressController(homeController.userId.toString());
      Get.back();
      Get.snackbar(
        "success".tr,
        "addSuccessfully".tr,
        backgroundColor: notificationBackground,
        colorText: notificationTextColor,
      );
    } else {
      Get.snackbar(
        "error".tr,
        "try_again".tr,
        backgroundColor: notificationBackground,
        colorText: notificationTextColor,
      );
    }
    print(response.body);
    // return Signup.fromJson(jsonDecode(response.body));
  } else {
    print(response.body);
    throw Exception('Failed to save Data.');
  }
}
