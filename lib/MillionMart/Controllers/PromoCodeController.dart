import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';

var res;
bool? errorCode;

Future<void> promoCodeController(String code) async {
  print("PromoCode is " + code);
  var url = Constants.baseUrl;
  // var body =
  final response = await http.post(Uri.parse(url + '/coupon'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"coupon": code}));
  print(response.body);

  if (response.statusCode == 200) {
    res = response.body;
  } else {
    print(response.body);
    throw Exception('Wrong Code.');
  }
}
