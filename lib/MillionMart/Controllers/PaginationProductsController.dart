import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'dart:convert';
import 'package:get/state_manager.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PromoCodeController.dart';

class PaginationDataController extends GetxController {
  var isLoading = true.obs;
  var isLoadingScroll = true.obs;
  var productList = [].obs;
  var totalProductsLimit = false.obs;

  RxString promoCode = ''.obs;

  // var loadingIcon = 1.obs;

  var recievedProducts = 0.obs;
  var productsInterval = loadMoreSize.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    this.recievedProducts.value = 0;
    super.onReady();
  }

  @override
  void onInit() async {
    super.onInit();
    await paginationProductsAPi();
  }

  @override
  void dispose() {
    // called just before the Controller is deleted from memory
    super.dispose();
  }

  Future<void> paginationProductsAPi() async {
    productList.clear();
    var url = Constants.baseUrl;
    print("base url in pagination page is "+url.toString());
    final response = await http.post(Uri.parse(url + '/allproduct'), body: {
      "received_products": "$recievedProducts",
      "required_products": "$productsInterval"
    });
    print("+++++++++");
    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      isLoading.value = false;
      isLoadingScroll.value = false;
      if (response.body.contains("sorry product is not found")) {
        totalProductsLimit.value = true;
        print("no more products" + totalProductsLimit.value.toString());
      } else {
        print("Check Data is here $result");
        productList.addAll(result['products']);
        isLoading.value = false;
        isLoadingScroll.value = false;
        // .value = result['totalProducts'];
        print("Image Id");
      }
    } else {
      // Exception("Api Not Hit");
      print(response.body);
      isLoadingScroll.value = false;
      isLoading.value = false;
      throw ('Api Not Hit');
    }
  }

  Future<void> getFirstOrderDiscount() async {
    var url = Constants.baseUrl;
    print("First order api url"+url.toString());
    final response = await http.get(Uri.parse(url + '/gefirstordercoupon'));
    print("First order response is"+response.statusCode.toString());
    if (response.statusCode == 200) {
      print("First order response");
      print(response.body);
      var data = jsonDecode(response.body);
      promoCode.value = data["code"];
    }
  }
}
