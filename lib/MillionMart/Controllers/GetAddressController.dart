import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:get/get.dart';

var getAddress = [].obs;
var isLoadingAddress = true.obs;

Future<void> getAddressController(String _id) async {
  print("Address get Id is :"+_id);
  var url = Constants.baseUrl;
  final response = await http.post(Uri.parse(url + '/address'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"user_id": _id}));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    isLoadingAddress.value = false;
    print("Api data is :" + data.toString());
    getAddress.value = data[0];
    // print(getAddress[0]["city"]);
  } else {
    isLoadingAddress.value = false;
    Exception("Api Not Hit");
    print(response.body);
    throw ('Api Not Hit');
  }
}
