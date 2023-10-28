import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/models/SignInModelClass.dart';
import 'package:get/get.dart';

var isSigning = false.obs;

Future signInController(SignIn _signIn) async {
  var url = Constants.baseUrl;
  final response = await http.post(Uri.parse(url + '/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(_signIn.toJson()));
  if (response.body.contains('Error')) {
    isSigning.value = true;
    // Get.back();
    print('errrooooooorrr');
    var data = json.decode(response.body);
    print('dattaa.....${data.toString()}');
    return 'null';
  } else {
    print('successsfulllll');
    isSigning.value = true;
    Get.back();
    var data = json.decode(response.body);
    print('dattaaaa......${data.toString()}');
    return data;
  }
}
