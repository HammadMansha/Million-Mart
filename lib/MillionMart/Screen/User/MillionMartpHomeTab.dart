// import 'dart:html';
import 'dart:io';
import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/MillionMallController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PaginationProductsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PlaceHolderController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PlaceHolderProdcutsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/VoiceCommandsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/VoiceSearchController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/productDetailController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartPlaceHolderspProdcuts.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/ProductDetail/MillionMartCheckout.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartAppBar.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartDrawer.dart';
import 'package:millionmart_cleaned/MillionMart/widget/SearchBar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:upgrader/upgrader.dart';
import 'MillionMartCart.dart';
import 'MillionMartOrders.dart';
import 'NoInternet.dart';
import 'ProductDetail/MillionMartProductDetail.dart';
import 'MillionMartStaggeredList.dart';
import '../MillionMall/millionMallHomeTab.dart';
import 'dart:async';
import 'package:resize/resize.dart';
import 'package:draggable_fab/draggable_fab.dart';

Future<void> fetchData() async {
  // PlaceHolderController placeHolder =
  // Get.find<PlaceHolderController>();
  // Get.delete<HomeController>();
  Get.delete<PaginationDataController>();
  PaginationDataController paginationDataController =
      Get.put(PaginationDataController());
  PlaceHolderController placeHolder = Get.put(PlaceHolderController());
  HomeController controller = Get.put(HomeController());
  HomeController __controller = Get.find<HomeController>();
  PaginationDataController __paginationController =
      Get.find<PaginationDataController>();

  // PaginationDataController __paginationData = Get.find<PaginationDataController>();
  // __paginationData.recievedProducts.value = 0;
  // __paginationData.productsInterval.value = 10;
  // await __paginationData.paginationProductsAPi();
  // await __controller.fetchProducts();
  // await __controller.carouselController();
  //
  // __controller.update();
  __controller.isLoading.value = true;
  await placeHolder.PlaceHolderData();
  await __controller.getCartCount();
  await __controller.carouselController();
  await __controller.fetchProducts();
  await __controller.checkLogin();
  __paginationController.recievedProducts.close();
  await __paginationController.paginationProductsAPi();
  // await Future.delayed(Duration(seconds: 0, milliseconds: 2000), () {
  //   __controller.isLoading.value = false;
  // });
}

var _current = 0.obs;

class Cat {
  // final int id;
  final String name;
  final String ciurl;

  Cat({required this.name, required this.ciurl});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      name: json['id'],
      ciurl: json['position'],
    );
  }
}

class MillionMartHomeTab extends StatefulWidget {
  MillionMartHomeTab({Key? key}) : super(key: key);

  @override
  _MillionMartHomeTabState createState() => _MillionMartHomeTabState();
}

