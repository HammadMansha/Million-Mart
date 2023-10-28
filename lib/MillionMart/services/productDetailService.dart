import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/models/productDetailModel.dart';

class RemoteServices {
  // final String slug;
  // RemoteServices(this.slug);
  static var client = http.Client();
  static var url = Constants.baseUrl;
  // var jsonString;
  static Future<List<ProductDetailSectiontModel>?> fetchProducts(
      var slug) async {
    var response = await client
        .get(Uri.parse(url + '/millionmart/api/productdetails/$slug'));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(
          'response from serviceClass RemoteServices ${jsonString.toString()}');
      return productDetailSectiontModelFromJson(jsonString);
    } else {
      // print('response from serviceClass ${jsonString.toString()}');
      //show error message
      return null;
    }
  }
}
