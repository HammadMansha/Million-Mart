import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/CheckoutController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/DeleteAddressController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/GetAddressController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PaymentMethodsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PromoCodeController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PromoCodeGetxController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/ShippingmMethods.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/cartController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartAddress.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/NoInternet.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/Order_Completed.dart';
import 'package:millionmart_cleaned/MillionMart/database/database.dart';
import 'package:millionmart_cleaned/MillionMart/models/PromoCodeModelClass.dart';
import 'package:responsive_builder/responsive_builder.dart';




var sumPrice;
PromoCode? code;
String? country, city, address;
var totalPrice;
int selectedAddress = 0;
// var price = 0.obs;

class MillionMartCheckout extends StatefulWidget {
  MillionMartCheckout({Key? key}) : super(key: key);

  @override
  _MillionMartCheckoutState createState() => _MillionMartCheckoutState();
}

class _MillionMartCheckoutState extends State<MillionMartCheckout>
    with TickerProviderStateMixin {
  int _curIndex = 0;
  late List<Widget> fragments;
  final DatabaseHelper _dBcartManager = new DatabaseHelper();
  CheckoutController checkoutController = Get.put(CheckoutController());

  // late Animation buttonSqueezeanimation;
  // late AnimationController buttonController;

  @override
  void initState() {
    isLoadingAddress.value = true;
    CouponPrice.discount.value = 0;
    super.initState();

    fragments = [Delivery(), Address(), Payment()];
  }

  @override
  void dispose() {
    // buttonController.dispose();
    // Get.reset();
    getAddress.clear();
    Get.delete<CouponPrice>();
    print("class disposed");
    super.dispose();
  }

  getAppBar(String title, BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: primaryColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: primaryColor,
        ),
      ),
      backgroundColor: Color(0xFFAED0F3),
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      elevation: 5,
    );
  }

  stepper() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          InkWell(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _curIndex == 0 ? primaryColor : Colors.grey,
                  ),
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      "1",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text("  " + 'delivery'.tr + "  ",
                    style: TextStyle(color: _curIndex == 0 ? primaryColor : null)),
              ],
            ),
            onTap: () {
              setState(() {
                _curIndex = 0;
              });
            },
          ),
          Expanded(child: Divider()),
          InkWell(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _curIndex == 1 ? primaryColor : Colors.grey,
                  ),
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      "2",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text("  " + 'address'.tr + "  ",
                    style: TextStyle(color: _curIndex == 1 ? primaryColor : null)),
              ],
            ),
            onTap: () {
              setState(() {
                _curIndex = 1;
              });
            },
          ),
          Expanded(child: Divider()),
          InkWell(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _curIndex == 2 ? primaryColor : Colors.grey,
                  ),
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      "3",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text("  " + 'payment'.tr + "  ",
                    style: TextStyle(color: _curIndex == 2 ? primaryColor : null)),
              ],
            ),
            onTap: () {
              if (_curIndex == 0) {
                setState(() {
                  _curIndex = 1;
                });
              } else
                setState(() {
                  _curIndex = 2;
                });
            },
          ),
        ],
      ),
    );
  }

  CartController cartController = Get.put(CartController());
  NetworkController networkController = Get.put(NetworkController());

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.find<CartController>();
    cartController.getCartCount();
    var sumtotal = cartController.getTotal();
    cartController.update();
    return Obx(() {

      checkoutController.promoCodeDiscount.value == "" ?
      checkoutController.p = 0 :
      checkoutController.p = int.parse(checkoutController.promoCodeDiscount.value);
      checkoutController.discountType.value =="1"?
      totalPrice =
          ((sumtotal + (sumtotal * 16 / 100) + shippingMethodsPrice.value) -
                  (CouponPrice.discount.value))
              .toStringAsFixed(2):
      totalPrice =
          ((sumtotal + (sumtotal * 16 / 100) + shippingMethodsPrice.value) -
              (checkoutController.p))
              .toStringAsFixed(2);

      return networkController.networkStatus.value == true
          ? Scaffold(
              appBar: getAppBar('checkout'.tr, context),
              body: Column(
                children: [
                  stepper(),
                  Divider(),
                  Expanded(child: fragments[_curIndex]),
                ],
              ),
              persistentFooterButtons: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: RichText(
                            text: TextSpan(
                                text: 'total_price'.tr,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: ": " +
                                          "Rs" +
                                          " " +
                                          "${((sumtotal + shippingMethodsPrice.value) - (CouponPrice.discount.value)).toStringAsFixed(2)}",
                                      style:
                                          TextStyle(color: Color(0xffF58323)))
                                ]),
                          )
                          // Text(
                          //   TOTAL + " : " + CUR_CURRENCY + " " + "6100",
                          //   textAlign: TextAlign.left,
                          //   style: TextStyle(
                          //     color: Color(0xffF58323),
                          //   ),
                          // ),
                          ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_curIndex == 0) {
                          setState(() {
                            _curIndex = _curIndex + 1;
                          });
                        } else if (_curIndex == 1) {
                          if (getAddress.isEmpty) {
                            Get.snackbar(
                              "error".tr,
                              "noAddress".tr,
                                backgroundColor: notificationBackground,
                              colorText: notificationTextColor,
                              // backgroundColor: notificationBackground,
                            );
                          } else {
                            if (selectedAddress == 0) {
                              city = getAddress[0]["city"];
                              country = getAddress[0]["country"];
                              address = getAddress[0]["address"];
                              setState(() {});
                            }

                            print("selected Address is : " + city.toString());
                            setState(() {
                              _curIndex = _curIndex + 1;
                            });
                          }
                        } else if (_curIndex == 2) {
                          // (((sumtotal +(sumtotal * 16 / 100)+ shippingMethodsPrice.value) - (CouponPrice.discount.value)));
                          checkoutOrder();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0.0)),
                          ),
                          primary: Colors.transparent,
                          padding: EdgeInsets.all(0.0)),
                      child: Ink(
                        decoration: BoxDecoration(
                          // gradient: MillionMartgradient,
                          color: Color(0xffF58323),
                        ),
                        child: Container(
                          height: 40.0,
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          alignment: Alignment.center,
                          child: Text(
                            _curIndex == 2 ? 'proceed'.tr : "continue".tr,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          : NoInternetScreen();
    });
  }

  Future<void> checkoutOrder() async {
    // var sumtotal = cartController.getTotal();
    // var totalBill = sumtotal + (sumtotal * 16 / 100) + 150;

    sumPrice = cartController.getTotal();
    print("total is 1 :" + sumPrice.toString());
    var tax = sumPrice * 16 / 100;
    var bill = (((sumPrice + tax + shippingMethodsPrice.value) -
            (CouponPrice.discount.value)))
        .toString();
    print("total Bill is " + bill.toString());

    Cart? st;
    List cartData = [];

    for (int i = 0; i < cartController.cartCoount.length; i++) {
      st = cartController.cartCoount[i];
      //todo
      // cartData.add(cartController.cartCoount[i]);
    }

    // callApi(bill, cartData);

    await addToCart(bill, st);

    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => order_completed()));
  }

  Future<void> addToCart(bill, cartData) async {
    CheckoutController _checkoutController = Get.find<CheckoutController>();
    Cart? st;
    Map items = {};

    for (int i = 0; i < cartController.cartCoount.length; i++) {
      st = cartController.cartCoount[i];
      Get.log(st.name!);
      items.addAll({
        st.key: {
          "qty": st.qty,
          "size_key": st.size_key,
          "size_qty": st.size_qty,
          "size_price": st.size_price,
          "size": st.size,
          "color": st.color,
          "stock": st.stock,
          "price": st.price,
          "item": {
            "id": st.p_id,
            "user_id": st.p_user_id,
            "slug": st.p_slug,
            "name": st.p_name,
            "photo": st.p_photo,
            "size": st.p_size,
            "size_qty": st.p_size_qty,
            "size_price": st.p_size_price,
            "color": st.p_color,
            "price": st.p_price,
            "stock": st.p_stock,
            "type": st.p_type,
            "file": st.p_file,
            "link": st.p_link,
            "license": st.p_license,
            "license_qty": st.p_license_qty,
            "measure": st.p_measure,
            "whole_sell_qty": st.p_whole_sale_qty,
            "whole_sell_discount": st.p_whole_sale_discount,
            "attributes": st.p_attributes
          },
          "license": st.license,
          "dp": st.dp,
          "keys": st.keys,
          "values": st.values,
          "item_price": st.item_price,
        }
      });
      //todo
      // cartData.add(cartController.cartCoount[i]);
    }
    Get.log(items.toString());
    print(st!.name);
    Get.log(json.encode({
      "user_id": Constants.userID,
      "cart": {"items": items, "totalQty": 1, "totalPrice": totalPrice},
      "totalQty": cartController.cartCoount.length,
      "pay_amount": totalPrice,
      "method": "Cash On Delivery",
      "customer_name": _checkoutController.userName,
      "customer_email": _checkoutController.userEmail,
      "customer_address": address ?? null,
      "customer_phone": _checkoutController.userPhone,
      "customer_country": country ?? null,
      "customer_city": city ?? null,
      "payment_status": "unpaid",
      "vendor_shipping_id": 1,
      "currency_value":1,
      "vendor_packing_id": 1
    }));
    String url =  Constants.baseUrl;
    var response = await http.post(

        // Uri.parse("https://millionmart.socialscrew.com/api/ordersave"),
        Uri.parse("${url}/ordersave"),
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
        },
        body: json.encode({
          "user_id": _checkoutController.userId,
          "cart": {"items": items, "totalQty": 1, "totalPrice": totalPrice},
          "totalQty": cartController.cartCoount.length,
          "pay_amount": totalPrice,
          "currency_value":1,
          "method": "Cash On Delivery",
          "customer_name": _checkoutController.userName,
          "customer_email": _checkoutController.userEmail,
          "customer_address": address ?? null,
          "customer_phone": _checkoutController.userPhone,
          "customer_country": country ?? null,
          "customer_city": city ?? null,
          "payment_status": "unpaid",
          "vendor_shipping_id": 1,
          "vendor_packing_id": 1
        }));
    print(response.body);
    if (response.body.contains("successfully") || response.statusCode == 200) {
      _dBcartManager.deleteWholeCart();
      cartController.getCartCount();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => order_completed()));
    } else {
      Fluttertoast.showToast(msg: "Error in placing your order");
    }
  }

