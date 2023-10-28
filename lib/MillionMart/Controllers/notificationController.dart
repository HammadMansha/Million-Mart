
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartHome.dart';

class NotificationController extends GetxController {
  bool isLoading = true;

  List notificationlist = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    await getNotification();
    isLoading = false;
    update();
    super.onReady();
  }

  Future<void> getNotification() async
  {
    notificationlist.clear();
    var url = Constants.baseUrl;
    var response =await http.get(Uri.parse(url + '/annoucements'));
    var data = json.decode(response.body);
    notificationlist.addAll(data);
    update();
    print(response.body);
  }

  Future<bool> onWillPop(context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MillionMartHome(),
      ),
    );
    return true;
  }

}
