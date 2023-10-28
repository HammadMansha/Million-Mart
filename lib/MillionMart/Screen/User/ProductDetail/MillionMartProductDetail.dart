import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/hexColors.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/RequestBargainController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/VoiceCommandsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/productDetailController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartHome.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartQ&AScreen.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/NoInternet.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/ProductDetail/MillionMartCheckout.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/ProductDetail/fullviewImage.dart';
import 'package:millionmart_cleaned/MillionMart/database/database.dart';
import 'package:millionmart_cleaned/MillionMart/models/RequestBargainModelClass.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../MillionMartCart.dart';
import '../MillionMartLogin.dart';
import 'package:resize/resize.dart';
import '../MillionMartOrders.dart';
import '../MillionMartReport.dart';
import '../MillionMartTrackOrder.dart';
import '../MillionMartpHomeTab.dart';
import 'package:http/http.dart' as http;


var buyNow = false.obs;

class MillionMartProductDetail extends StatefulWidget {
  MillionMartProductDetail(
      {Key? key,
      required this.imgurl,
      required this.tag,
      required this.slug,
      required this.productController})
      : super(key: key);
  final String imgurl, tag, slug;
  final ProductController productController;

  @override
  _MillionMartProductDetailState createState() =>
      _MillionMartProductDetailState();
}