class _MillionMartHomeTabState extends State<MillionMartHomeTab>
    with TickerProviderStateMixin {
  HomeController controller = Get.find<HomeController>();
  MillionMallController millionMall = Get.put(MillionMallController());
  PlaceHolderController _placeHolderController =
      Get.put(PlaceHolderController());
  PlaceholderProductsController placeHolderProductsController =
      Get.put(PlaceholderProductsController());

  VoiceSearchController voiceSearchController =
      Get.put(VoiceSearchController());
  PaginationDataController paginationData = Get.put(PaginationDataController());
  final _controller = PageController();
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  var resp;
  var response;
  ScrollController gridScrollController = ScrollController();
  bool _animate = false;
  var isDisplay = false.obs;
  VoiceCommandsController _voiceCommandsController =
      Get.put(VoiceCommandsController());
  HomeController homeController = Get.find<HomeController>();

  SearchBar? obj;

  @override
  void initState() {
    print("Base url is" + Constants.baseUrl.toString());
    super.initState();
    // gridScrollController =
    homeController.getCartCount();
    gridScrollController.addListener(() async {
      if (gridScrollController.position.pixels ==
          gridScrollController.position.maxScrollExtent) {
        if (paginationData.totalProductsLimit.value == false) {
          paginationData.isLoadingScroll.value = true;
          paginationData.recievedProducts =
              paginationData.recievedProducts + loadMoreSize;
          // paginationData.productList.clear();
          await paginationData.paginationProductsAPi();
          print("scroll limit is reached");
        }
        // _getMoreData();
      }
    });
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  initializeVoiceCommands() {
    setState(() {
      _animate = !_animate;
    });

    showModalBottomSheet(
        isDismissible: true,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => Container(
              width: 300,
              height: 150,
              color: Colors.white54,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/icon/sound.gif',
                      height: 80,
                      width: 200,
                    ),
                    Obx(() {
                      return Text(
                          _voiceCommandsController.speechText.value.toString());
                    })
                  ],
                ),
              ),
            ));
    _voiceCommandsController.listen();

    Timer(
      Duration(
        seconds: 4,
      ),
      () {
        print(
            '99999999999999999Voice command result in UI: ${_voiceCommandsController.speechText.value}');
        if (_voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('open') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('cart')) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCart(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value.toLowerCase().contains('open') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('card')) {
          Navigator.pop(context);
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
          Navigator.pop(context);
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
          Navigator.pop(context);

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
          Navigator.pop(context);

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
          Navigator.pop(context);

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
          Navigator.pop(context);

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
          Navigator.pop(context);

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
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Orders(),
            ),
          );
        } else if (_voiceCommandsController.speechText.value
            .toLowerCase()
            .contains('checkout')) {
          Navigator.pop(context);

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
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MillionMartCheckout(),
            ),
          );
        }else if(_voiceCommandsController.speechText.value
            .toLowerCase()
            .contains('card') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('kar') &&
            _voiceCommandsController.speechText.value
                .toLowerCase()
                .contains('do'))
          {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MillionMartCart(),
              ),
            );
          }

        else {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: 'No matching command');
        }
        _voiceCommandsController.speechText.value = "";
        setState(() {
          _animate = !_animate;
        });
      },
    );
  }

  NetworkController networkController = Get.put(NetworkController());

  @override
  Widget build(BuildContext context) {
    print("Product Data ${controller.productList.toString()}");

    return WillPopScope(onWillPop: () {
      return showWillPopMessage(context);
    }, child: Obx(() {
      return networkController.networkStatus.value == false
          ? NoInternetScreen()
          : Scaffold(
              floatingActionButton: DraggableFab(
                child: AvatarGlow(
                  glowColor: Colors.blue,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  animate: _animate,
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
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(120),
                child: MillionMartAppBar(),
              ),
              drawer: MillionMartDrawer(),
              backgroundColor: Colors.white10,
              // extendBodyBehindAppBar: true,
              body:
                  // controller.productList.isEmpty
                  //     ? SafeArea(
                  //         child: Center(
                  //         child: Text('Data Not Available'),
                  //       ))
                  //     :
                  controller.isLoading.value == true
                      ? Center(
                          child: Image.asset(
                            'assets/icon/mmgif.gif',
                            height: 50,
                            width: 50,
                          ),
                        )
                      : UpgradeAlert(
                          child: GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              } // currentFocus.dispose();
                            },
                            onVerticalDragCancel: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: RefreshIndicator(
                              onRefresh: fetchData,
                              child: SingleChildScrollView(
                                controller: gridScrollController,
                                // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Container(
                                        height: 152.h,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: _placeHolderController
                                              .productList.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 2,
                                            childAspectRatio: 1,
                                          ),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            print(
                                                'Placeholder Data ${_placeHolderController.productList[index]}');
                                            return GestureDetector(
                                              onTap: () {
                                                // voiceSearchController.keyword = _placeHolderController.productList[index]['placeholder_title'];

                                                placeHolderProductsController
                                                    .fetchProducts(
                                                        // 'books-and-office'
                                                        _placeHolderController
                                                            .productList[index][
                                                                'placehoder_category']
                                                            .toString());
                                                Get.to(
                                                    () => PlaceHolderProducts(
                                                          title: Constants
                                                                      .checkLanguage ==
                                                                  "English"
                                                              ? _placeHolderController
                                                                  .productList[
                                                                      index][
                                                                      'placeholder_title']
                                                                  .toString()
                                                              : _placeHolderController
                                                                  .productList[
                                                                      index][
                                                                      'placeholder_tittle_ur']
                                                                  .toString(),
                                                        ));
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl:
                                                          '${_placeHolderController.productList[index]['placeholder_image'].toString()}',
                                                      height: 38.h,
                                                      width: 38.w,
                                                      placeholder: (ctx, url) =>
                                                          Center(
                                                        child: Lottie.asset(
                                                            'assets/svgs/image_loading.json'),
                                                      ),
                                                      errorWidget:
                                                          (ctx, url, e) =>
                                                              Center(
                                                        child: Image.asset(
                                                            "assets/imageNotFound.png"),
                                                      ),
                                                    ),
                                                    // SizedBox(
                                                    //   height: 0.5.h,
                                                    // ),
                                                    Expanded(
                                                      child: Constants
                                                                  .checkLanguage ==
                                                              "English"
                                                          ? Text(
                                                              '${_placeHolderController.productList[index]['placeholder_title']}',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    10.5.sp,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : Text(
                                                              '${_placeHolderController.productList[index]['placeholder_tittle_ur']}',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    10.5.sp,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 16.0,
                                      // ),
                                      Obx(() {
                                        return Container(
                                          width: double.infinity,
                                          // height: 100.0,
                                          margin: EdgeInsets.only(
                                              bottom: 0,
                                              // top: kToolbarHeight * 1.4,
                                              top: 0,
                                              right: 0,
                                              left: 0),
                                          // child: CarouselWithIndicator(),
                                          child: Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                    autoPlay: true,
                                                    enlargeCenterPage: false,
                                                    viewportFraction: 1.0,
                                                    aspectRatio: 2.0,
                                                    onPageChanged:
                                                        (index, reason) {
                                                      _current.value = index;
                                                    }),
                                                items:
                                                    controller.images.map((i) {
                                                  return Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        margin:
                                                            EdgeInsets.all(5.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0)),
                                                          child:
                                                              Stack(children: <
                                                                  Widget>[
                                                            CachedNetworkImage(
                                                              imageUrl:
                                                                  i['photo'],
                                                              fit: BoxFit.fill,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              placeholder:
                                                                  (ctx, url) =>
                                                                      Center(
                                                                child: Lottie.asset(
                                                                    'assets/svgs/image_loading.json'),
                                                              ),
                                                              errorWidget: (ctx,
                                                                      url, e) =>
                                                                  Center(
                                                                child: Image.asset(
                                                                    "assets/imageNotFound.png"),
                                                              ),
                                                            ),
                                                          ]),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: map<Widget>(
                                                  controller.images,
                                                  (index, url) {
                                                    return Container(
                                                      width: 8.0,
                                                      height: 8.0,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.0,
                                                              horizontal: 2.0),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: _current
                                                                      .value ==
                                                                  index
                                                              ? primaryColor
                                                              : Color.fromRGBO(
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  0.1)),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    millionMallHomeTab()),
                                          );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 40.0.h,
                                          color: statusBarColor,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 24),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: ImageIcon(
                                                            AssetImage(
                                                              'assets/image/micon.png',
                                                            ),
                                                            size: 32.0,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Text(
                                                          'million_mall'.tr,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 8),
                                                        child: Row(
                                                          children: [
                                                            Text('see_more'.tr),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios_outlined,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 150.0,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              //borderRadius: BorderRadius.circular(5),
                                              gradient: new LinearGradient(
                                                  colors: [
                                                    MillionMartcolor2,
                                                    blue
                                                  ],
                                                  begin: Alignment.centerRight,
                                                  end: Alignment.centerLeft),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                            height: 100,
                                                            width: 100,
                                                            child: Lottie.asset(
                                                                "assets/svgs/disscount_ani.json"))
                                                        .marginOnly(top: 5),
                                                    Spacer(),
                                                    Container(
                                                      child: Text(
                                                        "Welcome \n to the new \nMillion Mart App",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ).marginOnly(
                                                          left: 0.0, top: 20.0),
                                                    ),
                                                    Spacer(),
                                                    Obx(() {
                                                      return MaterialButton(
                                                        onPressed: () {
                                                          paginationData
                                                              .getFirstOrderDiscount();
                                                        },
                                                        minWidth: 40.0,
                                                        height: 40.0,
                                                        child: paginationData
                                                                    .promoCode ==
                                                                ''
                                                            ? Text(
                                                                "Get Promo Code",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            : Text(
                                                                paginationData
                                                                    .promoCode
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                        color:
                                                            Colors.transparent,
                                                      ).marginOnly(
                                                          right: 10.0,
                                                          top: 40.0);
                                                    }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Obx(() {
                                            return controller
                                                        .productList.length ==
                                                    0
                                                ? Container(
                                                    child: Text(
                                                        "${controller.productList.length}"),
                                                  )
                                                : Container(
                                                    // height: 200,
                                                    // height: double.infinity,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: controller
                                                          .productList.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        Get.log(
                                                            "total sections ${controller.productList}");
                                                        // print("total sections ${controller.productList}");
                                                        // return
                                                        //   return Text(controller.productList[0]["Product"].length.toString());

                                                        return _gridViewSection(
                                                            context, index);
                                                      },
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                    ),
                                                  );
                                          }),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child:
                                                // _getHeading("Collections"),
                                                _getHeading("All Products",
                                                    null, false),
                                          ),
                                          Obx(() {
                                            return paginationData
                                                        .isLoading.value ==
                                                    true
                                                ? CircularProgressIndicator()
                                                : paginationData.productList
                                                            .length ==
                                                        0
                                                    ? Text("No Data Found")
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0),
                                                        child: ScreenTypeLayout(
                                                          mobile: Container(
                                                            child: Column(
                                                              // alignment: Alignment.bottomCenter,
                                                              children: [
                                                                Container(
                                                                  child: GridView
                                                                      .builder(
                                                                    // controller: gridScrollController,
                                                                    // controller: gridScrollController,
                                                                    gridDelegate:
                                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount:
                                                                          2,
                                                                      crossAxisSpacing:
                                                                          2,
                                                                      childAspectRatio: isDisplay.value ==
                                                                              true
                                                                          ? 0.68
                                                                          : 0.72,
                                                                      // crossAxisSpacing: 20,
                                                                      // mainAxisSpacing: 20
                                                                    ),
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5),
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        BouncingScrollPhysics(),
                                                                    // scrollDirection: Axis.horizontal,
                                                                    itemCount: paginationData
                                                                        .productList
                                                                        .length,
                                                                    // paginationData.productList.length,
                                                                    // physics: AlwaysScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
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
                                                                            "${paginationData.productList[index]["store_id"]}",
                                                                        id: paginationData
                                                                            .productList[index]["id"]
                                                                            .toString(),
                                                                        // Todo
                                                                        tag:
                                                                            "${index}2",
                                                                        imagurl:
                                                                            paginationData.productList[index]["photo"],
                                                                        itemname: Constants.checkLanguage ==
                                                                                "English"
                                                                            ? "${paginationData.productList[index]["name"]}"
                                                                            : "${paginationData.productList[index]["name_ur"]}",
                                                                        descprice:
                                                                            "${paginationData.productList[index]["previous_price"]}",
                                                                        price:
                                                                            "${paginationData.productList[index]["price"]}",
                                                                        rating:
                                                                            "${paginationData.productList[index]["rating"]}",
                                                                        slug:
                                                                            "${paginationData.productList[index]["slug"]}",
                                                                        shadow:
                                                                            false,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                paginationData
                                                                        .totalProductsLimit
                                                                        .isTrue
                                                                    ? Text("no_more_products"
                                                                            .tr)
                                                                        .marginOnly(
                                                                            top:
                                                                                20)
                                                                    : paginationData
                                                                            .isLoadingScroll
                                                                            .isTrue
                                                                        ? ItemCardShimmer(
                                                                            length:
                                                                                loadMoreSize,
                                                                          )
                                                                        : SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                          }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
            );
    }));
  }

  showWillPopMessage(context) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Are you sure you want to close Million Mart?'),
          actions: <Widget>[
            TextButton(
                child: Text(
                  'No',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                onPressed: () {
                  Get.back();
                }),
            TextButton(
              //yes button
              child: Text(
                'Yes',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: primaryColor,
              ),
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else {
                  SystemNavigator.pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  _gridViewSection(BuildContext context, int listIndex) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child:
                  // _getHeading("Collections"),
                  _getHeading(
                      "${controller.productList[listIndex]['title']}", 1, true),
            );
          }),
          Obx(() {
            if (controller.productList[listIndex]['sectiontype']
                .toString()
                .contains('Carousel')) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  height: Get.width / 1.7,
                  // width: 300,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount:
                          controller.productList[listIndex]["Product"].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: Get.width / 2.2,
                          // height: 200,
                          // color: Colors.red,
                          child: ItemCard(
                            mmID:
                                "${controller.productList[listIndex]["Product"][index]["store_id"]}",
                            tag: "${index}2",
                            id: "${controller.productList[listIndex]["Product"][index]["id"]}",
                            imagurl:
                                "${controller.productList[listIndex]["Product"][index]["photo"]}",
                            itemname: Constants.checkLanguage == "English"
                                ? "${controller.productList[listIndex]["Product"][index]["name"]}"
                                : "${controller.productList[listIndex]["Product"][index]["name_ur"]}",
                            descprice:
                                "${controller.productList[listIndex]["Product"][index]["previous_price"]}",
                            price:
                                "${controller.productList[listIndex]["Product"][index]["price"]}",
                            rating: controller
                                    .productList[listIndex]["Product"][index]
                                        ["rating"]
                                    .isEmpty
                                ? "null"
                                : "${controller.productList[listIndex]["Product"][index]["rating"][0]["rating"]}",
                            slug:
                                "${controller.productList[listIndex]["Product"][index]["slug"]}",
                            shadow: false,
                          ),
                        );
                        //   Card(
                        //  color: Colors.red,
                        //  child: Container(
                        //      width: 140,
                        //      child: Text("data")),
                        // );
                      }),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ScreenTypeLayout(
                  mobile: Container(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 0.72,
                            // crossAxisSpacing: 20,
                            // mainAxisSpacing: 20
                          ),
                          padding: EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          // scrollDirection: Axis.horizontal,
                          itemCount: controller
                              .productList[listIndex]["Product"].length,
                          itemBuilder: (BuildContext context, index) {
                            return ItemCard(
                              mmID:
                                  "${controller.productList[listIndex]["Product"][index]["store_id"]}",
                              tag: "${index}2",
                              id: "${controller.productList[listIndex]["Product"][index]["id"]}",
                              imagurl:
                                  "${controller.productList[listIndex]["Product"][index]["photo"]}",
                              itemname: Constants.checkLanguage == "English"
                                  ? "${controller.productList[listIndex]["Product"][index]["name"]}"
                                  : "${controller.productList[listIndex]["Product"][index]["name_ur"]}",
                              descprice:
                                  "${controller.productList[listIndex]["Product"][index]["previous_price"]}",
                              price:
                                  "${controller.productList[listIndex]["Product"][index]["price"]}",
                              rating: controller
                                      .productList[listIndex]["Product"][index]
                                          ["rating"]
                                      .isEmpty
                                  ? "null"
                                  : "${controller.productList[listIndex]["Product"][index]["rating"][0]["rating"]}",
                              slug:
                                  "${controller.productList[listIndex]["Product"][index]["slug"]}",
                              shadow: false,
                            );
                          })),
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  _scrollListener() {
    print("Controller Listening");
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("reach to bottom");
      setState(() {
        // message = "reach the bottom";
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print("reach the top");
      setState(() {
        // message = "reach the top";
      });
    }
  }

  _getHeading(String title, int? indexOfAPI, bool viewAll) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.headline6),
              GestureDetector(
                child: Text(
                  viewAll ? seeAll : "",
                  style: Theme.of(context).textTheme.caption,
                ),
                // splashColor: primaryColor.withOpacity(0.2),
                onTap: () {
                  Constants.apiIndex = indexOfAPI!;
                  print('App View ALL ${Constants.apiIndex}');
                  // print(Constants.viewAllAPI[Constants.apiIndex]);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(seconds: 0),
                        pageBuilder: (_, __, ___) =>
                            MillionMartStaggeredList()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<T> map<T>(List homeSliderList, Function handler) {
    List<T> result = [];
    for (var i = 0; i < homeSliderList.length; i++) {
      result.add(handler(i, homeSliderList[i]));
    }

    return result;
  }
}

class ItemCardSmall extends StatelessWidget {
  const ItemCardSmall({
    Key? key,
    this.id,
    required this.imagurl,
    required this.rating,
    required this.itemname,
    required this.descprice,
    required this.price,
    required this.shadow,
    required this.slug,
  }) : super(key: key);
  final String? id;
  final String imagurl, rating, itemname, descprice, price, slug;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: MillionMartcolor5, blurRadius: 10)],
      ),
      child: Card(
        elevation: 0.0,
        child: GestureDetector(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: CachedNetworkImage(
                          imageUrl: imagurl,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
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
                              rating,
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
                Text(
                  itemname,
                  style: Theme.of(context).textTheme.overline!.copyWith(
                      color: Colors.black, fontSize: 16.0, letterSpacing: 0.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 5),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(CUR_CURRENCY + "" + descprice,
                              style: Theme.of(context)
                                  .textTheme
                                  .overline!
                                  .copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      letterSpacing: 1),
                              textAlign: TextAlign.left),
                          Text(
                            CUR_CURRENCY + " " + price,
                            style: TextStyle(color: primaryColor),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            child: Icon(
                              Icons.favorite,
                              size: 15,
                              color: primaryColor,
                            ),
                          ),
                          onTap: () {})
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  const ItemCard(
      {Key? key,
      required this.id,
      required this.imagurl,
      required this.rating,
      required this.itemname,
      required this.descprice,
      required this.price,
      required this.shadow,
      required this.tag,
      required this.slug,
      required this.mmID,
      this.similarPro})
      : super(key: key);

  final String id, mmID;
  final String imagurl, rating, itemname, descprice, price, tag, slug;
  final bool shadow;
  final bool? similarPro;

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    var discount = "0";
    if (int.parse(widget.descprice.split('.')[0]) >
        int.parse(widget.price.split('.')[0])) {
      discount = (((int.parse(widget.descprice.split('.')[0]) -
                  int.parse(widget.price.split('.')[0])) *
              100 /
              int.parse(widget.descprice.split('.')[0]))
          .toString()
          .split('.')[0]);
    }
    print("Million Mall id is " + widget.mmID.toString());
    // ProductController productController = Get.put(ProductController(widget.slug));
    return Card(
      elevation: 1.5,
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  // height: 160.0,

                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.imagurl,
                      placeholder: (ctx, url) => Center(
                        child: Lottie.asset('assets/svgs/image_loading.json'),
                      ),
                      errorWidget: (ctx, url, e) => Center(
                        child: Image.asset("assets/imageNotFound.png"),
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          discount == "0"
                              ? SizedBox()
                              : Card(
                                  child: Text(
                                    '$discount% off',
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline!
                                        .copyWith(
                                            // decoration: TextDecoration.lineThrough,
                                            color: Colors.orange,
                                            letterSpacing: 0),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ).marginAll(2.0),
                                ),
                        ],
                      ),
                      Spacer(),
                      widget.mmID.contains('1')
                          ? Card(
                              color: primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  'MM',
                                  style: Theme.of(context)
                                      .textTheme
                                      .overline!
                                      .copyWith(
                                          color: Colors.white,
                                          letterSpacing: 0),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ).marginAll(2.0),
                              ),
                            )
                          : SizedBox(),
                      Spacer(),
                      Card(
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: widget.rating.toString() == 'null'
                                  ? Colors.grey
                                  : Colors.yellow,
                              size: 10,
                            ),
                            widget.rating.toString() == 'null'
                                ? Text(
                                    "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline!
                                        .copyWith(letterSpacing: 0.2),
                                  )
                                : Text(
                                    widget.rating,
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline!
                                        .copyWith(letterSpacing: 0.2),
                                  ),
                          ],
                        ).marginAll(2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: Get.width / 2.4,
                  child: Text(
                    widget.itemname.trim(),
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
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        "Rs",
                        // style: TextStyle(color: primaryLight2),
                        style: TextStyle(
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        " " + widget.price.split('.')[0],
                        // style: TextStyle(color: primaryLight2),
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        "Rs" + "" + widget.descprice.split('.')[0],
                        style: Theme.of(context).textTheme.overline!.copyWith(
                            decoration: TextDecoration.lineThrough,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ],
              ).marginOnly(left: 2.0, right: 2.0),
            ),
          ],
        ),
        onTap: () {
          if (widget.similarPro == true) {
            Get.delete<ProductController>();
            ProductController _controller =
                Get.put(ProductController(widget.slug, widget.id));
            _controller.isLoading.value = true;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MillionMartProductDetail(
                  imgurl: widget.imagurl,
                  tag: widget.tag,
                  slug: '${widget.slug}',
                  productController: _controller,
                ),
              ),
            );
          } else {
            final ProductController productController =
                Get.put(ProductController(widget.slug, widget.id));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MillionMartProductDetail(
                  imgurl: widget.imagurl,
                  tag: widget.tag,
                  slug: '${widget.slug}',
                  productController: productController,
                ),
              ),
            );
          }
          print(widget.id.toString() + Constants.userID.toString());

          // final AskQuestions _askQue = Get.put(AskQuestions(Constants.userID,widget.id));
        },
      ),
    );
  }
}

class ItemCardShimmer extends StatefulWidget {
  final length;

  const ItemCardShimmer({Key? key, required this.length}) : super(key: key);

  @override
  _ItemCardShimmerState createState() => _ItemCardShimmerState();
}

class _ItemCardShimmerState extends State<ItemCardShimmer> {
  @override
  Widget build(BuildContext context) {
    print("Shimmer effect Called");
    return Container(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 0.72,
          // crossAxisSpacing: 20,
          // mainAxisSpacing: 20
        ),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                child: Card(
                  elevation: 1.5,
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              // height: 160.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: Get.width / 2.4,
                            ),
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, right: 4.0, bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: [],
                              ),
                              Column(
                                children: [],
                              ),
                              Spacer(),
                              Column(
                                children: [],
                              ),
                            ],
                          ).marginOnly(left: 2.0, right: 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
