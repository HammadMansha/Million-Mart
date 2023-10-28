import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/cartController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartChatScreen.dart';
import 'package:millionmart_cleaned/MillionMart/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  static var client = http.Client();
  ProductController(this.slug, this.id);

  var isLoading = true.obs;
  var proImgList = <String>[].obs;
  var productList = [].obs;
  var categoryId = "0".obs;
  var similarProductsLoading = true.obs;

  final DatabaseHelper dbcartmanager = new DatabaseHelper();
  final DatabaseHelper dbCompManager = new DatabaseHelper();

  final firebaseusers = FirebaseFirestore.instance.collection("users");

  late ChoiceChip choiceChip;
  int selVarient = 0, oldSelVarient = 0;
  int offset = 0;
  int total = 0;
  bool isLoadingmore = true;
  bool animate = false;

  ScrollController controller = new ScrollController();
  bool isCommentEnable = false;
  TextEditingController commentC = new TextEditingController();
  double initialRate = 0;
  late String pName, pImage, pPrice, pRating;
  var test;
  var respons;
  var current = 0.obs;
  var isFavorite = false.obs;

  // SimilarProductController? similarProductController;
  late Timer timer;
  bool flag = true;
  var id;

  TextEditingController url = TextEditingController();
  TextEditingController price = TextEditingController();
  var productData;

  late CartController cartController;

  var similerProductList = [].obs;
  //Reviews List
  var reviewsData = [].obs;

  var getQuesAns = [].obs;

  String slug;

  String userId = "";
  String username = "";

  List reviewList = [
    {""}
  ];

  @override
  void onInit() async {
    if (Get.isRegistered<CartController>()) {
      cartController = Get.find<CartController>();
    } else {
      cartController = Get.put(CartController());
    }
    final SharedPreferences getUid = await Constants.prefs;
    if (getUid.getString('id') != null) {
      userId = getUid.getString('id')!;
      username = getUid.getString('name')!;
    }

    await fetchProducts();
    // await checkFavorite(Constants.userID!,id);
    await cartController.getCompCount();
    cartController.cartCoount();
    userId.isEmpty && userId == ""
        ? userId = ""
        : await checkFavorite(id, userId);
    print("User Id is :" + userId);
    await getReviews();
    await getQuesAnswers();
    Future.delayed(
      Duration(seconds: 1),
        ()async{
          similarProductsLoading.value = true;
          print("Cate Id  is :"+categoryId.toString());
          await similarProductData();
        }

    );
    // if(categoryId.contains("0")){
    //   print("Cate Id  is :"+categoryId.toString());
    //
    // }
    // else{
    //   print("Cate Id  is else :"+categoryId.toString());
    // }
    isLoading = false.obs;
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await userData();
    print("USer data is :" + Constants.userID.toString());
    // print("Api is called");
  }

  Future<void> fetchProducts() async {
    // isLoading(true);
    var url = Constants.baseUrl;
    var response = await client.get(Uri.parse(url + '/productdetails/' + slug));
    if (response.statusCode == 200) {
      print('Product data before decode: ${response.body}');
      var productData = json.decode(response.body);
      // print('Product data after decode: $productData');
      productList.value = productData;
      categoryId.value = productData[0]["category_id"].toString();
      print("categoryId is :"+categoryId.toString());
      proImgList.add(productData[0]["photo"].toString());
      for (int i = 0; i < productData[0]['galleries'].length; i++) {
        proImgList.add(productData[0]['galleries'][i]["photo"].toString());
      }
      // isLoading(false);
    } else {
      // isLoading(false);
      print('null');
    }
  }

  Future<void> getReviews() async {
    // isLoading(true);
    var url = Constants.baseUrl;
    var response = await client
        .get(Uri.parse(url + '/getproductreveiws/' + id.toString()));
    if (response.statusCode == 200) {
      // print('Product data before decode: ${response.body}');
      var reviewtData = json.decode(response.body);
      reviewsData.value = reviewtData;
      print("Reviews Data is : " + reviewsData.toString());
      // isLoading(false);
    } else {
      // isLoading(false);
      print(response.body);
      throw Exception("Api not called");
    }
  }

  Future<void> getQuesAnswers() async {
    // isLoading(true);
    var url = Constants.baseUrl;
    print("product id for question $id");
    int i = int.parse(id);
    var response =
        await client.get(Uri.parse(url + '/get-questions/' + i.toString()));
    if (response.statusCode == 200) {
      // print('Product data before decode: ${response.body}');
      var data = json.decode(response.body);
      print("Questions and answers are : "+response.body.toString());
      print('Data length is ${data.length}');
      if(data.length == 0){
        isLoading(false);
        print("No data for question answers");
      }
      else{
        var _data = [];
        for(var a in data[0]){
          print("question ans data is "+a.toString());
          if(a["answer"] != null)
          {
            _data.add(a);
          }
          else if(a["question"] != null)
            {
              _data.add(a);
            }
          else{
            print("question ans data is anser "+a['answer'].toString());
          }
        }
        print("Questions with ansers are : "+_data.toString());
        getQuesAns.value = _data;
        print("QuesAnswer Data is : " + getQuesAns.toString());
        // print('Product data after decode: $productData');
        isLoading(false);
      }

      // reviewsModelClassFromJson(response.body);
    } else {
      isLoading(false);
      print(response.body);
      throw Exception("Api not called");
    }
  }

  Future<void> similarProductData() async {
    print("Product Id $categoryId");
    int i = int.parse(categoryId.value);
    var url = Constants.baseUrl;
    http.Response response =
        await http.get(Uri.parse(url + '/smillerproduct/$i'));
    print('response from similar Product Controller....' + response.body);
    var data = json.decode(response.body);
    similerProductList.value = data;
    similarProductsLoading.value = false;
    update();
  }

  Future<void> checkFavorite(String pId, String? uID) async {
    print("inside api" + pId.toString());
    print("inside api uid" + uID.toString());
    var url = Constants.baseUrl;
    final response = await http.post(
      Uri.parse(url + '/check-wishlist'),
      body: {"user_id": uID, "product_id": pId},
    );
    print("api is called");
    if (response.statusCode == 200) {
      if (response.body.contains('True')) {
        isFavorite.value = true;
        print("response of api " + response.body);
      } else {
        isFavorite.value = false;
        var data = jsonDecode(response.body);
        print("Api reponse else " + data.toString());
      }
    } else {
      throw ("Api not hit");
    }
  }

  addToCartWeb(
      String id,
      String qty,
      String size,
      String size_qty,
      String size_price,
      String size_key,
      String keys,
      String values,
      String prices) async {
    const chars =
        'eyJpdiI6IlFnQ0pCNnFITzM3RXMrYndhaU5TTVE9PSIsInZhbHVlIjoiUm42ZHZoTGg3Z1M2SmNDU1ErcXZqOCtVd29BcTBFQk0rNndXajFYUEFxeENpTlhvNUl4dU90SXRkL0lWQjM0eEFMTmhDOTNFU0pXbGt3d1FFRm9YOExJdUUxZHFFRGtZMFJmWXk1YStnYllNZ3dhZHdCWGh1aDJkNkcrOXNYbjciLCJtYWMiOiIyYWQwYjY2YzEyNDdmNmUyYmQwMDA0ZWQ5Y2E5OWRmMjA0ODE5ZmViMzlhNzA5MGZkNDBjYTEzNmJhMTMyNTM3In0%3D';
    Random rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    print("random string ${getRandomString(100)}");

    print("Add to cart web");
    // var priceMap = {"0": "$prices"};
    var url = Constants.baseUrl;
    Map body = {
      "id": id,
      "qty": qty,
      "size": size,
      "size_qty": size_qty,
      "size_price": size_price,
      "size_key": size_key,
      "keys": keys,
      "values": values,
      "prices[]": prices,
    };
    final response = await http.post(
      Uri.parse(url + '/addToCartMobile'),
      body: jsonEncode(body),
      headers: {
        // 'Cookie': 'laravel_session=${getRandomString(330)}',
        // 'set-cookie' : 'XSRF-TOKEN=${getRandomString(330)}'
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        // "HTTP_COOKIE": "laravel_session=${getRandomString(330)}"
      },
    );

    print("Add to cart web response: ${response.body}");
  }

  Future<void> addUser() async {
    var checkData =
        await firebaseusers.where("user_id", isEqualTo: userId).get();
    if (checkData.docs.length == 0) {
      firebaseusers.add({
        "user_id": userId,
        "photo": "https://cdn-icons-png.flaticon.com/512/21/21104.png",
        "name": username,
      }).then((value) {
        Get.to(() => ChatScreen());
      });
    } else {
      Get.to(() => ChatScreen());
    }
  }
}
