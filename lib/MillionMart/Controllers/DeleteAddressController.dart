import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/GetAddressController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';

Future deleteAddressController(String iD) async {
  final HomeController homeController = Get.find<HomeController>();
  var url = Constants.baseUrl;
  final response = await http.post(Uri.parse(url + '/deleteaddress'),
      body: {
    "id": iD
  });
  if (response.statusCode == 200) {
    print("Api response " + response.body.toString());
    getAddressController(homeController.userId.toString());
    Get.back();
  } else {
    print(response.body);
    throw Exception('Failed to delete Data.');
  }
}
