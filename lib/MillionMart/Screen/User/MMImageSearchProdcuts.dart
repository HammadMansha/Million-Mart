import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartRequestProduct.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartpHomeTab.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';
import 'package:millionmart_cleaned/MillionMart/widget/SearchBar.dart';


class ImageSearchProducts extends StatefulWidget {
  const ImageSearchProducts({Key? key}) : super(key: key);

  @override
  _ImageSearchProductsState createState() => _ImageSearchProductsState();
}

class _ImageSearchProductsState extends State<ImageSearchProducts> {
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    imageSearchData.clear();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    imageSearchData.clear();
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: isLoadingProducts.value
            ? Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon/mmgif.gif',
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "It may take a while\n"
                        "Don't press back",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Color(0xFF0A3966)),
                  backgroundColor: Color(0xFFAED0F3),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: primaryColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    "Search Result",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  // backgroundColor: Colors.white,
                ),
                body: imageSearchData.length == 0
                    ? Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('This product is not found', style: TextStyle(
                                fontSize: 16,
                              ),
                              ),
                              // SizedBox(height:8,),
                              Container(
                                  width: 240,
                                  child: AppBtn(
                                    title: "Request Item",
                                    onBtnSelected: () {
                                      Get.to(() => RequestProduct());
                                    },
                                  ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                  child: GridView.builder(
                    // controller: gridScrollController,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 0.72,
                    ),
                    padding:
                    EdgeInsets.only(top: 5),
                    shrinkWrap: true,
                    physics:
                    BouncingScrollPhysics(),
                    itemCount: imageSearchData.length,
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return ItemCard(
                        mmID: "${imageSearchData[index]['store_id']}",
                        tag: "${index}2",
                        imagurl: imageSearchData[index]['photo'],
                        itemname: imageSearchData[index]['name'],
                        descprice: imageSearchData[index]['previous_price'].toString(),
                        price: imageSearchData[index]['price'].toString(),
                        rating: "",
                        id: imageSearchData[index]['id'].toString(),
                        shadow: false,
                        slug: imageSearchData[index]['slug'],
                        // rating: Get.find<VoiceSearchController>().productList[index]['rating']??"",
                      );
                    },
                  ),
                ).marginOnly(left: 10.0 , right: 10.0)
              ),
      );
    });
  }
}

