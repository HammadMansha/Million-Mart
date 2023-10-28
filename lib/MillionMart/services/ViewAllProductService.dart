import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';

class ViewAllProductsService {

  static var client = http.Client();
  static String apis = Constants.viewAllAPI[Constants.apiIndex];


  static Future<dynamic> fetchAllProducts() async {
    print("0000000000000000");
    var response = await client.get(Uri.parse("http://192.168.100.225/final/api/allproduct"));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print("Service Class All Pro Data" +jsonString.toString());
      return jsonString;
    } else {
      print(Constants.viewAllAPI[Constants.apiIndex]);
      print("status Code: ");
      print(response.statusCode);
      // print('response from serviceClass ${jsonString.toString()}');
      //show error message
      return null;
    }
  }
}
