import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
// import 'package:millionmart/FullApp/MillionMart%20App/ModelClasses/productDetailModel.dart';

class HomePageDataServices {
  // var url = Constants.baseUrl;

  static var client = http.Client();
  // var jsonString;
  static Future<dynamic> fetchProducts() async {
    var url = Constants.baseUrl;
    var response = await client.get(Uri.parse(url + '/homesection'));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      // List data = jsonString.keys.toList();
      // print("Keys of API :" +data.toString());
      print('response from serviceClass ${jsonString.toString()}');
      return jsonString;
    } else {
      print(response.statusCode);
      //show error message
      var jsonString;
      return jsonString('');
    }
  }
}