//   void callApi(var _bill, List<String> cartData) async {
//     CheckoutController _checkoutController = Get.find<CheckoutController>();
//     // var totalQty = cartData.length;
//     // var sumtotal = cartController.getTotal();
//     // var totalBill = sumtotal + (sumtotal * 16 / 100) + 150;
//     // var cart =
//     //     '{"items":{${cartData[0]}}, "totalQty" : $totalQty, "totalPrice" : $totalBill}';
//
//     var cart = {
//       "items": cartData[0],
//       "totalQty": 3,
//       "totalPrice": 500,
//     };
//     // var cart = '{"items":{${cartData[0]}}, "totalQty" : 3, "totalPrice" : 500}';
//     print('My Cart');
//     print(cart);
//     // print(cart);
//     // Map<String, String> body = {
//     //   // "cart": cart,
//     //   "user_id": "137",
//     //   "totalQty": "1",
//     //   "pay_amount": "250",
//     //   "method": "Cash On Delivery",
//     //   "customer_name": "Muntazir",
//     //   "customer_email": "smmr143@gmail.com",
//     //   "customer_address": "PIA, Lahore",
//     //   "customer_phone": "03436332887",
//     //   "customer_country": "Pakistan",
//     //   "customer_city": "Lahore",
//     //   "payment_status": "unpaid",
//     //   "vendor_shipping_id": "1",
//     //   "vendor_packing_id": "1",
//     // };
//
//     // var check = jsonEncode(body);
//     // print(jsonEncode(body));
//
//     //uncomment from this
//     var cartCount = cartController.cartCoount.length;
//     print("total bill in APi " + _bill.toString());
//     print("User Name is : " + _checkoutController.userName.toString());
//     print(_checkoutController.userId);
//     print(_checkoutController.userEmail);
//     print(_checkoutController.userPhone);
//     print(country);
//     print(city);
//     print(address);
//     print("Cart Count is " + cartCount.toString());
//     //to this
//
//     // var dio = Dio();
//     // // var cookieJar = CookieJar();
//
//     // // dio.interceptors.add(CookieManager(cookieJar));
//     // dio.options.headers = {
//     //   'Accept': "application/json",
//     //   'Content-Type': 'application/json; charset=UTF-8',
//     // };
//     // var response = await dio.post(
//     //   "https://millionmart.socialscrew.com/api/orderSaveMobile",
//     //   data: jsonEncode({
//     //     "user_id": _checkoutController.userId,
//     //     "totalQty": "$cartCount",
//     //     "pay_amount": _bill.toString(),
//     //     "method": "Cash On Delivery",
//     //     "customer_name": _checkoutController.userName,
//     //     "customer_email": _checkoutController.userEmail,
//     //     "customer_address": address ?? "null",
//     //     "customer_phone": _checkoutController.userPhone ?? "null",
//     //     "customer_country": country ?? "null",
//     //     "customer_city": city ?? "null",
//     //     "payment_status": "unpaid",
//     //     "vendor_shipping_id": "1",
//     //     "vendor_packing_id": "1",
//     //   }),
//     // );
//
//     // print(response.data);
//
//     //uncomment from this
//     // const chars =
//     //     'eyJpdiI6IlFnQ0pCNnFITzM3RXMrYndhaU5TTVE9PSIsInZhbHVlIjoiUm42ZHZoTGg3Z1M2SmNDU1ErcXZqOCtVd29BcTBFQk0rNndXajFYUEFxeENpTlhvNUl4dU90SXRkL0lWQjM0eEFMTmhDOTNFU0pXbGt3d1FFRm9YOExJdUUxZHFFRGtZMFJmWXk1YStnYllNZ3dhZHdCWGh1aDJkNkcrOXNYbjciLCJtYWMiOiIyYWQwYjY2YzEyNDdmNmUyYmQwMDA0ZWQ5Y2E5OWRmMjA0ODE5ZmViMzlhNzA5MGZkNDBjYTEzNmJhMTMyNTM3In0%3D';
//     // Random rnd = Random();
//
//     // String getRandomString(int length) =>
//     //     String.fromCharCodes(Iterable.generate(
//     //         length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
//     // print("random string ${getRandomString(100)}");
//     Map<String, dynamic> body = {
//       // "user_id": _checkoutController.userId,
//       "user_id": "13",
//       "cart": cart,
//       // "totalQty": "\"$cartCount\"",
//       // "pay_amount": "\"${_bill.toString()}\"",
//       // "method": "\"Cash On Delivery\"",
//       // "customer_name": "\"${_checkoutController.userName}\"",
//       // "customer_email": "\"${_checkoutController.userEmail}\"",
//       // "customer_address": "\"$address\"",
//       // "customer_phone": "\"${_checkoutController.userPhone}\"",
//       // "customer_country": "\"$country\"",
//       // "customer_city": "\"$city\"",
//       "totalQty": "$cartCount",
//       "pay_amount": "${_bill.toString()}",
//       "method": "Cash On Delivery",
//       "customer_name": "${_checkoutController.userName}",
//       "customer_email": "\"${_checkoutController.userEmail}\"",
//       "customer_address": "$address",
//       "customer_phone": "\"${_checkoutController.userPhone}\"",
//       "customer_country": "$country",
//       "customer_city": "$city",
//       // "payment_status": "\"unpaid\"",
//       "payment_status": "pending",
//       "vendor_shipping_id": "1",
//       "vendor_packing_id": "1",
//     };
//     Get.log(body.toString());
//     // var c;
//     // cartData.forEach((element) {
//     //   c = element;
//     //   print("check $element");
//     // });
//     // var test = jsonEncode({cartData[0]});
//     print("check");
//     // Get.log(test);
//     var data = json.encode(
//       {
//         "user_id": 130,
//         "cart": {
//           "items": cartData[0],
//           // {
//           //   "100": {
//           //     "qty": 1,
//           //     "size_key": null,
//           //     "size_qty": "2",
//           //     "size_price": "20",
//           //     "size": "S",
//           //     "color": "#000000",
//           //     "stock": null,
//           //     "price": 100,
//           //     "item": {
//           //       "id": 100,
//           //       "user_id": 13,
//           //       "slug":
//           //           "physical-product-title-title-will-be-here-97-pr602jsv",
//           //       "name": "Physical Product Title Title will Be Here 97",
//           //       "photo":
//           //           "https://millionmart.socialscrew.com//assets/images/products/1568026462TxRJ07FG.png",
//           //       "size": ["S", " M", " L"],
//           //       "size_qty": ["21", "33", "44"],
//           //       "size_price": ["20", "30", "40"],
//           //       "color": [
//           //         "#000000",
//           //         "#851818",
//           //         "#FF0D0D",
//           //         "#1FEB4C",
//           //         "#D620CF",
//           //         "#186CEB"
//           //       ],
//           //       "price": "100",
//           //       "stock": null,
//           //       "type": "Physical",
//           //       "file": "null",
//           //       "link": null,
//           //       "license": "",
//           //       "license_qty": "",
//           //       "measure": null,
//           //       "whole_sell_qty": ["10", "20", "30", "40"],
//           //       "whole_sell_discount": ["5", "10", "15", "20"],
//           //       "attributes": null
//           //     },
//           //     "license": "",
//           //     "dp": "0",
//           //     "keys": "",
//           //     "values": "",
//           //     "item_price": 100
//           //   }
//           // }.toString(),
//           "totalQty": 3,
//           "totalPrice": 500
//         },
//         "totalQty": 1,
//         "pay_amount": 116.0,
//         "method": "CashOnDelivery",
//         "customer_name": "Muntazir",
//         "customer_email": "\"smmr143@gmail.com\"",
//         "customer_address": "null",
//         "customer_phone": "\"03436332887\"",
//         "customer_country": "lahaore",
//         "customer_city": "null",
//         "payment_status": "unpaid",
//         "vendor_shipping_id": 1,
//         "vendor_packing_id": 1,
//       },
// //        {
// //    "user_id":13,
// //    "cart":{
// //       "items":{
// //          "100":{
// //             "qty":1,
// //             "size_key":null,
// //             "size_qty":"214",
// //             "size_price":"20",
// //             "size":"S",
// //             "color":"#000000",
// //             "stock":null,
// //             "price":100,
// //             "item":{
// //                "id":100,
// //                "user_id":13,
// //                "slug":"physical-product-title-title-will-be-here-97-pr602jsv",
// //                "name":"Physical Product Title Title will Be Here 97",
// //                "photo":"https://millionmart.socialscrew.com//assets/images/products/1568026462TxRJ07FG.png",
// //                "size":[
// //                   "S",
// //                   " M",
// //                   " L"
// //                ],
// //                "size_qty":[
// //                   "214",
// //                   " 214",
// //                   " 214"
// //                ],
// //                "size_price":[
// //                   "20",
// //                   " 30",
// //                   " 40"
// //                ],
// //                "color":[
// //                   "#000000",
// //                   " #851818",
// //                   " #ff0d0d",
// //                   " #1feb4c",
// //                   " #d620cf",
// //                   " #186ceb"
// //                ],
// //                "price":"100",
// //                "stock":null,
// //                "type":"Physical",
// //                "file":"null",
// //                "link":null,
// //                "license":"",
// //                "license_qty":"",
// //                "measure":null,
// //                "whole_sell_qty":[
// //                   "10",
// //                   " 20",
// //                   " 30",
// //                   " 40"
// //                ],
// //                "whole_sell_discount":[
// //                   "5",
// //                   " 10",
// //                   " 15",
// //                   " 20"
// //                ],
// //                "attributes":null
// //             },
// //             "license":"",
// //             "dp":"0",
// //             "keys":"",
// //             "values":"",
// //             "item_price":100
// //          }
// //       },
// //       "totalQty":3,
// //       "totalPrice":500
// //    },
// //    "totalQty":1,
// //    "pay_amount":116.0,
// //    "method":"Cash On Delivery",
// //    "customer_name":"Farhan Aslam",
// //    "customer_email":"alihak@gmail.com",
// //    "customer_address":null,
// //    "customer_phone":"03434044387",
// //    "customer_country":null,
// //    "customer_city":null,
// //    "payment_status":"pending",
// //    "vendor_shipping_id":1,
// //    "vendor_packing_id":1
// // }
//     );
//     var body1 = {
//       // "user_id": _checkoutController.userId,
//       "user_id": "13",
//       "cart": {
//         "items": cartData[0],
//         "totalQty": "3",
//         "totalPrice": 500,
//       },
//       "totalQty": "2",
//       "pay_amount": "${_bill.toString()}",
//       "method": "Cash On Delivery",
//       "customer_name": "${_checkoutController.userName}",
//       "customer_email": "\"${_checkoutController.userEmail}\"",
//       "customer_address": "$address",
//       "customer_phone": "\"${_checkoutController.userPhone}\"",
//       "customer_country": "$country",
//       "customer_city": "$city",
//
//       "payment_status": "pending",
//       "vendor_shipping_id": "1",
//       "vendor_packing_id": "1",
//     };
//     String url =  Constants.baseUrl;
//     var response = await http.post(
//       Uri.parse("https://millionmart.socialscrew.com/api/ordersave"),
//       // Uri.parse("http://192.168.100.200/millionmart/api/ordersave"),
//       // headers: {
//       // 'Cookie': 'laravel_session=qSoBmup8G6g8fG1l3cBrD0U0FXg86prFIOM4fSBT',
//       // 'set-cookie' : 'XSRF-TOKEN=${getRandomString(330)}'
//       // 'Content-Type': 'application/json; charset=UTF-8',
//       // 'Accept': 'application/json',
//       // "HTTP_COOKIE": "laravel_session=${getRandomString(330)}"
//       // },
//       headers: {
//         'Content-type': 'application/json',
//         "Accept": "application/json",
//       },
//       body: {
//         // "user_id": _checkoutController.userId,
//         "user_id": "13",
//         "cart": {
//           "items": cartData[0],
//           "totalQty": "3",
//           "totalPrice": 500,
//         }.toString(),
//         "totalQty": "2",
//         "pay_amount": "${_bill.toString()}",
//         "method": "Cash On Delivery",
//         "customer_name": "${_checkoutController.userName}",
//         "customer_email": "\"${_checkoutController.userEmail}\"",
//         "customer_address": "$address",
//         "customer_phone": "\"${_checkoutController.userPhone}\"",
//         "customer_country": "$country",
//         "customer_city": "$city",
//
//         "payment_status": "pending",
//         "vendor_shipping_id": "1",
//         "vendor_packing_id": "1",
//       },
//       // body: json.encode({
//       //   // "user_id": _checkoutController.userId,
//       //   "user_id": "13",
//       //   "cart": {
//       //     "items": cartData,
//       //     "totalQty": 3,
//       //     "totalPrice": 500,
//       //   },
//       //   "totalQty": 2,
//       //   "pay_amount": "${_bill.toString()}",
//       //   "method": "Cash On Delivery",
//       //   "customer_name": "${_checkoutController.userName}",
//       //   "customer_email": "\"${_checkoutController.userEmail}\"",
//       //   "customer_address": "$address",
//       //   "customer_phone": "\"${_checkoutController.userPhone}\"",
//       //   "customer_country": "$country",
//       //   "customer_city": "$city",
//
//       //   "payment_status": "pending",
//       //   "vendor_shipping_id": "1",
//       //   "vendor_packing_id": "1",
//       // }),
//     );
//     Get.log(body1.toString());
//     print("Testing new");
//     Get.log("encoded     " + json.encode(body1));
//     print("Check Data ${response.body}");
//     Get.log(response.body);
//     if (response.body.contains("successfully") && response.statusCode == 200) {
//       _dBcartManager.deleteWholeCart();
//       cartController.getCartCount();
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => order_completed()));
//     } else {
//       Fluttertoast.showToast(msg: "Error in placing your order");
//     }
//     //to this
//   }
}

