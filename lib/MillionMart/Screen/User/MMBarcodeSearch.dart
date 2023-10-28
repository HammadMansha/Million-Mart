import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartRequestProduct.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartpHomeTab.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartAppBar.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';


class QRSearchProducts extends StatefulWidget {
  const QRSearchProducts({Key? key}) : super(key: key);

  @override
  _QRSearchProductsState createState() => _QRSearchProductsState();
}

class _QRSearchProductsState extends State<QRSearchProducts> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qrIsLoadingProducts.value = true;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    qrImageSearchData.clear();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    qrImageSearchData.clear();
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {


    return Obx((){
      return WillPopScope(
        onWillPop: _onWillPop,
        child: qrIsLoadingProducts.value? Scaffold(body: Center(child:  Column(
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
            Text("It may take a while to load.\n"
                "Don't press back",textAlign: TextAlign.center,),
          ],
        ),),):Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color(0xFF0A3966)),
            backgroundColor: Color(0xFFAED0F3),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: primaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("All Products", style: TextStyle(
              color: primaryColor,
            ),),
            // backgroundColor: Colors.white,
          ),
          body:qrImageSearchData.isEmpty? Scaffold(body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('This product is not found', style: TextStyle(
                fontSize: 16,
              ),),
              // SizedBox(height:8,),
              Container(
                  width: 240,
                  child: AppBtn(title: "Request Item", onBtnSelected: (){ Get.to(()=>RequestProduct());},)),
            ],
          ),),): Container(
            width: Get.width,
            child: StaggeredGridView.countBuilder(
                crossAxisCount: 1,
                itemCount: qrImageSearchData.length,
                staggeredTileBuilder: (index) {
                  return new StaggeredTile.fit(1);
                },
                itemBuilder: (context, index) {
                  return Container(
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
                      itemCount: qrImageSearchData.length,
                      itemBuilder:
                          (BuildContext context,
                          int index) {
                        return ItemCard(
                          tag: "${index}2".toString(),
                          mmID: "${qrImageSearchData[0][index]['store_id']}",
                          imagurl: "${qrImageSearchData[0][index]['photo']}",
                          itemname: "${qrImageSearchData[0][index]['name']}",
                          descprice:"${qrImageSearchData[0][index]['previous_price']}" ,
                          price: "${qrImageSearchData[0][index]['price']}",
                          rating: "${qrImageSearchData[0][index]['price']}",
                          id:     "${qrImageSearchData[0][index]['id']}",
                          shadow: false,
                          slug: "${qrImageSearchData[0][index]['slug']}",
                          // rating: Get.find<VoiceSearchController>().productList[index]['rating']??"",
                        );
                      },
                    ),
                  ).marginOnly(left: 10.0 , right: 10.0);
                }),
          ),
        ),
      );
    });

  }
}



