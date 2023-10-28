import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartChatScreen.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/cartController.dart';
import 'package:millionmart_cleaned/MillionMart/database/database.dart';

class HomeController extends GetxController {
  final images = [].obs;
  var isLoading = true.obs;
  var productList = [].obs;
  var slug = ''.obs;

  String userId = "";
  String username = "";

  final firebaseusers = FirebaseFirestore.instance.collection("users");

  bool ischeck = false;

  List productslist = [];

  final DatabaseHelper dBcartManager = new DatabaseHelper();
  CartController _productCount = Get.put(CartController());

  // GetStorage box = GetStorage('check');


  // var url = Constants.baseUrl;

  // var productDetail;

  Future<void> carouselController() async {
    print("Carousel controller called");
    var url = Constants.baseUrl;
    http.Response response = await http.get(Uri.parse(url + '/getslider'));

    // if(response.statusCode==200){
    // print("Carousal Data ${response.body}");
    var data = json.decode(response.body);
    images.value = data;
    // }
  }

  Future <void> fetchProducts() async {
    print("fetch home sec");
    try {
      isLoading(true);
      var url = Constants.baseUrl;
      var response = await http.get(Uri.parse(url + '/homesection'));
      if (response.statusCode == 200) {
        var products = jsonDecode(response.body);
        productslist.add(products);
        productList.value = products;
        print("data Home "+products.toString());
        isLoading(false);
      }
      else {
        isLoading(false);
      }
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
  }


  @override
  void onReady() async {
    await getCartCount();
    await carouselController();
    await fetchProducts();
    await checkLogin();
    super.onReady();
  }

  Future<void> checkLogin() async {
    Constants.prefs.then((value) {
      if (value.getBool('loggedIn') != null) {
        ischeck = value.getBool('loggedIn')!;
        userId = value.getString('id')!;
        username = value.getString('name')!;
        update();
        print("Check Login Data $ischeck");
      }
    });
  }

  Future<void> addUser() async
  {
    var checkData = await firebaseusers.where("user_id", isEqualTo: userId)
        .get();
    if (checkData.docs.length == 0) {
      firebaseusers.add({
        "user_id": userId,
        "photo": "https://cdn-icons-png.flaticon.com/512/21/21104.png",
        "name": username,
      }).then((value) {
        Get.to(() => ChatScreen());
      });
    }
    else {
      Get.to(() => ChatScreen());
    }


  }
  getCartCount() async {
    _productCount.cartCoount.value = await dBcartManager.getCartData();
    print("Cart Items in DB (Count) :  " +
        _productCount.cartCoount.length.toString());
  }
}
