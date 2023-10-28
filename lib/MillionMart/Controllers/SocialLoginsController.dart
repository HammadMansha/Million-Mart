import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/SignInController.dart';
import 'package:millionmart_cleaned/MillionMart/models/SocialLoginsModelClass.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

var socialLogin = false.obs;

Future socialLoginsController(SocialLogins? _socialLogins) async {
  isSigning.value = false;
  var url = Constants.baseUrl;
  final response = await http.post(Uri.parse(url + '/sociallogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(_socialLogins!.toJson()));
  if (response.statusCode == 200) {
    if (response.body.contains('Error')) {
      isSigning.value = true;
      socialLogin.value = false;
      print('Error');
      var data = json.decode(response.body);
      print('data.....${data.toString()}');
      Get.snackbar("error".tr, "try_again".tr,backgroundColor: notificationBackground,
        colorText: notificationTextColor,);
      // return 'null';
    } else {
      isSigning.value = true;
      socialLogin.value = true;
      final SharedPreferences _prefs = await Constants.prefs;
      print('successfully');
      var data = json.decode(response.body);
      print('user id of social Login is......${data[0][0]['id'].toString()}');
      _prefs.setString('id', data[0][0]['id'].toString());

      // return data;
    }
  } else {
    isSigning.value = true;
    throw ("Error Occur Api don't Hit");
  }
}
