
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
// import 'package:millionmart/FullApp/MillionMart%20App/ModelClasses/productDetailModel.dart';

class SimilarProductServices {

  static var client = http.Client();
  // var jsonString;
  static var url = Constants.baseUrl;
  // void  naveed(var id)async{
  //   if(id==null){
  //     id=5;
  //     print("your id is null");
  //   }
  //   print("Naveed how are you $id");
  //   var response = await client.get(Uri.parse(
  //       'http://192.168.0.169/millionmart/api/smillerproduct/$id'));
  //
  //   print("naveed====data====>${response.body}");
  // }
  fetchProducts(var id) async {
    var response = await client.get(Uri.parse(
        url+'/millionmart/api/smillerproduct/$id'));
      print("naveed is debuging====>$response");
      print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      print('response from similar products ${jsonString.toString()}');
      return jsonString;
    } else {
      // print('response from serviceClass ${jsonString.toString()}');
      //show error message
      return null;
    }
  }
}