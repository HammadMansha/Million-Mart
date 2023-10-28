import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cartController.dart';

class OrderHistoryController extends GetxController {
  static var client = http.Client();

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  int rating = 1;
  TextEditingController comment = TextEditingController();

  List itemlist = [];

  var orderno;
  String uID = "";

  List orderHistorydetail = [];
  List itemsOrder = [];

  @override
  void onInit() async {
    if (Get.arguments != null) {
      orderno = Get.arguments;
      await getOrderHistoryData(orderno.toString());
    }
    super.onInit();
  }

  @override
  void onReady() async {
    final SharedPreferences _prefs = await Constants.prefs;
    uID = _prefs.getString("id")!;
    super.onReady();
  }

  Future<void> getOrderHistoryData(String id) async {
    orderHistorydetail.clear();
    itemsOrder.clear();
    var url = Constants.baseUrl;
    var response = await client.get(Uri.parse(url + '/getorderdetail/$id'));
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      orderHistorydetail.add(res);
      update();
      getItems();
      log("Check Data ${response.body}");
    } else {
      print("Sorry No Data Found");
    }
  }

  void getItems() {
    for (int i = 0; i < orderHistorydetail.length; i++) {
      Get.log('Items is FUnction ${orderHistorydetail[i]['items']}');
      mapAdded(orderHistorydetail[i]['items']);
    }
  }

  void mapAdded(Map items) {
    items.forEach((key, value) {
      itemsOrder.add(value['item']);
      print('Map in Function $value');
    });
    String key = items.keys.elementAt(0).toString();
    // itemsOrder.add(items["$key"]['item']);
    update();
  }

  //< ------------------- Image Picker --------------->

  Future selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      print("Image File " +
          imageFile.toString() +
          "Runtime Type : " +
          imageFile.runtimeType.toString());
    }
  }

  Future selectVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      print("Image File " +
          imageFile.toString() +
          "Runtime Type : " +
          imageFile.runtimeType.toString());
    }
  }

  //Rate Item Api
  Future reviewItemApi(String reviewText, String pID, String rating) async {
    print("User Review & ID " + reviewText + pID + rating);
    if (imageFile != null) {
      var uri = Uri.parse(Constants.baseUrl + "/addproductreveiws");
      var request = http.MultipartRequest('POST', uri)
        ..fields['review'] = reviewText
        ..fields['product_id'] = pID
        ..fields['rating'] = rating
        ..fields['user_id'] = uID
        ..files
            .add(await http.MultipartFile.fromPath("image", imageFile!.path));

      var response = await request.send();
      final resBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        print('Uploaded!' + resBody.toString());
        Get.snackbar(
          "success".tr,
          "reqSucess".tr,
          backgroundColor: notificationBackground,
          colorText: notificationTextColor,
        );
      } else {
        Get.snackbar(
          "error".tr,
          "try_again".tr,
          backgroundColor: notificationBackground,
          colorText: notificationTextColor,
        );
        print(resBody);
        print(response.stream);
        throw Exception('Failed to save Data.');
      }
    } else {
      print(uID);
      var res = await http
          .post(Uri.parse(Constants.baseUrl + "/addproductreveiws"), body: {
        "user_id": uID,
        "product_id": pID,
        "review": reviewText,
        "rating": rating,
      });
      var resu = res.body;
      print(res.statusCode);
      if (res.statusCode == 201) {
        Get.snackbar(
          "success".tr,
          "reqSucess".tr,
          backgroundColor: notificationBackground,
          colorText: notificationTextColor,
        );
      } else {
        Get.snackbar(
          "error".tr,
          "try_again".tr,
          backgroundColor: notificationBackground,
          colorText: notificationTextColor,
        );
        throw Exception('Failed to save Data.');
      }
    }
  }

  final DatabaseHelper dbcartmanager = new DatabaseHelper();
  late CartController cartController;
  var productList = [].obs;

  Future<void> fetchProducts(String slug) async {
    print("1");

    // isLoading(true);
    var url = Constants.baseUrl;
    var response = await client.get(Uri.parse(url + '/productdetails/' + slug));
    if (response.statusCode == 200) {
      print('Product data before decode: ${response.body}');
      var productData = json.decode(response.body);
      // print('Product data after decode: $productData');
      productList.value = productData;

      // isLoading(false);
    } else {
      // isLoading(false);
      print('null');
    }
  }

  void addToCart(String slug) async {
    await fetchProducts(slug);
    var itemqty = 1;
    var item_size_key = productList[0]['size_key'].toString() == 'null'
        ? ''
        : productList[0]['size_key'];
    var item_size_price = productList[0]['size_price'];
    var itemsize = productList[0]['size'];
    var itemcolor = productList[0]['color'];
    var itemprice = productList[0]['price'];
    Cart cartItem;
    // var now = DateTime.now();
    //Maintaining the list start
    //size
    var size;
    productList[0]['size'].toString().isEmpty
        ? size = ""
        : size = productList[0]['size']
            .toString()
            .substring(1, productList[0]['size'].toString().length - 1);

    var sizesList = [];

    var splitSize = size.split(',');
    for (var a in splitSize) {
      String b = "$a";
      sizesList.add(b);
    }
    print(sizesList);

//size_qty
    var size_qty;
    productList[0]['size_qty'].toString().isEmpty
        ? size_qty = ""
        : size_qty = productList[0]['size_qty']
            .toString()
            .substring(1, productList[0]['size_qty'].toString().length - 1);
    var size_qtyList = [];
    var splitSizeQty = size_qty.split(',');
    for (var a in splitSizeQty) {
      String b = "$a";
      size_qtyList.add(b);
    }
    print(size_qtyList);

    //size_price
    var size_price;
    productList[0]['size_price'].toString().isEmpty
        ? size_price = ""
        : size_price = productList[0]['size_price']
            .toString()
            .substring(1, productList[0]['size_price'].toString().length - 1);
    var size_priceList = [];
    var splitSizePrice = size_price.split(',');
    for (var a in splitSizePrice) {
      String b = "$a";
      size_priceList.add(b);
    }
    print(size_priceList);

    //color
    var color;
    productList[0]['color'].toString().isEmpty
        ? color = ""
        : color = productList[0]['color']
            .toString()
            .substring(1, productList[0]['color'].toString().length - 1);

    var colorsList = [];
    var splitColor = color.split(',');
    for (var a in splitColor) {
      String b = "$a";
      colorsList.add(b);
    }
    print(colorsList);

    //whole_sell_qty
    var whole_sell_qty;
    productList[0]['whole_sell_qty'].toString().isEmpty
        ? whole_sell_qty = ""
        : whole_sell_qty = productList[0]['whole_sell_qty']
            .toString()
            .substring(
                1, productList[0]['whole_sell_qty'].toString().length - 1);
    var whole_sell_qtyList = [];
    var splitWholeSellQty = whole_sell_qty.split(',');
    for (var a in splitWholeSellQty) {
      String b = "$a";
      whole_sell_qtyList.add(b);
    }
    print(whole_sell_qtyList);

    //whole_sell_discount
    var whole_sell_discount;
    productList[0]['whole_sell_discount'].toString().isEmpty
        ? whole_sell_discount = ""
        : whole_sell_discount = productList[0]['whole_sell_discount']
            .toString()
            .substring(
                1, productList[0]['whole_sell_discount'].toString().length - 1);
    var whole_sell_discountList = [];
    var splitWholeSellDiscount = whole_sell_discount.split(',');
    for (var a in splitWholeSellDiscount) {
      String b = "$a";
      whole_sell_discountList.add(b);
    }
    print(whole_sell_discountList);
    //end maintaining

    var sizeList = [];
    sizeList.add(productList[0]['size']);

    cartItem = new Cart(
      name: productList[0]['name'].toString(),
      image: productList[0]['photo'].toString(),
      price: productList[0]['price'].toString().split('.')[0],
      previous_price: productList[0]['previous_price'].toString().split('.')[0],
      qty: 1,
      sub_total: productList[0]['price'].toString(),
      id: 0,
      color: productList[0]['color'].toString().isEmpty
          ? "FFFFFF"
          : productList[0]['color'][0],
      // item:
      //     '"${productList[0]['id']}":{"qty":$itemqty,"size_key":$item_size_key,"size_qty":"${productList[0]['size_qty']}","size_price":"$item_size_price","size":"$itemsize","color":"$itemcolor","stock":null,"price":$itemprice,"item":{"id":${productList[0]['id']},"user_id":${productList[0]['user_id']},"slug":"${productList[0]['slug']}","name":"${productList[0]['name']}","photo":"${productList[0]['photo']}","size":"${productList[0]['size']}","size_qty":"${productList[0]['size_qty']}","size_price":"${productList[0]['size_price']}","color":"${productList[0]['color']}","price":"${productList[0]['price']}","stock":null,"type":"${productList[0]['type']}","file":"${productList[0]['file']}","link":null,"license":"${productList[0]['license']}","license_qty":"${productList[0]['license_qty']}","measure":null,"whole_sell_qty":"${productList[0]['whole_sell_qty']}","whole_sell_discount":"${productList[0]['whole_sell_discount']}","attributes":null},"license":"","dp":"0","keys":"","values":"","item_price":${productList[0]['price']}}',
      size_key: 0,
      size_price: productList[0]['size_price'].toString(),
      size_qty: productList[0]['size_qty'].toString(),
      size: productList[0]['size'].toString(),
      stock: productList[0]['stock'].toString().isEmpty
          ? "null"
          : productList[0]['stock'].toString(),
      slug: productList[0]['slug'],
      key: productList[0]['id'].toString(),
      p_id: productList[0]['id'].toString(),
      p_user_id: productList[0]['user_id'].toString(),
      p_slug: productList[0]['slug'],
      p_name: productList[0]['name'],
      p_photo: productList[0]['photo'],
      p_size: sizeList.toString(),
      p_size_qty: size_qtyList.toString(),
      p_size_price: size_priceList.toString(),
      p_color: colorsList.toString(),
      p_price: productList[0]['price'].toString(),
      p_stock: "null",
      p_type: productList[0]['type'],
      p_file: productList[0]['file'],
      p_link: "null",
      p_license: productList[0]['license'],
      p_license_qty: productList[0]['license_qty'],
      p_measure: "null",
      p_whole_sale_qty: whole_sell_qtyList.toString(),
      p_whole_sale_discount: whole_sell_discountList.toString(),
      p_attributes: "null",
      license: "",
      dp: "0",
      keys: "",
      values: "",
      item_price: productList[0]['price'].toString(),
    );
    bool isExist =
        await dbcartmanager.checkCartItems(productList[0]['name'].toString());

    if (isExist) {
      dbcartmanager.insertProduct(cartItem).then(
            (value) => {
              print("Data Added $value"),
              print(productList[0]['photo']),
              print(productList[0]['rating']),
              print(productList[0]['previous_price']),
              print(productList[0]['price'].toString()),
              print(productList[0]['name'].toString()),
            },
          );
      Fluttertoast.showToast(
          msg: "Product Added To Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black26,
          fontSize: 16.0);
      // cartController.getCartCount();
      // addToCartWeb(
      //     productList[0]['id'].toString(),
      //     "1",
      //     productList[0]['size'].toString(),
      //     productList[0]['size_qty'].toString(),
      //     productList[0]['size_price'].toString(),
      //     // productList[0]['size_key'],
      //     "",
      //     "",
      //     "",
      //     productList[0]['price'].toString().split('.')[0]);
      print("Product Added into Cart");
    } else {
      Fluttertoast.showToast(
          msg: "Product Already Exist in Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black26,
          fontSize: 16.0);
      print('product already exist in cart');
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
    print("Add to cart web");
    // var priceMap = {"0": "$prices"};
    var url = Constants.baseUrl;
    Map body = {
      "id": "100",
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
      Uri.parse(url + '/addtocart'),
      body: body,
    );

    print("Add to cart web response: ${response.body}");
  }
}