void getTotaL(){

}

class Delivery extends StatefulWidget {
  Delivery();

  @override
  State<StatefulWidget> createState() {
    return StateDelivery();
  }
}

class StateDelivery extends State<Delivery> with TickerProviderStateMixin {
  late double totalBill;
  late int? type;
  var check = false.obs;
  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;
  TextEditingController promoController = TextEditingController();
  CartController cartController = Get.put(CartController());
  CheckoutController checkoutController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          } // currentFocus.dispose();
        },
        onVerticalDragCancel: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: <Widget>[
            _deliveryContent(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // a.clear();
    // buttonController.dispose();
    super.dispose();
  } // final DBcartManager _dBcartManager = new DBcartManager();
  // var sumprice = 0.obs;
  // List<Cart> daata = <Cart>[].obs;
  // Future<void> fetchData() async {
  //   daata = await _dBcartManager.getStudentList();
  //   for(int c = 0 ; c< daata.length; c++){
  //     sumprice = sumprice + int.parse(daata[c].sub_total);
  //     // setState(() {
  //     //   sumprice = sumprice + int.parse(daata[c].price);
  //     // });
  //
  //   }
  //   print('summPrince'+sumprice.toString());
  // }

  _deliveryContent() {
    sumPrice = 0;
    sumPrice = cartController.getTotal();
    totalBill = sumPrice + (sumPrice * 16 / 100);
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'have_promo'.tr,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      child: Icon(Icons.refresh),
                      onTap: () {
                        promoController.clear();
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: promoController,
                        decoration: InputDecoration(
                          // enabled: false,
                          isDense: true,
                          contentPadding: EdgeInsets.all(
                            10,
                          ),
                          hintText: 'promo_code'.tr,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // var promoCode;
                          if (promoController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Add a Promo Code",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.black26,
                                fontSize: 16.0);
                          } else {
                            String couponCode = promoController.text;
                            print("Api hit code " + promoController.text);
                            await checkoutController.promoCodeController(couponCode);
                            // await promoCodeController(couponCode);
                            // var a = json.decode(res);
                            // print("APi Data " + res.toString());
                            // print(a[0]['type']);
                            // print(res['type']);
                            if (checkoutController.promoCodeDiscount.value.isEmpty) {
                              print("wrong code");
                              Fluttertoast.showToast(
                                  msg: "Wrong Promo Code",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.black26,
                                  fontSize: 16.0);
                            } else {
                              CouponPrice.price.value =
                                  double.parse(checkoutController.promoCodeDiscount.value);
                              print("data added to price");
                              type = int.parse(checkoutController.discountType.value);
                              print("Type Value is : $type");
                              // a = null;
                              if (type != null) {
                                var c = int.parse(checkoutController.promoCodeDiscount.value);
                                check.value = true;
                                if (type == 0) {
                                  CouponPrice.discount.value =
                                      totalBill * c / 100;
                                  print('Coupon value is ${CouponPrice.discount.value}');
                                } else if (type == 1) {
                                  CouponPrice.discount.value =
                                      CouponPrice.price.value;
                                  print('Else Condition ${ CouponPrice.discount.value}');
                                }
                              }
                              // print(CouponPrice.price.value);
                            }

                            // print("a data : " + a.toString());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0.0),
                          primary: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0.0)),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                Color(0xffF58323),
                                Color(0xffFBA35B)
                              ])),
                          child: Container(
                            constraints:
                                BoxConstraints(minWidth: 98.0, minHeight: 36.0),
                            // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Text(
                              'apply'.tr,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, top: 10),
                  child: Text(
                    'order_summary'.tr,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                ScreenTypeLayout(
                  mobile: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 5, child: Text('product_name'.tr)),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    'qty'.tr,
                                    textAlign: TextAlign.end,
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    'price'.tr,
                                    textAlign: TextAlign.end,
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    'sub_total'.tr,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          Divider(),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: cartController.cartCoount.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Cart st = cartController.cartCoount[index];
                                return orderItem(st);
                              }),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 28, bottom: 8.0, left: 0, right: 0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'sub_total'.tr,
                                ),
                                Spacer(),
                                Text("Rs " + "${sumPrice.toStringAsFixed(2)}")
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 0, right: 0, top: 8, bottom: 8),
                          //   child: Row(
                          //     children: <Widget>[
                          //       // Text(
                          //       //   DELIVERY_CHARGE,
                          //       // ),
                          //       Spacer(),
                          //       Text("Rs " + "150")
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 0, right: 0, top: 8, bottom: 8),
                          //   child: Row(
                          //     children: <Widget>[
                          //       Text(
                          //         'tax'.tr + "(16 %)",
                          //       ),
                          //       Spacer(),
                          //       Text("Rs " +
                          //           (sumPrice * 16 / 100).toStringAsFixed(2))
                          //     ],
                          //   ),
                          // ),
                          Obx(() {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 8, bottom: 8),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'promo_code'.tr + " " + "discount".tr,
                                  ),
                                  Spacer(),
                                  checkoutController.promoCodeDiscount==''?
                                  check.value
                                      ? Text("Rs " +
                                          (CouponPrice.discount
                                              .toString()
                                              .split('.')[0]))
                                      : Text("Rs " + "0")
                                  :Text("Rs "+ checkoutController.promoCodeDiscount.value),
                                  checkoutController.discountType.value.toString() =='0'
                                  ? Text('%') : Text('')
                                ],
                              ),
                            );
                          }),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8, left: 0, right: 0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'total_price'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Obx(() {
                                  return RichText(
                                    text: TextSpan(
                                        text: "Rs ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffF58323)),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${((sumPrice) - (CouponPrice.discount.value)).toStringAsFixed(2)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    color: Color(0xffF58323),
                                                  )),

                                        ]),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  orderItem(Cart st) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Expanded(
              flex: 5,
              child: Text(
                "${st.name}",
              )),
          Expanded(
              flex: 1,
              child: Text(
                "${st.qty}",
                textAlign: TextAlign.end,
              )),
          Expanded(
              flex: 2,
              child: Text(
                "${st.price!.split('.')[0]}",
                textAlign: TextAlign.end,
              )),
          Expanded(
              flex: 2,
              child: Text(
                "${(double.parse(st.price!) * double.parse(st.qty.toString())).toString().split('.')[0]}",
                textAlign: TextAlign.end,
              )),
        ],
      ),
    );
  }
}

