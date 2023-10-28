import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';


class PlaceHolderController extends GetxController {

  // ProductController(this.slug);
  var isLoading = true.obs;
  var data = [].obs;
  var productList = [].obs;
  // final String  slug;
  var slg =''.obs;


  @override
  void onInit() {

    super.onInit();
    PlaceHolderData();
  }

  static var client = http.Client();
  var url = Constants.baseUrl;


  @override
  void dispose() { // called just before the Controller is deleted from memory
    super.dispose();
  }

  PlaceHolderData() async {
    print('url $url');
    productList.clear();
    http.Response response =
    await http.get(Uri.parse(url + '/placeholder'));
    print('PLaceHolders Data ${response.body}');
    var data = json.decode(response.body);
    productList.value = data;
    update();
  }

}