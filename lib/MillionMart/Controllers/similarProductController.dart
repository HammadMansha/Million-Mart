import 'dart:convert';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';

class SimilarProductController extends GetxController {

  SimilarProductController(this.id);
  var isLoading = true.obs;
  var data1 = [].obs;
  var productList = [].obs;
  final String  id;
  // var slg =''.obs;
  static var client = http.Client();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async{
    await similarProductData();
    isLoading.value = false;
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void dispose() { // called just before the Controller is deleted from memory
    super.dispose();
  }
  Future<void> similarProductData() async {
    var url = Constants.baseUrl;
    http.Response response =
    await http.get(Uri.parse(url + '/smillerproduct/$id'));
    print('response from similar Product Controller....'+response.body);
    var data = json.decode(response.body);
    productList.value = data;
    update();
  }
}