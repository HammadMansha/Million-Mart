import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/VoiceSearchController.dart';
// import 'package:millionmart/FullApp/MillionMart%20App/ModelClasses/productDetailModel.dart';

class VoiceSearchServices {
  // var url = Constants.baseUrl;

  static var client = http.Client();
  static var url = Constants.baseUrl;
  // var jsonString;
  static Future fetchProducts(var pName) async {
    print('Keyword inside service class :' + pName);
    var url = Constants.baseUrl;
    var response = await client.get(Uri.parse(url + '/search/$pName'));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print('Voice Search Result ${jsonString.toString()}');
      return jsonString;
    } else {
      print("Api not Hit" + response.statusCode.toString());
      print(response.statusCode);
      Get.find<VoiceSearchController>().isLoading(false);
      //show error message
      // return homeSectiontModelFromJson('');
    }
  }
}
