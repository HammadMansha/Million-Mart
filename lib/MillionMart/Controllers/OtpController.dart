import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';

class OtpController extends GetxController{
 static Future sendOtp(String mobilenumber) async {
    var url = Constants.baseUrl;
    final response = await http.post(Uri.parse('${url}/otpcode'),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        // },
        body: {
          "phonenumber":mobilenumber
        });
    print("Api Res is: "+response.body);
    if(response.statusCode==200){
      print("OTP Success" +response.body);
    }
    if(response.body.contains('Error')){
      print('errrooooooorrr');
      var data = json.decode(response.body);
      print('dattaa.....${data.toString()}');
      return 'null';
    }else{
      Get.snackbar(
          "sent".tr,
          "otpDes".tr,
          backgroundColor: notificationBackground,
        colorText: notificationTextColor,);
      print('successsfulllll');
      var data = json.decode(response.body);
      print('dattaaaa......${data.toString()}');
      return data;
    }

  }
}