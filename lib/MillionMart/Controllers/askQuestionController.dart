import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AskQuestions extends GetxController{

  TextEditingController questionController = TextEditingController();
  bool isLoading = true;

  var uId;
  var pId;

  @override
  void onInit() {
    print("Check Arrgument ${Get.arguments}");
    if(Get.arguments != null)
      {
        pId = Get.arguments;
      }
    super.onInit();
  }

  @override
  void onReady() async {
    final SharedPreferences getUid = await Constants.prefs;
    uId =getUid.getString('id')!;
    print("Check id $uId");
    isLoading = false;
    update();
    super.onReady();
  }


  void askQuestion() async {

    print("inside api" + pId.toString() +"  UID "+ pId.toString());
    var url = Constants.baseUrl;
    final response = await http.post(
      Uri.parse(url + '/ask-question'),
      body: {
        "user_id": uId,
        "product_id": pId,
        "question": questionController.text
      },
    );
    print("api is called");
    if (response.statusCode == 200) {
      if (response.body.contains('Question Added')) {
        Get.back();
        Get.snackbar("success".tr, "askQuesSuccess".tr,backgroundColor: notificationBackground,colorText: notificationTextColor,);
      } else {
        var data = jsonDecode(response.body);
        Get.snackbar("error".tr, "try_again".tr,backgroundColor: notificationBackground,colorText: notificationTextColor,);
        print("Api reponse else " + data.toString());
      }
    } else {
      throw ("Api not hit");
    }
  }
}