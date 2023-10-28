import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';

class MillionMallController extends GetxController{

  var millionMallHomeBannersData =[].obs;
  var millionMallProducts = [].obs;

  var millionMallSlider = [].obs;

  var mmrRecievedProducts = 0.obs;
  var mmProductsInterval = 10.obs;

  var mmTotalProductsLimit = false.obs;
  var isLoadingMore = true.obs;

  var loadingData = false.obs;

  @override
  void onInit() {
    loadingData.value = false;
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async{
    super.onReady();
    print("Api is called Million Mall");
    millionMallHomeBannersData.value = await millionMallBanners();
    await millMallProductsData();
    await millionMallSliderAPi();
    print("Million Mall Slider Data : ${millionMallSlider.value}");
    print("Pro data of MM is :"+millionMallProducts.value.toString());
  }

  //Million Mall Sliders
  Future<void> millionMallSliderAPi() async {
    var url = Constants.baseUrl;
    try {
      final response = await http.get(Uri.parse(url + "/getmillionmallsliders"));
      print("API Slider res is "+response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("Slider Data is "+data["photo"]);
        millionMallSlider.add(data["photo"]);
        loadingData.value = true;
      }
    } catch (e) {
      throw Exception("Api not hit " + e.toString());
    }
  }

  //Million Mall Banners api
  Future<dynamic> millionMallBanners() async {
    var url = Constants.baseUrl;
    try {
      final response = await http.get(Uri.parse(url + "/getmillionmallbanners"));
      print("API RESPOnse is "+response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      }
      else{
        var data;
        return data;
      }
    } catch (e) {
      throw Exception("Api not hit " + e.toString());
    }
  }

  // Million Mall Products API
  Future<void> millMallProductsData() async {
    var url = Constants.baseUrl;
    try {
      final response = await http.post(Uri.parse(url + "/allmillionmall-product"),
      body: {
          "received_products":"$mmrRecievedProducts",
          "required_products":"$mmProductsInterval"
          });
      print("API RESPOnse is "+response.body.toString());

      if (response.statusCode == 200) {
        isLoadingMore.value = false;
        if(response.body.contains("sorry product is not found")){
          mmTotalProductsLimit.value = true;
          print("no more products" + mmTotalProductsLimit.value.toString());
        }
        else{
          var data = jsonDecode(response.body);
          millionMallProducts.addAll(data['products']);
          isLoadingMore.value = false;
        }

      }
    } catch (e) {
      isLoadingMore.value = false;
      throw Exception("Api not hit " + e.toString());
    }
  }
}