class Address extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateAddress();
  }
}

class StateAddress extends State<Address> with TickerProviderStateMixin {
  // List<GetAddress> addressList = [];
  // void fetchData() async{
  //    await getAddressController("13");
  // }

  @override
  void initState() {
    super.initState();
    isLoadingAddress.value = true;
    final HomeController homeController = Get.find<HomeController>();
    print("User Id ${homeController.userId}");
    homeController.update();
    print("is loading is " + isLoadingAddress.value.toString());
    getAddressController(homeController.userId.toString());
    // fetchData();
    print("Get Address Api called");
    // addressList.clear();
  }

  @override
  void dispose() {
    getAddress.value = [];
    print("address data Dispose: " + getAddress.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Expanded(
            child: isLoadingAddress.isTrue
                ? Center(child: Container(child: CircularProgressIndicator()))
                : getAddress.length == 0
                    ? Text(NOADDRESS)
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: getAddress.length,
                        itemBuilder: (BuildContext context, int index) {
                          // print(getAddress[index]["city"]);
                          // print("default***b${addressList[index].isDefault}***${addressList[index].name}");
                          print("default address : " +
                              getAddress[index]["city"].toString());
                          return addressItem(index);
                        }),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewAddressScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
              ),
              child: Ink(
                decoration: BoxDecoration(
                    // gradient: MillionMartgradient,
                    color: Color(0xFFF68628)),
                child: Container(
                  decoration: BoxDecoration(
                      // shape: StadiumBorder(),
                      ),
                  height: 40.0,
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),

                  // min sizes for Material buttons
                  alignment: Alignment.center,
                  child: Text(
                    'add_address'.tr,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }

  addressItem(int index) {
    return Card(
      child: RadioListTile(
          selectedTileColor: primaryColor,
          value: (index),
          groupValue: selectedAddress,
          onChanged: (int? val) {
            selectedAddress = val!;
            city = getAddress[index]["city"];
            country = getAddress[index]["country"];
            address = getAddress[index]["address"];
            setState(() {});
            print("selected Address is : " + city.toString());
          },
          secondary: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              selectedAddress = index;
              setState(() {});
              _displayTextInputDialog(context);
            },
          ),
          title: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        getAddress[index]["city"] ?? "" + "  ",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: lightgrey,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(3),
                      child: Text(
                        getAddress[index]["country"] ?? "",
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          isThreeLine: false,
          subtitle: Text(
            getAddress[index]["address"] ??
                "" + ", " + getAddress[index]["town"] ??
                "" + ", " + ", " + ", \n",
          )),
    );
  }
}

class Payment extends StatefulWidget {
  Payment();

