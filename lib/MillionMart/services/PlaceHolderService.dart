import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/models/PlaceHolderModel.dart';

class PlaceHolderServices {
  // final String slug;
  // RemoteServices(this.slug);
  static var client = http.Client();
  static var url = Constants.baseUrl;
  // var jsonString;
  static Future<List<PlaceholderModel>?> fetchProducts() async {
    var response = await client.get(Uri.parse(url + '/api/placeholder'));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print('response from PlaceHolder Service Class ${jsonString.toString()}');
      return placeholderModelFromJson(jsonString);
    } else {
      // print('response from serviceClass ${jsonString.toString()}');
      //show error message
      return null;
    }
  }
}
