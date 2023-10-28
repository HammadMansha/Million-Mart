import 'dart:convert';

import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:http/http.dart' as http;


class Contactus extends GetxController{

  static var client = http.Client();

  String email = "";
  String no = "";

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady()async {
    await getContactusData();
    super.onReady();
  }

  Future<void> getContactusData() async {
    var url = Constants.baseUrl;
    var response = await client.get(Uri.parse(url + '/get-contact-detail'));
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      print("Contact us Response ${response.body}");

      email = res[0]['Email'];
      no = res[0]['Contact Number'];

      update();
      print(email);
    }
  }


}