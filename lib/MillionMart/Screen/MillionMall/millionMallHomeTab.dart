import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/MillionMallController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartpHomeTab.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartDrawer.dart';

import 'millionMallAppBar.dart';

class millionMallHomeTab extends StatefulWidget {
  // const millionMallHomeTab({Key? key}) : super(key: key);

  @override
  _millionMallHomeTabState createState() => _millionMallHomeTabState();
}

class _millionMallHomeTabState extends State<millionMallHomeTab> {
  MillionMallController _millionMallHome = Get.find<MillionMallController>();
  int _current = 0;
  final CarouselController _controller = CarouselController();
  MillionMallController mmController = Get.find<MillionMallController>();
  ScrollController gridScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // gridScrollController =
    gridScrollController.addListener(() async {
      if (gridScrollController.position.pixels ==
          gridScrollController.position.maxScrollExtent) {
        if (mmController.mmTotalProductsLimit.value == false) {
          mmController.isLoadingMore.value = true;
          mmController.mmrRecievedProducts =
              mmController.mmrRecievedProducts + 10;
          // paginationData.productList.clear();
          await mmController.millMallProductsData();
          print("scroll limit is reached");
        }
        // _getMoreData();
      }
    });
  }

  // List<T> mapIt<T>(List homeSliderList, Function handler) {
  //   List<T> result = [];
  //   for (var i = 0; i < homeSliderList.length; i++) {
  //     result.add(handler(i, homeSliderList[i]));
  //   }
  //
  //   return result;
  // }
  var current = 0.obs;

  @override
  Widget build(BuildContext context) {
    print(_millionMallHome.millionMallProducts);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icon/mmicon.png',
          width: 135.0,
          // height: 18.0,
          fit: BoxFit.cover,
        ),
        centerTitle: false,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        backgroundColor: Color(0xFFAED0F3),
      ),
      // drawer: MillionMartDrawer(),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Obx(
        () {
          return mmController.loadingData.value == false
              ? SafeArea(child: Center(child: CircularProgressIndicator()))
              : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: fetchData,
                    child: SingleChildScrollView(
                      controller: gridScrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          // Container(
                          //   // height: 60,
                          //   color: Color(0xFFAED0F3),
                          //   child: Column(
                          //     children: [
                          //       PreferredSize(
                          //         preferredSize: Size.zero,
                          //         child: Padding(
                          //           padding: const EdgeInsets.only(
                          //             top: 12.0,
                          //               left: 12.0, right: 12.0, bottom: 5.0),
                          //           child: SearchBar(),
                          //         ),
                          //         // preferredSize: Size.fromHeight(120),
                          //       ),
                          //       // Container(
                          //       //   child: Center(
                          //       //     child: CachedNetworkImage(
                          //       //       imageUrl: img,
                          //       //       fit: BoxFit.fill,
                          //       //       width: 340.0,
                          //       //       height: 245,
                          //       //       // height: double.infinity,
                          //       //     ),
                          //       //   ),
                          //       // ),
                          //       // CarouselSlider.builder(
                          //       //   itemCount: images.length,
                          //       //   options: CarouselOptions(
                          //       //       autoPlay: true,
                          //       //       aspectRatio: 2.0,
                          //       //       enlargeCenterPage: false,
                          //       //       viewportFraction: 1.0,
                          //       //       onPageChanged: (index, reason) {
                          //       //         setState(() {
                          //       //           _current = index;
                          //       //         });
                          //       //       }
                          //       //
                          //       //   ),
                          //       //   itemBuilder: (context, index, realIdx) {
                          //       //     return Padding(
                          //       //       padding: const EdgeInsets.all(8.0),
                          //       //       child: Container(
                          //       //         child: Center(
                          //       //           child:CachedNetworkImage(
                          //       //             imageUrl: images[index],
                          //       //             fit: BoxFit.fill,
                          //       //             width: 1000.0,
                          //       //             height: double.infinity,
                          //       //           ),),
                          //       //       ),
                          //       //     );
                          //       //   },
                          //       // ),
                          //       // Row(
                          //       //   mainAxisAlignment: MainAxisAlignment.center,
                          //       //   children: images.asMap().entries.map((entry) {
                          //       //     return GestureDetector(
                          //       //       onTap: () => _controller.animateToPage(entry.key),
                          //       //       child: Container(
                          //       //         width: 8.0,
                          //       //         height: 8.0,
                          //       //         margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          //       //         decoration: BoxDecoration(
                          //       //             shape: BoxShape.circle,
                          //       //             color: (Theme.of(context).brightness == Brightness.dark
                          //       //                 ? Colors.white
                          //       //                 : Colors.black)
                          //       //                 .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                          //       //       ),
                          //       //     );
                          //       //   }).toList(),
                          //       // ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            child: CachedNetworkImage(
                              placeholder: (ctx, url) => Center(
                                child: Lottie.asset(
                                    'assets/svgs/image_loading.json'),
                              ),
                              imageUrl: _millionMallHome.millionMallSlider[0],
                              fit: BoxFit.fill,
                              width: double.infinity,
                              // height:  double.infinity,
                            ),
                          ),
                          Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              itemCount: _millionMallHome
                                  .millionMallHomeBannersData.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Center(
                                      child: CachedNetworkImage(
                                        placeholder: (ctx, url) => Center(
                                          child: Lottie.asset(
                                              'assets/svgs/image_loading.json'),
                                        ),
                                        imageUrl: _millionMallHome
                                                .millionMallHomeBannersData[
                                            index]['banner'],
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        // height:  double.infinity,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Center(
                              child: Text(
                            "Million Mall Products",
                            style: TextStyle(
                              fontSize: 24,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          Column(
                            children: [
                              Container(
                                child: GridView.builder(
                                  // controller: gridScrollController,
                                  // controller: gridScrollController,
                                  // controller: gridScrollController,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.72,
                                    // crossAxisSpacing: 20,
                                    // mainAxisSpacing: 20
                                  ),
                                  padding: EdgeInsets.only(top: 5),
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  // scrollDirection: Axis.horizontal,
                                  itemCount:
                                      mmController.millionMallProducts.length,
                                  // paginationData.productList.length,
                                  // physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // return mmController.mmTotalProductsLimit.value == true?Text("No more Products"):index ==  mmController.millionMallProducts.length?Center(child: CircularProgressIndicator()):
                                    return ItemCard(
                                      mmID:
                                          "${mmController.millionMallProducts[index]["store_id"]}",
                                      id: mmController
                                          .millionMallProducts[index]["id"]
                                          .toString(),
                                      tag: "${index}2",
                                      imagurl: mmController
                                          .millionMallProducts[index]["photo"],
                                      itemname: mmController
                                          .millionMallProducts[index]["name"],
                                      descprice:
                                          "${mmController.millionMallProducts[index]["previous_price"]}",
                                      price:
                                          "${mmController.millionMallProducts[index]["price"]}",
                                      rating:
                                          "${mmController.millionMallProducts[index]["rating"]}",
                                      slug:
                                          "${mmController.millionMallProducts[index]["slug"]}",
                                      shadow: false,
                                    );
                                  },
                                ),
                              ),
                              _millionMallHome.mmTotalProductsLimit.isTrue
                                  ? Text("No more Products to load")
                                      .marginOnly(top: 20)
                                  : _millionMallHome.isLoadingMore.isTrue
                                      ? Center(
                                          child: ItemCardShimmer(
                                            length: loadMoreSize,
                                          ),
                                        )
                                      : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
