import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/services/voiceSearchService.dart';

class VoiceSearchController extends GetxController{
  // VoiceSearchController(this.slug);
  var isLoading = true.obs;
  // var data = [].obs;
  var productList = [].obs;
  var keyword = "";
  // String slug;
  // var slg =''.obs;


  @override
  void onInit() {
    super.onInit();
    // SearchProducts();
    // fetchProducts();
  }
  @override
  void onClose(){
    super.dispose();
  }

  static var client = http.Client();
  Future<void> fetchProducts(var pName) async {
    try {
      isLoading(true);
      productList.clear();
      var products = jsonDecode(await VoiceSearchServices.fetchProducts(pName));
      print("response from search controller..."+ products.toString());
      if (products != null) {
        productList.value = products;
        print("Api reponse" + productList.value.toString());
        isLoading(false);
      }
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchFilteredProducts(String min, String max) async {
    print("paramerter are :"+min +max +keyword );
    try {
      isLoading(true);
      productList.clear();
      var url = Constants.baseUrl;
      final response = await http.post(Uri.parse(url + '/filterProduct'),
          // headers: <String, String>{
          //   'Content-Type': 'application/json; charset=UTF-8',
          // },
          body:{
            "min":"${min}",
            "max":"${max}",
            "keyword":keyword.toString()
          });
      if (response.statusCode == 200) {
        var _data = jsonDecode(response.body);
        var data = [];
        data.add(_data);
        print("Filtered Data is : "+data.toString());
        productList.value =  data;
        keyword = "";
        }
      else {
        print(response.body);
        throw Exception('Failed to save Data.');
      }
    } finally {
      isLoading(false);
      // productList.clear();
    }
  }
}