class _MillionMartProductDetailState extends State<MillionMartProductDetail>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    buyNow.value = false;
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProductController productController = Get.find<ProductController>();
  VoiceCommandsController _voiceCommandsController =
      Get.find<VoiceCommandsController>();

  displayTextInputDialog(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Reference Product Detail'),
          content: Container(
            height: 100,
            child: Column(
              children: [
                TextField(
                  controller: productController.url,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.link,
                      ),
                      // errorText: '',
                      hintText: "Enter Url",
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 40, maxHeight: 20),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0))),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: productController.price,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.price_check,
                      ),
                      // errorText: '',
                      hintText: "Enter Price",
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 40, maxHeight: 20),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0))),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Color(0xffF58323)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                primary: primaryColor,
              ),
              child: Text('OK'),
              onPressed: () {
                if (productController.url.text.isEmpty ||
                    productController.price.text.isEmpty) {
                  Get.snackbar(
                    "error".tr,
                    "fullFields".tr,
                    backgroundColor: notificationBackground,
                    colorText: notificationTextColor,
                  );
                } else {
                  DateTime now = new DateTime.now();
                  RequestBargain _requestBargainData = RequestBargain(
                      userId: Constants.userID.toString(),
                      competitorLink: productController.url.text,
                      competitorPrice: productController.price.text,
                      slug: productController.slug,
                      timestamp: now);
                  requestBargainController(_requestBargainData);
                  print("Api Hit");
                  print("Data delivered: " + _requestBargainData.toString());
                  productController.url.clear();
                  productController.price.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void addToFavorite(String pId, String? uID) async {
    print("inside api" + pId.toString());
    var url = Constants.baseUrl;
    final response = await http.post(
      Uri.parse(url + '/wish-list'),
      body: {"user_id": uID, "product_id": pId},
    );
    print("api is called");
    if (response.statusCode == 200) {
      if (response.body.contains('Added')) {
        productController.isFavorite.value = true;
        print("response of api " + response.body);
      } else {
        productController.isFavorite.value = false;
        var data = jsonDecode(response.body);
        print("Api reponse else " + data.toString());
      }
    } else {
      throw ("Api not hit");
    }
  }

  _showAlertDialogFav(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        elevation: 2,
      ),
      child: Text(
        "Log In ",
        style: TextStyle(color: Colors.white),
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

    AlertDialog alert = AlertDialog(
      title: Text("Information"),
      content: Text(
          "You are not logged in. Please login first to use this Feature."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
        // _displayTextInputDialog(context);
      },
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        elevation: 2,
      ),
      child: Text(
        "Log In ",
        style: TextStyle(color: Colors.white),
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

    AlertDialog alert = AlertDialog(
      title: Text("Information"),
      content: Text(
          "You are not logged in. Please login first to use this Feature."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Guest Order"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCheckout(),
            ));
      },
    );
    Widget continueButton = TextButton(
      child: Text("Go To LogIn Screen"),
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

    AlertDialog alert = AlertDialog(
      title: Text("Information"),
      content: Text("You are not logged in. Please login first for checkout."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void removeFavItem(String pId, String uID) async {
    print("inside api");
    var url = Constants.baseUrl;
    final response = await http.post(
      Uri.parse(url + '/delete-wishlist'),
      body: {"user_id": uID, "product_id": pId},
    );
    print("api is called");
    if (response.statusCode == 200) {
      if (response.body.contains('Successfully')) {
        productController.isFavorite.value = false;
        print("response of api " + response.body);
      } else {
        Fluttertoast.showToast(msg: 'try Again');
        var data = jsonDecode(response.body);
        print("Api reponse else " + data.toString());
      }
    } else {
      productController.isFavorite.value = true;
      // isLoadingMore.value = false;
      // favItemsList.value = [];
      throw ("Api not hit");
    }
  }

  void _favMethod() {
    if (productController.isFavorite.value == true) {
      print("Remove Api is called");
      removeFavItem(
          productController.productList[0]['id'].toString(), Constants.userID!);
    } else if (productController.isFavorite.value == false) {
      addToFavorite(
          productController.productList[0]['id'].toString(), Constants.userID);
    }
  }

  _showContent() {
    // print('Data Start');
    // print('${productController.productList[0]}');
    // print('${productController.productList[0]['id']}');
    // print('${productController.productList[0]['size_price']}');
    Get.log('Colors are : ' +
        productController.productList[0]['colors'].toString());
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: productController.controller,
              child: ScreenTypeLayout(
                mobile: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _upperSection(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _name(),
                    _rate(),
                    _price(),
                    _offPrice(),
                    _title(),
                    _desc(),
                    productController.productList[0]['color']
                                .toString()
                                .trim()
                                .isEmpty ||
                            productController.productList[0]['color']
                                    .toString()
                                    .trim() ==
                                ""
                        ? SizedBox()
                        : _selectColorTitle("select_color".tr),
                    productController.productList[0]['color'].toString().isEmpty
                        ? SizedBox()
                        : _getColors(productController.selVarient),
                    productController.productList[0]['size'].toString().isEmpty
                        ? SizedBox()
                        : _selectVarientTitle("select_variants".tr),
                    productController.productList[0]['size'].toString().isEmpty
                        ? SizedBox()
                        : _getVarient(productController.selVarient),
                    _ratingReview(),
                    _review(),
                    // rating(),
                    // _writeComment(),
                    _quesAns(),
                    productController.getQuesAns.length == 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: ListTile(
                              dense: true,
                              title: Text(
                                'no_questions'.tr,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ExpansionTile(
                                backgroundColor: Colors.black12,
                                title: Text(
                                  "${productController.getQuesAns[index]['question']}",
                                ),
                                children: [
                                  Text(
                                    "${productController.getQuesAns[index]['answer'] ?? "no Answer"}",
                                  ),
                                ],
                              );
                            },
                            itemCount: productController.getQuesAns.length,
                          ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 300.w,
                          // height: 30.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF68628),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.all(4)),
                            onPressed: () {
                              Constants.prefs.then((value) =>
                                  value.getBool("loggedIn") != true
                                      ? _showAlertDialog(context)
                                      : Get.to(() => QuestionAnswerScreen(),
                                          arguments: productController.id));
                              print("Product Id ${productController.id}");
                            },
                            child: Text(
                              'ask_question'.tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _belowsection(),
                    // ProDuctDownSec(data),
                    // _similarProdcuts()
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 55.h,
            decoration: BoxDecoration(
              color: Color(0xFFE0ECF8),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ElevatedButton(
                      onPressed: () async {
                        addToCart();
                        print("buy Now Val is " + buyNow.value.toString());
                        Timer(Duration(seconds: 1), () {
                          Constants.prefs.then(
                            (value) => value.getBool("loggedIn") != true
                                ? _showAlertDialog(context)
                                : buyNow.value == true
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MillionMartCheckout(),
                                        ),
                                      )
                                    : null,
                          );
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.work_outline),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            'buy_now'.tr,
                            style: TextStyle(fontSize: 12.sp),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF0C3A66),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    flex: 4,
                    child: ElevatedButton(
                      onPressed: () async {
                        addToCart();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Expanded(
                            child: Text(
                              'add_to_cart'.tr,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF68628),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Container(
                    height: double.infinity.h,
                    width: 2.0.w,
                    color: Colors.white,
                  ),
                  TextButton(
                    onPressed: () async {
                      Constants.prefs.then((value) async {
                        value.getBool('loggedIn') == true
                            ? await productController.addUser()
                            : Get.snackbar('error'.tr, 'loginFirst'.tr,
                                backgroundColor: notificationBackground,
                          colorText: notificationTextColor,);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          color: Color(0xFFF68628),
                        ),
                        Expanded(
                          child: Text(
                            'chat'.tr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFFF68628),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _upperSection() {
    return Stack(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider.builder(
                itemCount: productController.proImgList.length,
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  height: MediaQuery.of(context).size.height / 2.0,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    productController.current.value = index;
                  },
                ),
                itemBuilder: (context, index, realIdx) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                          () => FullScreenView(
                                url: productController.proImgList[index]
                                    .toString(),
                              ),
                          arguments:
                              productController.proImgList[index].toString());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                productController.proImgList[index].toString(),
                            fit: BoxFit.contain,
                            width: 1000.0,
                            height: double.infinity,
                            placeholder: (ctx, url) => Center(
                              child: Lottie.asset(
                                  'assets/svgs/image_loading.json'),
                            ),
                            errorWidget: (ctx, url, e) => Center(
                              child: Image.asset("assets/imageNotFound.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map(
                  productController.proImgList,
                  (index, url) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: productController.current.value == index
                            ? primaryColor
                            : Color.fromRGBO(0, 0, 0, 0.1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Color(0xFF7A7A78)
                      // .withOpacity(0.5),
                      ),
                  onPressed: () {
                    Get.delete<ProductController>();
                    Get.back();
                    // Get.back();
                  },
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.transparent,
                              child: Image.asset('assets/icon/comp.png'),
                            ),
                            productController.cartController.compCount.value !=
                                    0
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: new Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Obx(() {
                                          return new Text(
                                            "${productController.cartController.compCount}",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.white),
                                          );
                                        }),
                                      ),
                                    ),
                                  )
                                : new Positioned(
                                    top: 0.0,
                                    right: 5.0,
                                    bottom: 15,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent),
                                      child: new Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(2),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      onTap: () {
                        addToComp();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Comaprison()),
                        // );
                      },
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: productController.isFavorite.value
                            ? Icon(
                                Icons.favorite,
                                color: Color(0xFFF68628),
                              )
                            : Icon(
                                Icons.favorite,
                                color: Color(0xFF7A7A78),
                                // Color(0xFF333333).withOpacity(0.5),
                              ),
                      ),
                      onTap: () {
                        Constants.prefs.then((value) =>
                            value.getBool("loggedIn") != true
                                ? _showAlertDialogFav(context)
                                : _favMethod());

                        // _displayTextInputDialog(context));
                        // print("Login Chceck :"+Constants.isLogedInCheck.toString());
                        // if(Constants.isLogedInCheck == false){
                        //   _showAlertDialog(context);
                        // }

                        // _isFavorite.value = !_isFavorite.value;
                        print(productController.isFavorite.value.toString());
                      },
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: new Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.shopping_cart_rounded,
                              color: Color(0xFF7A7A78),
                              // Color(0xFF333333).withOpacity(0.5),
                              size: 26,
                            ),
                          ),
                          productController.cartController.cartCoount.length !=
                                  0
                              ? new Positioned(
                                  top: 0.0,
                                  right: 5.0,
                                  bottom: 15,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: new Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Obx(() {
                                          return new Text(
                                            "${productController.cartController.cartCoount.length}",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.white),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                )
                              : new Positioned(
                                  top: 0.0,
                                  right: 5.0,
                                  bottom: 15,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent),
                                    child: new Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(2),
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MillionMartCart(),
                            ));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  _belowsection() {
    // print(data);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  "similar_products".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: primaryColor),
                ),
                Spacer(),
                // Text('View All', style: Theme.of(context).textTheme.subtitle2)
              ],
            ),
          ),

          productController.similarProductsLoading.value
              ? Center(child: CircularProgressIndicator())
              : productController.similerProductList.length == 0
                  ? Container(
                      child: Center(
                        child: Text(
                          "No Data Found",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                      ),
                    )
                  : GridView.builder(
                      // controller: gridScrollController,
                      // controller: gridScrollController,
                      // scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        childAspectRatio: 0.78,
                        // crossAxisSpacing: 20,
                        // mainAxisSpacing: 20
                      ),
                      padding: EdgeInsets.only(top: 5),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      // scrollDirection: Axis.horizontal,
                      itemCount: productController.similerProductList.length,
                      // paginationData.productList.length,
                      // physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return
                            // index ==
                            //           paginationData
                            //               .productList
                            //               .length
                            //       ?
                            //
                            //       :
                            ItemCard(
                          mmID:
                              "${productController.similerProductList[index]["store_id"]}",
                          id: productController.similerProductList[index]["id"]
                              .toString(),
                          tag: "${index}2",
                          imagurl: productController.similerProductList[index]
                              ["photo"],
                          itemname: Constants.checkLanguage=="English"?
                          productController.similerProductList[index]["name"]
                          : productController.similerProductList[index]["name_ur"]
                              ,
                          descprice:
                              "${productController.similerProductList[index]["previous_price"]}",
                          price:
                              "${productController.similerProductList[index]["price"]}",
                          rating:
                              "${productController.similerProductList[index]["rating"]}",
                          slug:
                              "${productController.similerProductList[index]["slug"]}",
                          shadow: false,
                          similarPro: true,
                        );
                      },
                    ),
          // Container(
          //   height: 160,
          //       child: ListView.builder(
          //         shrinkWrap: true,
          //         scrollDirection: Axis.horizontal,
          //         itemCount: productController.similerProductList.length,
          //         itemBuilder: (BuildContext context, int index) {
          //           return
          //         },
          //         // separatorBuilder: (BuildContext context, int index) {
          //         //   return SizedBox(
          //         //     width: 10,
          //         //   );
          //         // },
          //       ),
          //     ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Text(
          //         "Seller Products",
          //         style: Theme.of(context)
          //             .textTheme
          //             .headline6!
          //             .copyWith(color: primary),
          //       ),
          //       Spacer(),
          //     ],
          //   ),
          // ),
          // productController.similarProductsLoading.value?Center(child: CircularProgressIndicator()):productController.similerProductList.length == 0
          //     ? Padding(
          //         padding: const EdgeInsets.only(bottom: 16),
          //         child: Container(
          //           child: Center(
          //             child: Text(
          //               "No Data Found",
          //               style: TextStyle(
          //                   color: Colors.deepOrange,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 15.0),
          //             ),
          //           ),
          //         ),
          //       )
          //     : Container(
          //         width: double.infinity,
          //         margin: EdgeInsets.all(12),
          //         child: GridView.builder(
          //           physics: NeverScrollableScrollPhysics(),
          //           itemCount: productController.similerProductList.length,
          //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //             crossAxisCount: 2,
          //             crossAxisSpacing: 4,
          //             mainAxisSpacing: 4,
          //             childAspectRatio: 1,
          //           ),
          //           shrinkWrap: true,
          //           scrollDirection: Axis.vertical,
          //           itemBuilder: (context, index) {
          //             return _card(
          //               "${productController.similerProductList[index]['photo']}",
          //               "${productController.similerProductList[index]['name']}",
          //             );
          //           },
          //         ),
          //       )
        ],
      ),
    );
  }

  _card(String url, String name) {
    return Container(
      height: MediaQuery.of(context).size.width / 2,
      child: Card(
        elevation: 1.5,
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 10,
                            ),
                            Text(
                              '12',
                              style: Theme.of(context)
                                  .textTheme
                                  .overline!
                                  .copyWith(letterSpacing: 0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.overline!.copyWith(
                            color: Colors.black,
                            fontSize: 16.0,
                            letterSpacing: 0.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          " Rs",
                          style: TextStyle(
                            color: Colors.blue[900],
                          ),
                        ),
                        Text(
                          " 21",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Rs" + "",
                      style: Theme.of(context).textTheme.overline!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 1),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "3%".split('.')[0],
                            style: Theme.of(context)
                                .textTheme
                                .overline!
                                .copyWith(
                                    color: Colors.orange, letterSpacing: 0),
                          ),
                          Text(
                            ' %off',
                            style: Theme.of(context)
                                .textTheme
                                .overline!
                                .copyWith(
                                    color: Colors.orange, letterSpacing: 0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }

  _rate() {
    var _rate = [];
    var _totalRating = 0.0;
    var rate = 0.0;
    print("rating in api " +
        productController.productList[0]['ratings'].toString());
    //
    if (productController.productList[0]['ratings'].isNotEmpty) {
      _rate.add(productController.productList[0]['ratings']);
      _rate.forEach((val) {

        if(val[0]['rating'].runtimeType.toString()=='String'){

          print("rating value is " + val.toString());
          print(val[0]['rating'].runtimeType);
          var _rating = int.parse(val[0]['rating']);
          _totalRating = _totalRating + _rating;
          print(_totalRating.toString);


        }
        else{
          print("rating value is " + val.toString());
          print(val[0]['rating'].runtimeType);
          var _rating = val[0]['rating'];
          _totalRating = _totalRating + _rating;
          print(_totalRating.toString);

        }

      });
      rate = _totalRating / _rate.length;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Card(
              margin: const EdgeInsets.only(left: 20.0, bottom: 5),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    Text(" " + "${rate}")
                  ],
                ),
              ),
            ),
            Text(
              "${_rate.length}" + " " + "ratings".tr,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        InkWell(
          onTap: () {
            print(productController.productList[0]['id']);

            Constants.prefs.then((value) => value.getBool("loggedIn") != true
                ? _showAlertDialog(context)
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportScreen(
                        productTitle: productController.productList[0]['name'],
                        productID: productController.productList[0]['id'],
                      ),
                    ),
                  ));
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Icon(
                  Icons.flag_rounded,
                  color: Colors.grey,
                ),
                Text(
                  'report_this'.tr,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  _price() {
    return Obx(() {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text(
                'Rs' +
                    " " +
                    "${(int.parse(productController.productList[0]['price'].toString().split('.')[0]) + _sizePrice.value).toString()}",
                style: Theme.of(context).textTheme.headline6),
          ),
          Spacer(),
          "${productController.productList[0]['store_id']}".contains('1')
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                  child: Card(
                    color: primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'million_mall'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      );
    });
  }

  _offPrice() {
    late var off = productController.productList[0]['previous_price']
                    .toString() ==
                "0" ||
            double.parse(productController.productList[0]['previous_price']
                    .toString()) <=
                double.parse(
                    productController.productList[0]['price'].toString())
        ? "0"
        : (double.parse(productController.productList[0]['previous_price']
                    .toString()) -
                double.parse(
                    productController.productList[0]['price'].toString())) *
            100 /
            double.parse(
                productController.productList[0]['previous_price'].toString());
    print('off' + off.toString());
    return Obx(() {
      bool? check = productController.productList.isBlank;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  check == true
                      ? Container()
                      : Text(
                          'Rs' +
                              " " +
                              "${productController.productList[0]['previous_price'].toString().split('.')[0]}",
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                        ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.all(4),
                    child: Text(
                        '${double.parse(off.toString()).toStringAsFixed(0)} %off',
                        style: Theme.of(context).textTheme.overline!.copyWith(
                            color: Colors.orange, letterSpacing: 0.5)),
                    decoration: new BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: new BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                displayTextInputDialog(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.all(4),
                child: Text(
                  'Bargain'.tr,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                decoration: new BoxDecoration(
                    color: Color(0xFF0C3A66),
                    borderRadius: new BorderRadius.circular(4.0)),
              ),
            ),
            GestureDetector(
              onTap: () {
                callNumber();
              },
              child: Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.all(4),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 14,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.h,
                    ),
                    Text(
                      'call_to_order'.tr,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                decoration: new BoxDecoration(
                  color: Color(0xFF0C3A66),
                  borderRadius: new BorderRadius.circular(4.0),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Text(
        "description".tr,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.black),
      ),
    );
  }

  _name() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
      child: Constants.checkLanguage=="English"? Text(
        "${productController.productList[0]['name']}",
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.black),
      ) : Text(
        "${productController.productList[0]['name_ur']}",
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.black),
      ),
    );
  }

  _desc() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Html(data:Constants.checkLanguage=="English"? productController.productList[0]['details'] : productController.productList[0]['details_ur']),
      );
    });
  }

  _selectColorTitle(String _text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        _text,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: primaryColor),
      ),
    );
  }

  _getColors(int pos) {
    List<String> attrName = ["Color"];
    List<String> attrValue = ['${productController.productList[0]['color']}'];
    var colorList = [];
    colorList.add(productController.productList[0]['color']);
    bool? check = colorList.isEmpty;
    print("color check is :" + check.toString() + colorList.toString());
    return InkWell(
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: attrName.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            print("Colors index ${attrName.length}");
            return ListTile(
              dense: true,
              title: Text(
                'click_to_choose_clr'.tr,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            );
          },
        ),
        onTap: () {
          _chooseColors();
        });
  }

  void _chooseColors() {
    bool available = true;
    List<dynamic>? color;
    // color!.add(productController.productList[0]['color']);
    int? selectedIndex;
    print(color);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (builder) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  selectVarient.tr,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Divider(),
              _title(),
              // _price(),
              // _offPrice(),
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                height: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: productController.productList[0]['color'].length,
                  itemBuilder: (BuildContext context, int index) {
                    Color color1 = HexColor(
                        productController.productList[0]['color'][index]);
                    return ChoiceChip(
                      key: ValueKey<String>(
                        productController.productList[0]['color'][index],
                      ),
                      selected: selectedIndex == index,
                      label: Text(
                        "  ",
                        style: TextStyle(color: Colors.white),
                      ),
                      // backgroundColor: primary.withOpacity(0.45),
                      backgroundColor: color1.withOpacity(0.7),
                      selectedColor: color1,
                      selectedShadowColor: color1,
                      // disabledColor: primary.withOpacity(0.5),
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            selectedIndex = index;
                            selectedColor = productController.productList[0]
                                ['color'][index];
                            print("Selected Color : " + selectedColor);
                          });
                        }
                      },
                    );
                  },
                ),
              ),

              Divider(),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                    ),
                    onPressed: available == true ? applyColor : null,
                    child: Text(
                      'apply'.tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  applyColor() {
    Navigator.of(context).pop();
    setState(() {
      productController.selVarient = productController.oldSelVarient;
    });
  }

  _selectVarientTitle(String _text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        _text,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: primaryColor),
      ),
    );
  }

  _getVarient(int pos) {
    List<String> attrName = ["Size"];
    // List<String> attrValue = [
    //   '${productController.productList[0]['size']}'
    // ];
    bool? check = productController.productList.isBlank;
    return InkWell(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: attrName.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          print("varient ${attrName.length}");
          return ListTile(
            dense: true,
            title: Text(
              'click_to_choose_sze'.tr,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
          );
        },
      ),
      onTap: () {
        _chooseVarient();
      },
    );
  }

  void _chooseVarient() {
    bool available = true;
    List<dynamic>? sizes;
    // sizes!.add(productController.productList[0]['size']);
    int? selectedIndex;
    print(sizes);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (builder) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  selectVarient,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Divider(),
              _title(),
              // _price(),
              // _offPrice(),
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                height: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: productController.productList[0]['size'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChoiceChip(
                      key: ValueKey<String>(
                        productController.productList[0]['size'][index],
                      ),
                      selected: selectedIndex == index,
                      label: Text(
                          productController.productList[0]['size'][index],
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: primaryColor.withOpacity(0.45),
                      selectedColor: primaryColor,
                      disabledColor: primaryColor.withOpacity(0.5),
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            selectedIndex = index;
                            _sizePrice.value = int.parse(productController
                                .productList[0]['size_price'][index]
                                .toString());
                            proSize =
                                productController.productList[0]['size'][index];
                            print("size is  : " + proSize);
                          });
                        }
                      },
                    );
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                    ),
                    onPressed: available == true ? applyVarient : null,
                    child: Text(
                      'apply'.tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  applyVarient() {
    Navigator.of(context).pop();
    setState(() {
      productController.selVarient = productController.oldSelVarient;
    });
  }

  _ratingReview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Text(
        'ratings_&_reviews'.tr,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: primaryColor),
      ),
    );
  }

  _quesAns() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Text(
        'questions_&_answers'.tr,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: primaryColor),
      ),
    );
  }

  rating() {
    return Center(
      child: RatingBar.builder(
        initialRating: productController.initialRate,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 32,
        itemPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {},
      ),
    );
  }

  _writeComment() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: productController.commentC,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (String val) {
              if (productController.commentC.text.trim().isNotEmpty) {
                setState(() {
                  productController.isCommentEnable = true;
                });
              } else {
                setState(() {
                  productController.isCommentEnable = false;
                });
              }
            },
            autofocus: false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              prefixIcon: Icon(Icons.rate_review, color: primaryColor),
              hintText: 'Write your comments here..',
              hintStyle: TextStyle(
                color: primaryColor.withOpacity(0.5),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: IconButton(
              icon: Icon(
                Icons.send,
                color: productController.isCommentEnable
                    ? primaryColor
                    : Colors.transparent,
              ),
              onPressed: () => productController.isCommentEnable == true),
        ),
      ],
    );
  }

  _review() {
    return productController.reviewsData.length != 0
        ? ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: productController.reviewsData.length,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 15,
                              ),
                              Text(
                                "${productController.reviewsData[index]
                                ['rating']} " ,

                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(" ${productController.reviewsData[index]['user_id']} "
                          ),
                      Spacer(),
                      Text(productController.reviewsData[index]['review_date'])
                    ],
                  ),
                  productController.reviewsData[index]['review_date'] != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(productController.reviewsData[index]
                                  ['review'] ??
                              ''),
                        )
                      : Container(),
                ],
              );
            },
          )
        : Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              dense: true,
              title: Text(
                'not_reviewed'.tr,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          );
    // Padding(
    //         padding: const EdgeInsets.only(left: 24),
    //         child: Text("Not Reviewed yet"),
    //       );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  initializeVoiceCommands() {
    setState(() {
      productController.animate = !productController.animate;
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
                .contains('open') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCart(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('add') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('card')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('add') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('tokri') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('shamil')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('tokri') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('dalain')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('tokri') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('dalo')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('shamil')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('dalo')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('dalain')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('basket') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('shamil')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('basket') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('dalo')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('basket') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('dalain')) {
          addToCart();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('open') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('card')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCart(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('dikhao')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCart(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('kholo')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCart(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('tokri') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('kholo')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCart(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('tokri') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('dikhao')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCart(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('basket') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('dikhao')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCart(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('basket') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('kholo')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCart(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('track') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('order')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Orders(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
            .toLowerCase()
            .contains('comment')) {
          Get.to(QuestionAnswerScreen());
        } else if (_voiceCommandsController.speechText.value
            .toLowerCase()
            .contains('tabsara')) {
          Get.to(QuestionAnswerScreen());
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
                .contains('add') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('wishlist')) {
          _favMethod();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('shamil') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('wishlist')) {
          _favMethod();
        } else if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('shamil') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('khuwahishat')) {
          _favMethod();
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
                .contains('mukamal')) {
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
        } else {
          Fluttertoast.showToast(msg: 'No matching command');
        }
        _voiceCommandsController.speechText.value = "";
        setState(() {
          productController.animate = productController.animate;
        });
      },
    );
  }

  var selectedColor = "null";
  var _sizePrice = 0.obs;
  String proSize = "null";

  NetworkController networkController = Get.put(NetworkController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () {
          Get.back();
          return Get.delete<ProductController>();
        },
        child: networkController.networkStatus.value == true
            ? Scaffold(
                floatingActionButton: DraggableFab(
                  child: AvatarGlow(
                    glowColor: Colors.blue,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    animate: productController.animate,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    endRadius: 60.0,
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
                ),
                key: _scaffoldKey,
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
                    child: productController.isLoading.value == true
                        ? Center(
                            child: Image.asset(
                              'assets/icon/mmgif.gif',
                              height: 50,
                              width: 50,
                            ),
                          )
                        : _showContent()),
              )
            : NoInternetScreen(),
      );
    });
  }

  //Add to comparision
  void addToComp() async {
    var off = (double.parse(
                productController.productList[0]['previous_price'].toString()) -
            double.parse(
                productController.productList[0]['price'].toString())) *
        100 /
        double.parse(
            productController.productList[0]['previous_price'].toString());
    print('off' + off.toString());

    CompData _compData = CompData(
      name: productController.productList[0]['name'].toString(),
      des: productController.productList[0]['details'].toString(),
      discount: off.toString(),
      image: productController.productList[0]['photo'].toString(),
      price: productController.productList[0]['price'].toString(),
      rating: productController.productList[0]['rating'],
    );
    // var now = DateTime.now();
    bool isExist = await productController.dbCompManager
        .checkCompItems(productController.productList[0]['name'].toString());

    if (isExist) {
      productController.dbCompManager.insertComp(_compData).then(
            (value) => {
              print("Data Added $value"),
              print(productController.productList[0]['photo']),
              print(productController.productList[0]['rating']),
              print(productController.productList[0]['previous_price']),
              print(productController.productList[0]['price'].toString()),
              print(productController.productList[0]['name'].toString()),
            },
          );
      Fluttertoast.showToast(
          msg: "Product Added To Comparison",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black26,
          fontSize: 16.0);
      productController.cartController.getCompCount();
      print("Product Added into Cart");
    } else {
      Fluttertoast.showToast(
          msg: "Product Already Exist in Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black26,
          fontSize: 16.0);
      print('product already exist in Comparison');
    }
  }

  void addToCart() async {
    late var item_size_price;
    var itemsize = "";
    var itemcolor = "";
    // print("Check ${productController.productList[0]['size_price'].toString()}");
    var itemqty = 1;
    var item_size_key = productController.productList[0]['size_key'];
    productController.productList[0]['size_price'].toString().isEmpty
        ? item_size_price = 1
        : item_size_price = productController.productList[0]['size_price'][0];
    productController.productList[0]['size'].toString().isEmpty
        ? itemsize = "S"
        : itemsize = (productController.productList[0]['size'][0].toString());
    productController.productList[0]['color'].toString().isEmpty
        ? itemcolor = ""
        : itemcolor = productController.productList[0]['color'][0].toString();
    var itemprice = productController.productList[0]['price'];
    // print("Color in add to cart "+selectedColor );

    //Maintaining the list start
    //size
    var size;
    productController.productList[0]['size'].toString().isEmpty
        ? size = ""
        : size = widget.productController.productList[0]['size']
            .toString()
            .substring(
                1,
                widget.productController.productList[0]['size']
                        .toString()
                        .length -
                    1);

    var sizesList = [];

    var splitSize = size.split(',');
    for (var a in splitSize) {
      String b = "$a";
      sizesList.add(b);
    }
    print(sizesList);

    //size_qty
    var size_qty;
    widget.productController.productList[0]['size_qty'].toString().isEmpty
        ? size_qty = ""
        : size_qty = widget.productController.productList[0]['size_qty']
            .toString()
            .substring(
                1,
                widget.productController.productList[0]['size_qty']
                        .toString()
                        .length -
                    1);
    var size_qtyList = [];
    var splitSizeQty = size_qty.split(',');
    for (var a in splitSizeQty) {
      String b = "$a";
      size_qtyList.add(b);
    }
    print(size_qtyList);

    //size_price
    var size_price;
    widget.productController.productList[0]['size_price'].toString().isEmpty
        ? size_price = ""
        : size_price = widget.productController.productList[0]['size_price']
            .toString()
            .substring(
                1,
                widget.productController.productList[0]['size_price']
                        .toString()
                        .length -
                    1);
    var size_priceList = [];
    var splitSizePrice = size_price.split(',');
    for (var a in splitSizePrice) {
      String b = "$a";
      size_priceList.add(b);
    }
    print(size_priceList);

    //color
    var color;
    widget.productController.productList[0]['color'].toString().isEmpty
        ? color = ""
        : color = widget.productController.productList[0]['color']
            .toString()
            .substring(
                1,
                widget.productController.productList[0]['color']
                        .toString()
                        .length -
                    1);

    var colorsList = [];
    var splitColor = color.split(',');
    for (var a in splitColor) {
      String b = "$a";
      colorsList.add(b);
    }
    print(colorsList);

    //whole_sell_qty
    var whole_sell_qty;
    widget.productController.productList[0]['whole_sell_qty'].toString().isEmpty
        ? whole_sell_qty = ""
        : whole_sell_qty = widget
            .productController.productList[0]['whole_sell_qty']
            .toString()
            .substring(
                1,
                widget.productController.productList[0]['whole_sell_qty']
                        .toString()
                        .length -
                    1);
    var whole_sell_qtyList = [];
    var splitWholeSellQty = whole_sell_qty.split(',');
    for (var a in splitWholeSellQty) {
      String b = "$a";
      whole_sell_qtyList.add(b);
    }
    print(whole_sell_qtyList);

    //whole_sell_discount
    var whole_sell_discount;
    widget.productController.productList[0]['whole_sell_discount']
            .toString()
            .isEmpty
        ? whole_sell_discount = ""
        : whole_sell_discount = widget
            .productController.productList[0]['whole_sell_discount']
            .toString()
            .substring(
                1,
                widget.productController.productList[0]['whole_sell_discount']
                        .toString()
                        .length -
                    1);
    var whole_sell_discountList = [];
    var splitWholeSellDiscount = whole_sell_discount.split(',');
    for (var a in splitWholeSellDiscount) {
      String b = "$a";
      whole_sell_discountList.add(b);
    }
    print(whole_sell_discountList);
    //end maintaining

    bool isExist = await productController.dbcartmanager
        .checkCartItems(productController.productList[0]['name'].toString());
    var colorList = [];
    colorList.add(productController.productList[0]['color']);
    print("selected color is ${selectedColor}:");
    print("list of color is ${colorList}");
    var sizeList = [];
    sizeList.add(productController.productList[0]['size']);
    print("sizes are :${sizeList}");

    if (productController.productList[0]['color']
                .toString()
                .trim()
                .isNotEmpty &&
            selectedColor == "null" ||
        productController.productList[0]['size'].toString().trim().isNotEmpty &&
            proSize == "null") {
      Fluttertoast.showToast(
          msg: "Choose Product Color & Size First",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black26,
          fontSize: 16.0);
    } else {
      if (selectedColor == "null" || proSize == "null") {
        selectedColor = "FFFFFF";
        proSize = "Default";
      }

      var pitems = {};

      pitems['id'] = widget.productController.productList[0]['id'];
      pitems["user_id"] = widget.productController.productList[0]['user_id'];
      pitems["slug"] = widget.productController.productList[0]['slug'];
      pitems["name"] = widget.productController.productList[0]['name'];
      pitems["photo"] = widget.productController.productList[0]['photo'];
      pitems["size"] = sizesList;
      pitems["size_qty"] = size_qtyList;
      pitems["size_price"] = size_priceList;
      pitems["color"] = colorsList;
      pitems["price"] = widget.productController.productList[0]['price'];
      pitems["stock"] = "null";
      pitems["type"] = widget.productController.productList[0]['type'];
      pitems["file"] = widget.productController.productList[0]['file'];
      pitems["link"] = "null";
      pitems["license"] = widget.productController.productList[0]['license'];
      pitems["license_qty"] =
          widget.productController.productList[0]['license_qty'];
      pitems["measure"] = "null";
      pitems["whole_sell_qty"] = whole_sell_qtyList;
      pitems["whole_sell_discount"] = whole_sell_discountList;
      pitems["attributes"] = "null";

      var items = {};

      items["qty"] = itemqty;
      items["size_key"] = item_size_key;
      widget.productController.productList[0]['size_qty'].toString().isEmpty
          ? items["size_qty"] = 1
          : items["size_qty"] =
              widget.productController.productList[0]['size_qty'][0];
      items["size_price"] = item_size_price;
      items["size"] = itemsize;
      items["color"] = itemcolor;
      items["stock"] = "null";
      items["price"] = itemprice;
      items["item"] = pitems;
      items["license"] = "";
      items["dp"] = "0";
      items["keys"] = "";
      items["values"] = "";
      items["item_price"] = widget.productController.productList[0]['price'];

      var itemkey = {};

      itemkey['${productController.productList[0]['id']}'] = items;

      Get.log("All Items ${json.encode(itemkey)}");

      // Map<String, dynamic> itemsDate = {
      //   productController.productList[0]['id'].toString(): {
      //     "qty": itemqty,
      //     "size_key": item_size_key,
      //     "size_qty": widget.productController.productList[0]['size_qty'][0],
      //     "size_price": item_size_price,
      //     "size": itemsize,
      //     "color": itemcolor,
      //     "stock": "null",
      //     "price": itemprice,
      //     "item": {
      //       "id": widget.productController.productList[0]['id'],
      //       "user_id": widget.productController.productList[0]['user_id'],
      //       "slug": widget.productController.productList[0]['slug'],
      //       "name": widget.productController.productList[0]['name'],
      //       "photo": widget.productController.productList[0]['photo'],
      //       "size": sizeList,
      //       "size_qty": size_qtyList,
      //       "size_price": size_priceList,
      //       "color": colorsList,
      //       "price": widget.productController.productList[0]['price'],
      //       "stock": "null",
      //       "type": widget.productController.productList[0]['type'],
      //       "file": widget.productController.productList[0]['file'],
      //       "link": "null",
      //       "license": widget.productController.productList[0]['license'],
      //       "license_qty": widget.productController.productList[0]
      //           ['license_qty'],
      //       "measure": "null",
      //       "whole_sell_qty": whole_sell_qtyList,
      //       "whole_sell_discount": whole_sell_discountList,
      //       "attributes": "null",
      //     },
      //     "license": "",
      //     "dp": "0",
      //     "keys": "",
      //     "values": "",
      //     "item_price": widget.productController.productList[0]['price']
      //   }
      // };

      // print("item data map $itemsDate");
      //Preparing map
      // "${productController.productList[0]['id']}":{"qty":$itemqty,"size_key":$item_size_key,"size_qty":"${widget.productController.productList[0]['size_qty'][0]}","size_price":"$item_size_price","size":"$itemsize","color":"$itemcolor","stock":null,"price":$itemprice,"item":{"id":${widget.productController.productList[0]['id']},"user_id":${widget.productController.productList[0]['user_id']},"slug":"${widget.productController.productList[0]['slug']}","name":"${widget.productController.productList[0]['name']}","photo":"${widget.productController.productList[0]['photo']}","size":$sizesList,"size_qty":$size_qtyList,"size_price":$size_priceList,"color":$colorsList,"price":"${widget.productController.productList[0]['price']}","stock":null,"type":"${widget.productController.productList[0]['type']}","file":"${widget.productController.productList[0]['file']}","link":null,"license":"${widget.productController.productList[0]['license']}","license_qty":"${widget.productController.productList[0]['license_qty']}","measure":null,"whole_sell_qty":$whole_sell_qtyList,"whole_sell_discount":$whole_sell_discountList,"attributes":null},"license":"","dp":"0","keys":"","values":"","item_price":${widget.productController.productList[0]['price']}}
      // var item = jsonEncode({
      // ""${productController.productList[0]['id']}":{"qty":$itemqty,"size_key":$item_size_key,"size_qty":"${widget.productController.productList[0]['size_qty'][0]}","size_price":"$item_size_price","size":"$itemsize","color":"$itemcolor","stock":null,"price":$itemprice,"item":{"id":${widget.productController.productList[0]['id']},"user_id":${widget.productController.productList[0]['user_id']},"slug":"${widget.productController.productList[0]['slug']}","name":"${widget.productController.productList[0]['name']}","photo":"${widget.productController.productList[0]['photo']}","size":$sizesList,"size_qty":$size_qtyList,"size_price":$size_priceList,"color":$colorsList,"price":"${widget.productController.productList[0]['price']}","stock":null,"type":"${widget.productController.productList[0]['type']}","file":"${widget.productController.productList[0]['file']}","link":null,"license":"${widget.productController.productList[0]['license']}","license_qty":"${widget.productController.productList[0]['license_qty']}","measure":null,"whole_sell_qty":$whole_sell_qtyList,"whole_sell_discount":$whole_sell_discountList,"attributes":null},"license":"","dp":"0","keys":"","values":"","item_price":${widget.productController.productList[0]['price']}}""
      // });
      //end preparing
      Cart cartItem;
      // var now = DateTime.now();
      cartItem = new Cart(
        name: productController.productList[0]['name'].toString(),
        image: productController.productList[0]['photo'].toString(),
        price:
            productController.productList[0]['price'].toString().split('.')[0],
        previous_price: productController.productList[0]['previous_price']
            .toString()
            .split('.')[0],
        qty: itemqty,
        sub_total: productController.productList[0]['price'].toString(),

        color: selectedColor,
        size_key: item_size_key,
        size_qty: widget.productController.productList[0]['size_qty']
                .toString()
                .isEmpty
            ? ""
            : widget.productController.productList[0]['size_qty'][0],
        size_price: item_size_price.toString(),

        key: productController.productList[0]['id'].toString(),
        p_id: widget.productController.productList[0]['id'].toString(),
//  "price": itemprice,
//  "color": itemcolor,
        p_user_id:
            widget.productController.productList[0]['user_id'].toString(),
        p_slug: widget.productController.productList[0]['slug'],
        p_name: widget.productController.productList[0]['name'],
        p_photo: widget.productController.productList[0]['photo'],
        p_size: sizeList.toString(),
        p_size_qty: size_qtyList.toString(),
        p_size_price: size_priceList.toString(),
        p_color: colorsList.toString(),
        p_price: widget.productController.productList[0]['price'].toString(),
        p_stock: "null",
        p_type: widget.productController.productList[0]['type'],
        p_file: widget.productController.productList[0]['file'],
        p_link: "null",
        p_license: widget.productController.productList[0]['license'],
        p_license_qty: widget.productController.productList[0]['license_qty'],
        p_measure: "null",
        p_whole_sale_qty: whole_sell_qtyList.toString(),
        p_whole_sale_discount: whole_sell_discountList.toString(),
        p_attributes: "null",
        license: "",
        dp: "0",
        keys: "",
        values: "",
        item_price: widget.productController.productList[0]['price'].toString(),

        size: proSize,
        stock: productController.productList[0]['stock'].toString().isEmpty
            ? "null"
            : productController.productList[0]['stock'].toString(),
        slug: widget.productController.productList[0]['slug'],
      );
      if (isExist) {
        productController.dbcartmanager.insertProduct(cartItem).then(
              (value) => {
                buyNow.value = true,
                print("Data Added $value"),
                print(productController.productList[0]['photo']),
                print(productController.productList[0]['rating']),
                print(productController.productList[0]['previous_price']),
                print(productController.productList[0]['price'].toString()),
                print(productController.productList[0]['name'].toString()),
              },
            );
        Fluttertoast.showToast(
            msg: "Product Added To Cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black26,
            fontSize: 16.0);
        productController.cartController.getCartCount();
        // productController.addToCartWeb(
        //     productController.productList[0]['id'].toString(),
        //     "1",
        //     productController.productList[0]['size'].toString(),
        //     productController.productList[0]['size_qty'].toString(),
        //     productController.productList[0]['size_price'].toString(),
        //     // productController.productList[0]['size_key'],
        //     "",
        //     "",
        //     "",
        //     productController.productList[0]['price'].toString().split('.')[0]);
        print("Product Added into Cart");
      } else {
        buyNow.value = true;
        Fluttertoast.showToast(
            msg: "Product Already Exist in Cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black26,
            fontSize: 16.0);
        print('product already exist in cart');
      }
    }
  }
}
