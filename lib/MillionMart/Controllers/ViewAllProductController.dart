import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/services/ViewAllProductService.dart';

class ViewAllProductController extends GetxController{
  // VoiceSearchController(this.slug);
  var isLoading = true.obs;
  var data = [].obs;
  var allProductList = [].obs;
  var index ;



  // String slug;
  // var slg =''.obs;

  @override
  void onInit() {
    super.onInit();
    // SearchProducts();
    // fetchProducts();
    print("Controller Call");
    fetchAllProducts();

  }
  @override
  void onClose(){
    super.dispose();

  }

  static var client = http.Client();
   Future<void> fetchAllProducts() async {
    try {
      // print('response from controller try');
      isLoading(true);
      var products = jsonDecode(await ViewAllProductsService.fetchAllProducts());
      if (products != null) {
        allProductList.value = products;
        print("Data all pro ${allProductList.value}");
        isLoading(false);
        // print("All Product Data "+products);
      }
      else
        print("No Data");
    } finally {
      isLoading(false);
    }
  }
}