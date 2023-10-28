import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/hexColors.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/CheckoutController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/ShareCartController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/VoiceCommandsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/cartController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/NoInternet.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/ProductDetail/MillionMartCheckout.dart';
import 'package:millionmart_cleaned/MillionMart/database/database.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MillionMartHome.dart';
import 'MillionMartLogin.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';
import 'MillionMartOrders.dart';
import 'MillionMartpHomeTab.dart';

class MillionMartCart extends StatefulWidget {
  @override
  _MillionMartCartState createState() => _MillionMartCartState();
}

class _MillionMartCartState extends State<MillionMartCart>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final DatabaseHelper _dBcartManager = new DatabaseHelper();

  late List<Cart> cartData;

  CartController cartController = Get.put(CartController());
  ShareCartController shareCartController = Get.put(ShareCartController());
  bool _animate = false;
  VoiceCommandsController _voiceCommandsController =
      Get.put(VoiceCommandsController());

  initializeVoiceCommands() {
    setState(() {
      _animate = !_animate;
    });
    _voiceCommandsController.listen();
    Timer(
      Duration(
        seconds: 4,
      ),
      () {
        print(
            'Voice command result in UI: ${_voiceCommandsController.speechText.value}');
        if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('clear') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart')) {
          _dBcartManager.deleteWholeCart();
          cartController.getCartCount();
          setState(() {});
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('clear') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('card')) {
          _dBcartManager.deleteWholeCart();
          cartController.getCartCount();
          setState(() {});
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('khali') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('card')) {
          _dBcartManager.deleteWholeCart();
          cartController.getCartCount();
          setState(() {});
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('khali') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart')) {
          _dBcartManager.deleteWholeCart();
          cartController.getCartCount();
          setState(() {});
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('kali') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart')) {
          _dBcartManager.deleteWholeCart();
          cartController.getCartCount();
          setState(() {});
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('khali') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('basket')) {
          _dBcartManager.deleteWholeCart();
          cartController.getCartCount();
          setState(() {});
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('kali') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('basket')) {
          _dBcartManager.deleteWholeCart();
          cartController.getCartCount();
          setState(() {});
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('tokri') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('khali')) {
          _dBcartManager.deleteWholeCart();
          cartController.getCartCount();
          setState(() {});
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('tokri') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('kali')) {
          _dBcartManager.deleteWholeCart();
          cartController.getCartCount();
          setState(() {});
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('track') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('order')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Orders()),
          );
        } else if (_voiceCommandsController.speechText.value
            .toLowerCase()
            .contains('homepage')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartHomeTab(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
            .toLowerCase()
            .contains('checkout')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCheckout(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('order') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('complete')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCheckout(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('order') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('mukamal')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCheckout(),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: 'No matching command');
        }
        _voiceCommandsController.speechText.value = "";
        setState(() {
          _animate = !_animate;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    cartController.getCartCount();
    print("getx Class");
    // print("Database Items Added "+cartController.cartCoount.length.toString());
    cartController.getCartCount();
    // print("cart DB data checked");
    fetchData();
  }

  @override
  void dispose() {
    _dBcartManager.getCartCount();
    cartController.getCartCount();
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
        style: TextStyle(color: Color(0xFF0A3966)),
      ),
      backgroundColor: Color(0xFFAED0F3),
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      elevation: 5,
      actions: [
        GestureDetector(
          onTap: () {
            TextEditingController sharecartText = new TextEditingController();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("enter_sender_email".tr),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: sharecartText,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.share,
                            ),
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 40, maxHeight: 20),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                7.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text('receive_cart'.tr),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel".tr,
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: primaryColor, shape: StadiumBorder()),
                      onPressed: () {
                        if (sharecartText.text.isEmpty) {
                          Get.snackbar(
                            "error".tr,
                            "fullFields".tr,
                            backgroundColor: notificationBackground,
                            colorText: notificationTextColor,
                          );
                        } else {
                          shareCartController.userData();
                          Timer(
                            Duration(seconds: 2),
                              (){
                                var cart = shareCartController
                                    .recieveCart(sharecartText.text);
                                Get.log(cart.toString().length.toString());

                                setState(() {
                                  cartController.getCartCount();
                                  // print("cart DB data checked");
                                  fetchData();
                                });
                              }
                          );
                          // List cart = [];
                          // var cartData =
                          //     _dBcartManager.getCartData();
                          // cartData.then((value) =>
                          //     value.forEach((element) {
                          //       Map data = {
                          //         "name": element.name,
                          //         "image": element.image,
                          //         "price": element.price,
                          //         "previous_price": element
                          //             .previous_price,
                          //         "qty": element.qty,
                          //         "size": element.size,
                          //         "sub_total":
                          //             element.sub_total,
                          //         "color": element.color,
                          //         "item": element.item,
                          //         "size_key":
                          //             element.size_key,
                          //         "size_price":
                          //             element.size_price,
                          //         "size_qty":
                          //             element.size_qty,
                          //         "stock": element.stock,
                          //       };
                          //       cart.add(data);
                          //     }));

                          // print("Cart List");
                          // Timer(Duration(seconds: 2), () {
                          //   Get.log(cart.toString());
                          //   shareCartController.shareCart(
                          //       cart, sharecartText.text);
                          // });
                        }
                      },
                      child: Text('receive'.tr),
                    )
                  ],
                );
              },
            );
          },
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Color(0xFF0A3966)),
                onPressed: () {
                  // TextEditingController sharecartText =
                  //     new TextEditingController();
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AlertDialog(
                  //       content: Container(
                  //         height: 80,
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text("enter_sender_email".tr),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             TextFormField(
                  //               controller: sharecartText,
                  //               decoration: InputDecoration(
                  //                 prefixIcon: Icon(
                  //                   Icons.share,
                  //                 ),
                  //                 prefixIconConstraints:
                  //                     BoxConstraints(minWidth: 40, maxHeight: 20),
                  //                 isDense: true,
                  //                 contentPadding: EdgeInsets.symmetric(
                  //                     horizontal: 10, vertical: 12),
                  //                 border: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.circular(
                  //                     7.0,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       title: Text('receive_cart'.tr),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () {
                  //             Navigator.pop(context);
                  //           },
                  //           child: Text("Cancel".tr),
                  //         ),
                  //         TextButton(
                  //           onPressed: () {
                  //             if (sharecartText.text.isEmpty) {
                  //               Get.snackbar(
                  //                 "Error",
                  //                 "Fill the field.",
                  //                 backgroundColor: notificationBackground,
                  //               );
                  //             } else {
                  //               var cart = shareCartController
                  //                   .recieveCart(sharecartText.text);
                  //               Get.log(cart.toString().length.toString());
                  //               // List cart = [];
                  //               // var cartData =
                  //               //     _dBcartManager.getCartData();
                  //               // cartData.then((value) =>
                  //               //     value.forEach((element) {
                  //               //       Map data = {
                  //               //         "name": element.name,
                  //               //         "image": element.image,
                  //               //         "price": element.price,
                  //               //         "previous_price": element
                  //               //             .previous_price,
                  //               //         "qty": element.qty,
                  //               //         "size": element.size,
                  //               //         "sub_total":
                  //               //             element.sub_total,
                  //               //         "color": element.color,
                  //               //         "item": element.item,
                  //               //         "size_key":
                  //               //             element.size_key,
                  //               //         "size_price":
                  //               //             element.size_price,
                  //               //         "size_qty":
                  //               //             element.size_qty,
                  //               //         "stock": element.stock,
                  //               //       };
                  //               //       cart.add(data);
                  //               //     }));
                  //
                  //               // print("Cart List");
                  //               // Timer(Duration(seconds: 2), () {
                  //               //   Get.log(cart.toString());
                  //               //   shareCartController.shareCart(
                  //               //       cart, sharecartText.text);
                  //               // });
                  //             }
                  //           },
                  //           child: Text('receive'.tr),
                  //         )
                  //       ],
                  //     );
                  //   },
                  // );
                },
              ),
              Text(
                "receive_cart".tr,
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
              SizedBox(
                width: 4,
              ),
            ],
          ),
        )
      ],
    );
  }

  var count = 1.obs;

  Widget listItem(Cart st) {
    // orgPrice = orgPrice + count.value;
    void increment(String pr) {
      if (st.qty < maxItemsCart) {
        print("Increment Function");
        st.qty++;
        sumPrice = sumPrice + int.parse(pr);
      } else {
        Fluttertoast.showToast(msg: 'Max items can be $maxItemsCart only');
      }
    }

    void decrement(String pr) {
      print("Decrement Function");
      if (st.qty > 1) {
        print("Inside Decrement if");
        print(st.qty);
        st.qty--;
        print("Decrement Done ");
        print(st.qty);
        sumPrice = sumPrice - int.parse(pr);
      } else {
        Fluttertoast.showToast(msg: 'Min item can be 1');
      }
    }

    print("Cart Data in UI" + st.qty.toString());
    // Get.log(st.item!.toString());

    return Card(
      elevation: 0.1,
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: st.image!,
            height: 90.0,
            width: 90.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            '${st.name}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.black),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 8),
                          child: Icon(
                            Icons.close,
                            size: 13,
                          ),
                        ),
                        onTap: () async {
                          await _dBcartManager.deleteProduct(st.name!);
                          await cartController.getCartCount();
                          await fetchData();
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        // Icon(
                        //   Icons.star,
                        //   color: Colors.yellow,
                        //   size: 12,
                        // ),
                        // Text(
                        //   " ",
                        //   style: Theme.of(context).textTheme.overline,
                        // ),
                        // Text(
                        //   " (" + cartList[index]['noOfRating'] + ")",
                        //   style: Theme.of(context).textTheme.overline,
                        // )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${st.previous_price!.split('.')[0]}',
                        style: Theme.of(context).textTheme.overline!.copyWith(
                              decoration: TextDecoration.lineThrough,
                              letterSpacing: 0.7,
                            ),
                      ),
                      Text(
                        '${st.price!.split('.')[0]}',
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            splashColor: primaryColor.withOpacity(0.1),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 8,
                                top: 8,
                                bottom: 8,
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 12,
                                color: Colors.grey,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            onTap: () async {
                              decrement(st.price!);
                              await _dBcartManager.countDecrement(st.name!,
                                  st.qty, st.qty * int.parse(st.price!));
                              await cartController.getCartCount();
                              print("Count - is " + st.qty.toString());
                            },
                          ),
                          // Obx(() {
                          //   // orgPrice = orgPrice +count.value;
                          //   return
                          Text(st.qty.toString()),
                          // }),
                          // Text(
                          //   cartList[index]['qty'],
                          //   style: Theme.of(context).textTheme.caption,
                          // ),
                          InkWell(
                            splashColor: primaryColor.withOpacity(0.1),
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: Icon(
                                Icons.add,
                                size: 12,
                                color: Colors.grey,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            onTap: () async {
                              increment(st.price!);
                              await _dBcartManager.countIncrement(st.name!,
                                  st.qty, st.qty * int.parse(st.price!));
                              await cartController.getCartCount();
                              print("Count + is " + st.qty.toString());
                            },
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              color: HexColor(st.color!),
                              // color: Colors.red,
                              // border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      // Obx(() {
                      // return
                      Text(
                        '${st.qty * int.parse(st.price!)}',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Color(0xFFF68628)),
                      ),
                      // })
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  cartEmpty() {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noCartImage(context),
          noCartText(context),
          noCartDec(context),
          shopNow()
        ]),
      ),
    );
  }

  noCartImage(BuildContext context) {
    return Lottie.asset(
      'assets/svgs/emptyCart.json',
      fit: BoxFit.contain,
    );
  }

  noCartText(BuildContext context) {
    return Container(
        child: Text(NO_CART.tr,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: primaryColor, fontWeight: FontWeight.normal)));
  }

  noCartDec(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
      child: Text(CART_DESC.tr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: lightblack,
                fontWeight: FontWeight.normal,
              )),
    );
  }

  shopNow() {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: CupertinoButton(
        child: Container(
            width: deviceWidth * 0.7,
            height: 45,
            alignment: FractionalOffset.center,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryLight3, primaryLight],
                  stops: [0, 1]),
              borderRadius: new BorderRadius.all(const Radius.circular(50.0)),
            ),
            child: Text(SHOP_NOW.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: white, fontWeight: FontWeight.normal))),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MillionMartHome()),
              ModalRoute.withName('/'));
        },
      ),
    );
  }

  back() {
    return BoxDecoration(color: Color(0xFFE0ECF8)
        // gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryLight2, primaryLight3], stops: [0, 1]),
        );
  }

  var sumPrice = 0.obs;
  List<Cart> sumPriceData = <Cart>[].obs;

  Future<void> fetchData() async {
    sumPriceData = await _dBcartManager.getCartData();
    sumPrice.value = 0;
    for (int c = 0; c < sumPriceData.length; c++) {
      print(sumPrice.value);
      print(sumPriceData.length);
      print("price" + sumPriceData[c].price!);
      // print("Products Prices ${sumPrice + int.parse(sumPriceData[c].price)* sumPriceData[c].qty}");
      sumPrice.value = sumPrice.value +
          (int.parse(sumPriceData[c].price!) * sumPriceData[c].qty);
      // sumPrice =++ total;
      print('sumPrice $c ' + sumPrice.value.toString());
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel".tr,
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MillionMartCheckout(),
        //     ));
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("LogIn Now"),
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        // shape: StadiumBorder()
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              // Constants.prefs.setBool("loggedIn", false);
              return MillionMartLogin();
            },
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Information"),
      content: Text(
          "You are not logged in. Please login first for checkout... Thanks"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  NetworkController networkController = Get.put(NetworkController());

  @override
  Widget build(BuildContext context) {
    // print('data count from this class ${daata}');
    // sumprice=0;
    // fetchData();
    print("Cart Value " + cartController.cartCoount.length.toString());
    return Obx(() {
      return networkController.networkStatus.value == false
          ? NoInternetScreen()
          : cartController.cartCoount.length == 0
              ? Scaffold(
                  appBar: getAppBar('cart'.tr, context),
                  body: Center(
                    child: cartEmpty(),
                  ),
                )
              : SafeArea(
                  child: Scaffold(
                      floatingActionButton: AvatarGlow(
                        glowColor: Colors.blue,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        animate: _animate,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        endRadius: 40.0,
                        child: FloatingActionButton(
                          elevation: 10.0,
                          tooltip: "Speak to perform actions.",
                          backgroundColor: Color(0xFFAED0F3),
                          child: Icon(
                            Icons.settings_voice_rounded,
                            color: Color(0xFF0A3966),
                          ),
                          onPressed: () {
                            initializeVoiceCommands();
                          },
                        ),
                      ),
                      key: _scaffoldKey,
                      appBar: getAppBar('cart'.tr, context),
                      persistentFooterButtons: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 8.0.h,
                              bottom: 0.0.h,
                              left: 32.w,
                              right: 32.w),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'original_price'.tr,
                              ),
                              Spacer(),
                              Obx(() {
                                return Text("Rs " + sumPrice.toString());
                              })
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 35, right: 35, top: 8, bottom: 8),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text(
                        //         DELIVERY_CHARGE,
                        //       ),
                        //       Spacer(),
                        //       Text("Rs " + "150")
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 35, right: 35, top: 8, bottom: 8),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text(
                        //         'tax'.tr + "(16%)",
                        //       ),
                        //       Spacer(),
                        //       Obx(() {
                        //         return Text("Rs " +
                        //             "${(sumPrice * 16 / 100).toStringAsFixed(0)}");
                        //       })
                        //     ],
                        //   ),
                        // ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8, left: 35, right: 35),
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
                                return Text(
                                  "Rs " +
                                      (sumPrice.toDouble()).toStringAsFixed(0),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF68628)),
                                );
                              })
                            ],
                          ),
                        ),
                        Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFE0ECF8),
                            // gradient: MillionMartgradient,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 10)
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: ElevatedButton(
                                  onPressed: () {
                                    cartController.getTotal();
                                    //Checked
                                    CheckoutController checkoutController = Get.put(CheckoutController());

                                    Constants.prefs.then((value) {
                                      print(value.getBool("loggedIn"));
                                      value.getBool("loggedIn") == true
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MillionMartCheckout(),
                                              ),
                                            )
                                          : showAlertDialog(context);
                                    });
                                    // Constants.prefs.getBool("loggedIn") == true
                                    //     ? Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) => MillionMartCheckout(),
                                    //         ),
                                    //       )
                                    //     : showAlertDialog(context);
                                  },
                                  child: Row(
                                    // textBaseline: TextBaseline.alphabetic,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_cart_outlined),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        'process_to'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.sp),
                                      )
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF0C3A66)),
                                ),
                              ),
                              SizedBox(
                                width: 12.h,
                              ),
                              Expanded(
                                flex: 4,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final SharedPreferences _prefs =
                                        await Constants.prefs;
                                    bool? loggedIn = _prefs.getBool('loggedIn');
                                    if (loggedIn == true) {
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "share_friends".tr,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Divider(),
                                                ElevatedButton(
                                                  child: Icon(
                                                    Icons.share,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                    TextEditingController
                                                        sharecartText =
                                                        new TextEditingController();
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            height: 80,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "enter_receiver_email"
                                                                        .tr),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      sharecartText,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    prefixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .share,
                                                                    ),
                                                                    prefixIconConstraints: BoxConstraints(
                                                                        minWidth:
                                                                            40,
                                                                        maxHeight:
                                                                            20),
                                                                    isDense:
                                                                        true,
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            12),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        7.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          title: Text(
                                                            'share_cart'.tr,
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  "Cancel".tr),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                if (sharecartText
                                                                    .text
                                                                    .isEmpty) {
                                                                  Get.snackbar(
                                                                    "error".tr,
                                                                    "fullFields"
                                                                        .tr,
                                                                    backgroundColor:
                                                                        notificationBackground,
                                                                    colorText:
                                                                        notificationTextColor,
                                                                  );
                                                                } else {
                                                                  List<String>
                                                                      cart = [];
                                                                  // List cart = [];
                                                                  var cartData =
                                                                      _dBcartManager
                                                                          .getCartData();

                                                                  cartData.then(
                                                                      (value) =>
                                                                          value.forEach(
                                                                              (element) {
                                                                            print("in loop");
                                                                            print(element);
                                                                            cart.add("${element.slug}");
                                                                            print(cart);
                                                                            // Map data = {
                                                                            //   "name":
                                                                            //       "\"${element.name}\"",
                                                                            //   "image":
                                                                            //       "\"${element.image}\"",
                                                                            //   "price": element.price,
                                                                            //   "previous_price": element
                                                                            //       .previous_price,
                                                                            //   "qty": element.qty,
                                                                            //   "size": element.size,
                                                                            //   "sub_total":
                                                                            //       element.sub_total,
                                                                            //   "color": element.color,
                                                                            //   "item":
                                                                            //       "{${element.item}}",
                                                                            //   "size_key":
                                                                            //       element.size_key,
                                                                            //   "size_price":
                                                                            //       element.size_price,
                                                                            //   "size_qty":
                                                                            //       element.size_qty,
                                                                            //   "stock": element.stock,
                                                                            // };
                                                                            // cart.add(data);
                                                                          }));

                                                                  print(
                                                                      "Cart List");
                                                                  Timer(
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                      () async {
                                                                    await shareCartController
                                                                        .userData();
                                                                    Get.log(cart
                                                                        .toString());
                                                                    shareCartController.shareCart(
                                                                        cart,
                                                                        sharecartText
                                                                            .text);
                                                                    Timer(
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                        () {
                                                                      if (shareCartController
                                                                              .successfully
                                                                              .value ==
                                                                          "successfully") {
                                                                        print(
                                                                            "Sharing done");
                                                                        Get.back();
                                                                        showModalBottomSheet(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Container(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text("You have successfully shared your cart to ${sharecartText.text}, let them know."),
                                                                                  Divider(),
                                                                                  Text(
                                                                                    "Share on social media",
                                                                                    style: TextStyle(
                                                                                      fontSize: 18,
                                                                                    ),
                                                                                  ),
                                                                                  Divider(),
                                                                                  Row(
                                                                                    children: [
                                                                                      Column(
                                                                                        children: [
                                                                                          IconButton(
                                                                                            onPressed: () {
                                                                                              TextEditingController whatsappNumber = new TextEditingController();
                                                                                              showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return AlertDialog(
                                                                                                    content: Container(
                                                                                                      height: 75,
                                                                                                      child: Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Text("Enter whatsapp number"),
                                                                                                          SizedBox(
                                                                                                            height: 10,
                                                                                                          ),
                                                                                                          TextFormField(
                                                                                                            controller: whatsappNumber,
                                                                                                            decoration: InputDecoration(
                                                                                                              prefixIcon: Icon(
                                                                                                                Icons.share,
                                                                                                              ),
                                                                                                              prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
                                                                                                              isDense: true,
                                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                                                                                              border: OutlineInputBorder(
                                                                                                                borderRadius: BorderRadius.circular(
                                                                                                                  7.0,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    title: Text(
                                                                                                      "WhatsApp",
                                                                                                    ),
                                                                                                    actions: [
                                                                                                      TextButton(
                                                                                                        onPressed: () {
                                                                                                          Navigator.pop(context);
                                                                                                        },
                                                                                                        child: Text("Cancel".tr),
                                                                                                      ),
                                                                                                      TextButton(
                                                                                                        onPressed: () {
                                                                                                          if (whatsappNumber.text.isEmpty) {
                                                                                                            Get.snackbar(
                                                                                                              "error".tr,
                                                                                                              "fullFields".tr,
                                                                                                              backgroundColor: notificationBackground,
                                                                                                              colorText: notificationTextColor,
                                                                                                            );
                                                                                                          } else {
                                                                                                            FlutterSocialContentShare.shareOnWhatsapp('${whatsappNumber.text}', 'Someone shared a cart with you, receive cart by going to cart page enter this Email ${shareCartController.userId} to receive cart.');
                                                                                                          }
                                                                                                        },
                                                                                                        child: Text('Share'),
                                                                                                      )
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            },
                                                                                            icon: Image.asset(
                                                                                              'assets/icon/whatsapp-new.png',
                                                                                              height: 70,
                                                                                              width: 70,
                                                                                            ),
                                                                                          ),
                                                                                          Text("WhatsApp"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      Column(
                                                                                        children: [
                                                                                          IconButton(
                                                                                            onPressed: () {
                                                                                              Clipboard.setData(
                                                                                                ClipboardData(text: "Someone shared a cart with you, receive cart by going to cart page enter this unique key ${shareCartController.userId} to receive cart."),
                                                                                              );
                                                                                              Get.back();
                                                                                            },
                                                                                            icon: Icon(Icons.content_copy_outlined),
                                                                                          ),
                                                                                          Text("Copy to clipboard"),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      } else {
                                                                        Get.back();
                                                                        Get.snackbar(
                                                                          "error"
                                                                              .tr,
                                                                          "try_again"
                                                                              .tr,
                                                                          backgroundColor:
                                                                              notificationBackground,
                                                                          colorText:
                                                                              notificationTextColor,
                                                                        );
                                                                        print(shareCartController
                                                                            .successfully
                                                                            .value);
                                                                      }
                                                                    });
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                  'share'.tr),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: CircleBorder(),
                                                    primary: primaryColor,
                                                    padding: EdgeInsets.all(16),
                                                  ),
                                                ),
                                                // Divider(),
                                                // Text(
                                                //   "Share on social media",
                                                //   style: TextStyle(
                                                //     fontSize: 18,
                                                //   ),
                                                // ),
                                                // Divider(),
                                                // Row(
                                                //   children: [
                                                //     Column(
                                                //       children: [
                                                //         IconButton(
                                                //           onPressed: () {
                                                //             TextEditingController
                                                //                 whatsappNumber =
                                                //                 new TextEditingController();
                                                //             showDialog(
                                                //               context: context,
                                                //               builder:
                                                //                   (BuildContext context) {
                                                //                 return AlertDialog(
                                                //                   content: Container(
                                                //                     height: 75,
                                                //                     child: Column(
                                                //                       mainAxisAlignment:
                                                //                           MainAxisAlignment
                                                //                               .start,
                                                //                       crossAxisAlignment:
                                                //                           CrossAxisAlignment
                                                //                               .start,
                                                //                       children: [
                                                //                         Text(
                                                //                             "Enter whatsapp number"),
                                                //                         SizedBox(
                                                //                           height: 10,
                                                //                         ),
                                                //                         TextFormField(
                                                //                           controller:
                                                //                               whatsappNumber,
                                                //                           decoration:
                                                //                               InputDecoration(
                                                //                             prefixIcon:
                                                //                                 Icon(
                                                //                               Icons.share,
                                                //                             ),
                                                //                             prefixIconConstraints:
                                                //                                 BoxConstraints(
                                                //                                     minWidth:
                                                //                                         40,
                                                //                                     maxHeight:
                                                //                                         20),
                                                //                             isDense: true,
                                                //                             contentPadding:
                                                //                                 EdgeInsets.symmetric(
                                                //                                     horizontal:
                                                //                                         10,
                                                //                                     vertical:
                                                //                                         12),
                                                //                             border:
                                                //                                 OutlineInputBorder(
                                                //                               borderRadius:
                                                //                                   BorderRadius
                                                //                                       .circular(
                                                //                                 7.0,
                                                //                               ),
                                                //                             ),
                                                //                           ),
                                                //                         ),
                                                //                       ],
                                                //                     ),
                                                //                   ),
                                                //                   title: Text(
                                                //                     "Whatsapp",
                                                //                   ),
                                                //                   actions: [
                                                //                     TextButton(
                                                //                       onPressed: () {
                                                //                         Navigator.pop(
                                                //                             context);
                                                //                       },
                                                //                       child:
                                                //                           Text("Cancel"),
                                                //                     ),
                                                //                     TextButton(
                                                //                       onPressed: () {
                                                //                         if (whatsappNumber
                                                //                             .text
                                                //                             .isEmpty) {
                                                //                           Get.snackbar(
                                                //                             "Error",
                                                //                             "Fill the field.",
                                                //                             backgroundColor: Colors
                                                //                                 .orange
                                                //                                 .withOpacity(
                                                //                                     0.5),
                                                //                           );
                                                //                         } else {
                                                //                           FlutterSocialContentShare
                                                //                               .shareOnWhatsapp(
                                                //                                   '${whatsappNumber.text}',
                                                //                                   'Receive cart by going to cart page enter this unique key.');
                                                //                         }
                                                //                       },
                                                //                       child:
                                                //                           Text('Share'),
                                                //                     )
                                                //                   ],
                                                //                 );
                                                //               },
                                                //             );
                                                //           },
                                                //           icon: Image.asset(
                                                //             'assets/icon/whatsapp-new.png',
                                                //             height: 70,
                                                //             width: 70,
                                                //           ),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //     SizedBox(
                                                //       width: 10,
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Login to share cart");
                                    }
                                  },
                                  child: Row(
                                    // textBaseline: TextBaseline.alphabetic,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.share,
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Text(
                                        "share_cart".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.sp),
                                      )
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFFF68628)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      body:
                          // widget.CC==0? SafeArea(child: cartEmpty()):
                          Container(
                        height: MediaQuery.of(context).size.height * 0.569.h,
                        child: FutureBuilder(
                          future: _dBcartManager.getCartData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              cartData = snapshot.data as List<Cart>;

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: cartData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // Variable.counter = studlist.length;
                                  Cart st = cartData[index];
                                  print("qty in DB " + st.qty.toString());

                                  // sumprice=sumprice+ int.parse(st.price);
                                  //
                                  //   print("price is ::::::::::::::::::");
                                  //   print(sumprice);
                                  return listItem(st);
                                },
                              );
                            }
                            return SafeArea(
                                child: Center(
                              child: CircularProgressIndicator(),
                            ));
                          },
                        ),
                      )),
                );
      // :Scaffold(body: Center(child: cartEmpty(),),);
    });
  }
}