  @override
  State<StatefulWidget> createState() {
    return StatePayment();
  }
}

int _paySelected = 0;
int _shippingSelected = 0;
var shippingMethodsPrice = 0.obs;
var TotalBill = 0.0.obs;

class StatePayment extends State<Payment> with TickerProviderStateMixin {
  late String allowDay, startingDate;
  late bool cod, paypal, razorpay, paumoney, paystack, flutterwave;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // late Animation buttonSqueezeanimation;
  // late AnimationController buttonController;
  var _shippingMethods = [].obs;
  var _payMethods = [].obs;

  void _getShippingMethods() async {
    _shippingMethods.value = await shippingMethodsController();
    _payMethods.value = await paymentMethodsController();
    print("Payment methods are " + _payMethods.toString());
    print("Shippint Methods are " + _shippingMethods.toString());
  }

  @override
  void initState() {
    super.initState();
    _getShippingMethods();
  }

  @override
  void dispose() {
    // buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          key: _scaffoldKey,
          body: _payMethods.isEmpty
              ? Center(child: Container(child: CircularProgressIndicator()))
              : SingleChildScrollView(
                  child: ScreenTypeLayout(
                    mobile: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Card(
                        //   // child: Column(
                        //   //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   //   mainAxisSize: MainAxisSize.min,
                        //   //   children: [
                        //   //     Padding(
                        //   //       padding: const EdgeInsets.all(8.0),
                        //   //       child: Text(
                        //   //         PREFERED_TIME,
                        //   //         style: Theme.of(context).textTheme.headline6,
                        //   //       ),
                        //   //     ),
                        //   //     // Container(
                        //   //     //   height: 80,
                        //   //     //   padding: EdgeInsets.symmetric(horizontal: 10),
                        //   //     //   child: ListView.builder(
                        //   //     //       shrinkWrap: true,
                        //   //     //       scrollDirection: Axis.horizontal,
                        //   //     //       itemCount: 5,
                        //   //     //       itemBuilder: (context, index) {
                        //   //     //         return dateCell(index);
                        //   //     //       }),
                        //   //     // ),
                        //   //     Divider(),
                        //   //   ],
                        //   // ),
                        // ),
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "shipping_methods".tr,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _shippingMethods.length,
                                  itemBuilder: (context, index) {
                                    return shippingMethods(index);
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'payment_methods'.tr,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 2,
                                  itemBuilder: (context, index) {
                                    return paymentItem(index);
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  var isselect = false;
  var selsectindex = 0;

  // dateCell(int index) {
  //   var date = DateTime.now();
  //   DateTime today = (date);
  //   return InkWell(
  //     child: Container(
  //       decoration: isselect == false
  //           ? BoxDecoration(
  //               border: Border.all(color: Color(0xffF58323)),
  //               borderRadius: BorderRadius.circular(10),
  //               color: selsectindex != index ? Colors.white : Color(0xffF58323))
  //           : BoxDecoration(
  //               border: Border.all(color: Color(0xffF58323)),
  //               borderRadius: BorderRadius.circular(10),
  //               color:
  //                   selsectindex != index ? Colors.white : Color(0xffF58323)),
  //       padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
  //       margin: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             DateFormat('EEE').format(today.add(Duration(days: index))),
  //             style: TextStyle(color: Colors.black54),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(5.0),
  //             child: Text(
  //               DateFormat('dd').format(today.add(Duration(days: index))),
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   color: selsectindex == index ? Colors.white : primary),
  //             ),
  //           ),
  //           Text(
  //             DateFormat('MMM').format(today.add(Duration(days: index))),
  //             style: TextStyle(color: Colors.black54),
  //           ),
  //         ],
  //       ),
  //     ),
  //     onTap: () {
  //       setState(() {
  //         selsectindex = index;
  //         print('SELSECTINDEX: $selsectindex');
  //         isselect != true ? isselect = true : isselect = false;
  //       });
  //     },
  //   );
  // }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 1.0,
    ));
  }

  Widget timeSlotItem(int index) {
    var selectedTime;
    return RadioListTile(
      dense: true,
      value: (index),
      groupValue: selectedTime,
      onChanged: (val) {},
      title: Text(
        "",
        style: TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  int selectedRadioTile = 0;

  Widget shippingMethods(int index) {
    return
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        RadioListTile(
      value: (index),
      groupValue: _shippingSelected,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _shippingMethods[index].title,
          ),
          Spacer(),
          Card(
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Rs : " + _shippingMethods[index].price,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(_shippingMethods[index].subtitle),
      onChanged: (int? index) {
        setState(() {
          _shippingSelected = index!;
          shippingMethodsPrice.value = int.parse(_shippingMethods[index].price);
          // CartController _controller = Get.find<CartController>();
          // var bill = (((sumtotal +(sumtotal * 16 / 100)+ shippingMethodsPrice.value) - (CouponPrice.discount.value)));
          // _controller.totalBill.value = bill;
          print(shippingMethodsPrice.value);
          // selectedRadioTile = 0;
        });

        print("Radio Tile pressed $index");
        // setSelectedRadioTile(index);
      },
      activeColor: Color(0xFFF68628),
      selected: false,
    );
  }

  Widget paymentItem(int index) {
    return
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        RadioListTile(
      value: (index),
      groupValue: _paySelected,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _payMethods[index]['title'],
          ),
          Spacer(),
        ],
      ),
      // subtitle: Text("Radio 2 Subtitle"),
      onChanged: (int? value) {
        setState(() {
          _paySelected = value!;
        });

        print("Radio Tile pressed $index");
        // setSelectedRadioTile(index);
      },
      activeColor: Color(0xFFF68628),
      selected: false,
    );
  }
}

Future<void> _displayTextInputDialog(BuildContext context) async {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure to delete this address!!'),
          actions: <Widget>[
            TextButton(
              // color: Colors.red,
              // textColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(), primary: primaryColor),
              child: Text('Yes'),
              onPressed: () {
                deleteAddressController(
                    getAddress[selectedAddress]["id"].toString());
                selectedAddress = 0;

              },
            ),
          ],
        );
      });
}
