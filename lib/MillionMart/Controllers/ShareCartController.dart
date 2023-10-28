import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareCartController extends GetxController {
  var url = Constants.baseUrl;

  List cartdata = [];

  List cartlistdata = [];

  String? userId;

  var successfully = ''.obs;

  userData() async {
    final SharedPreferences _prefs = await Constants.prefs;
    userId = _prefs.getString('email');

    Constants.userNameData = userName;
  }

  final DatabaseHelper dbcartmanager = new DatabaseHelper();

  shareCart(List cart, String reciever) async {
    String refinedCart = cart.join(',');
    print("in receive card");
    print(refinedCart);
    Map body = {
      "userid": userId,
      "recieverid": reciever,
      "cart": "$refinedCart",
    };
    Get.log(body.toString());
    http.Response response = await http.post(
      Uri.parse(url + '/savesharecart'),
      body: body,
    );
    print("receive card status"+response.statusCode.toString());
    if (response.body.contains("successfully")) {
      successfully.value = "successfully";
      print("value of success ${successfully.value}");
      // Get.back();
    }
  }

  recieveCart(String sender) async {
    print("User data is :${sender} "+userId.toString());
    var response = await http.get(
      Uri.parse(url + '/getsharecart/$sender/$userId'),
    );
    print("Cart Response ${response.body.toString()}");
    var data = json.decode(response.body);
    cartlistdata = data;
    addToCart();
    Get.back();
  }

  void addToCart() async {
    for (int i = 0; i < cartlistdata.length; i++) {
      //   var itemqty = 1;
      // var item_size_key = cartlistdata[i]['size_key'];
      // var item_size_price = cartlistdata[i]['size_price'];
      // var itemsize = cartlistdata[i]['size'];
      // var itemcolor = cartlistdata[i]['color'];
      // var itemprice = cartlistdata[i]['price'];
      //Maintaining the list start
      //size
      var size;
      cartlistdata[i]['size'].toString().isEmpty
      ? size = "" :
      size = cartlistdata[i]['size']
          .toString()
          .substring(1, cartlistdata[i]['size'].toString().length - 1);

      var sizesList = [];

      var splitSize = size.split(',');
      for (var a in splitSize) {
        String b = "$a";
        sizesList.add(b);
      }
      print(sizesList);

      //size_qty
      var size_qty;
      cartlistdata[i]['size_qty'].toString().isEmpty
      ? size_qty = "" :
      size_qty = cartlistdata[i]['size_qty']
          .toString()
          .substring(1, cartlistdata[i]['size_qty'].toString().length - 1);
      var size_qtyList = [];
      var splitSizeQty = size_qty.split(',');
      for (var a in splitSizeQty) {
        String b = "$a";
        size_qtyList.add(b);
      }
      print(size_qtyList);

      //size_price
      var size_price;
      cartlistdata[i]['size_price'].toString().isEmpty
      ? size_price = "" :
      size_price = cartlistdata[i]['size_price']
          .toString()
          .substring(1, cartlistdata[i]['size_price'].toString().length - 1);
      var size_priceList = [];
      var splitSizePrice = size_price.split(',');
      for (var a in splitSizePrice) {
        String b = "$a";
        size_priceList.add(b);
      }
      print(size_priceList);

      //color
      var color;
      cartlistdata[i]['color'].toString().isEmpty
      ? color = "" :
      color = cartlistdata[i]['color']
          .toString()
          .substring(1, cartlistdata[i]['color'].toString().length - 1);

      var colorsList = [];
      var splitColor = color.split(',');
      for (var a in splitColor) {
        String b = "$a";
        colorsList.add(b);
      }
      print(colorsList);

      //whole_sell_qty
      var whole_sell_qty;
      cartlistdata[i]['whole_sell_qty'].toString().isEmpty
      ? whole_sell_qty = "" :
      whole_sell_qty = cartlistdata[i]['whole_sell_qty']
          .toString()
          .substring(
              1, cartlistdata[i]['whole_sell_qty'].toString().length - 1);
      var whole_sell_qtyList = [];
      var splitWholeSellQty = whole_sell_qty.split(',');
      for (var a in splitWholeSellQty) {
        String b = "$a";
        whole_sell_qtyList.add(b);
      }
      print(whole_sell_qtyList);

      //whole_sell_discount
      var whole_sell_discount;
      cartlistdata[i]['whole_sell_discount'].toString().isEmpty
      ? whole_sell_discount = "" :
      whole_sell_discount = cartlistdata[i]['whole_sell_discount']
          .toString()
          .substring(
              1, cartlistdata[i]['whole_sell_discount'].toString().length - 1);
      var whole_sell_discountList = [];
      var splitWholeSellDiscount = whole_sell_discount.split(',');
      for (var a in splitWholeSellDiscount) {
        String b = "$a";
        whole_sell_discountList.add(b);
      }
      print(whole_sell_discountList);
      //end maintaining
      var sizeList = [];
      sizeList.add(cartlistdata[i]['size']);

      Cart cartItem;
      // var now = DateTime.now();
      cartItem = new Cart(
        name: cartlistdata[i]['name'].toString(),
        image: cartlistdata[i]['photo'].toString(),
        price: cartlistdata[i]['price'].toString().split('.')[0],
        previous_price:
            cartlistdata[i]['previous_price'].toString().split('.')[0],
        qty: 1,
        sub_total: cartlistdata[i]['price'].toString(),
        id: i,
        // color: cartlistdata[i]['color'].toString(),
        color: "#FFFFFF",

        // '"${productController.productList[0]['id']}":{"qty":$itemqty,"size_key":$item_size_key,"size_qty":"${widget.productController.productList[0]['size_qty']}","size_price":"$item_size_price","size":"$itemsize","color":"$itemcolor","stock":null,"price":$itemprice,"item":{"id":${widget.productController.productList[0]['id']},"user_id":${widget.productController.productList[0]['user_id']},"slug":"${widget.productController.productList[0]['slug']}","name":"${widget.productController.productList[0]['name']}","photo":"${widget.productController.productList[0]['photo']}","size":"${widget.productController.productList[0]['size']}","size_qty":"${widget.productController.productList[0]['size_qty']}","size_price":"${widget.productController.productList[0]['size_price']}","color":"${widget.productController.productList[0]['color']}","price":"${widget.productController.productList[0]['price']}","stock":null,"type":"${widget.productController.productList[0]['type']}","file":"${widget.productController.productList[0]['file']}","link":null,"license":"${widget.productController.productList[0]['license']}","license_qty":"${widget.productController.productList[0]['license_qty']}","measure":null,"whole_sell_qty":"${widget.productController.productList[0]['whole_sell_qty']}","whole_sell_discount":"${widget.productController.productList[0]['whole_sell_discount']}","attributes":null},"license":"","dp":"0","keys":"","values":"","item_price":${widget.productController.productList[0]['price']}}',
        size_key: 0,
        size_price: cartlistdata[i]['size_price'].toString(),
        size_qty: cartlistdata[i]['size_qty'].toString(),
        size: cartlistdata[i]['size'].toString(),
        stock:
            cartlistdata[i]['stock'].toString().isEmpty
                ? 'null'
                : cartlistdata[i]['stock'].toString(),
        slug: cartlistdata[i]['slug'],
        key: cartlistdata[i]['id'].toString(),
        p_id: cartlistdata[i]['id'].toString(),
//  "price": itemprice,
//  "color": itemcolor,
        p_user_id: cartlistdata[i]['user_id'].toString(),
        p_slug: cartlistdata[i]['slug'],
        p_name: cartlistdata[i]['name'],
        p_photo: cartlistdata[i]['photo'],
        p_size: sizeList.toString(),
        p_size_qty: size_qtyList.toString(),
        p_size_price: size_priceList.toString(),
        p_color: colorsList.toString(),
        p_price: cartlistdata[i]['price'].toString(),
        p_stock: "null",
        p_type: cartlistdata[i]['type'],
        p_file: cartlistdata[i]['file'],
        p_link: "null",
        p_license: cartlistdata[i]['license'],
        p_license_qty: cartlistdata[i]['license_qty'],
        p_measure: "null",
        p_whole_sale_qty: whole_sell_qtyList.toString(),
        p_whole_sale_discount: whole_sell_discountList.toString(),
        p_attributes: "null",
        license: "",
        dp: "0",
        keys: "",
        values: "",
        item_price: cartlistdata[i]['price'].toString(),
      );
      bool isExist = await dbcartmanager
          .checkCartItems(cartlistdata[i]['name'].toString());

      if (isExist) {
        dbcartmanager.insertProduct(cartItem).then(
              (value) => {
                print("Data Added $value"),
                print(cartlistdata[i]['photo']),
                print(cartlistdata[i]['rating']),
                print(cartlistdata[i]['previous_price']),
                print(cartlistdata[i]['price'].toString()),
                print(cartlistdata[i]['name'].toString()),
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
        // productController.cartController.getCartCount();
        // addToCartWeb(
        //     cartlistdata[i]['id'].toString(),
        //     "1",
        //     cartlistdata[i]['size'].toString(),
        //     cartlistdata[i]['size_qty'].toString(),
        //     cartlistdata[i]['size_price'].toString(),
        //     // productController.productList[0]['size_key'],
        //     "",
        //     "",
        //     "",
        //     cartlistdata[i]['price'].toString().split('.')[0]);
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
  }

  // addToCartWeb(
  //     String id,
  //     String qty,
  //     String size,
  //     String size_qty,
  //     String size_price,
  //     String size_key,
  //     String keys,
  //     String values,
  //     String prices) async {
  //   print("Add to cart web");
  //   // var priceMap = {"0": "$prices"};
  //   var url = Constants.baseUrl;
  //   Map body = {
  //     "id": "100",
  //     "qty": qty,
  //     "size": size,
  //     "size_qty": size_qty,
  //     "size_price": size_price,
  //     "size_key": size_key,
  //     "keys": keys,
  //     "values": values,
  //     "prices[]": prices,
  //   };
  //   final response = await http.post(
  //     Uri.parse(url + '/addtocart'),
  //     body: body,
  //   );

  //   print("Add to cart web response: ${response.body}");
  // }
}
