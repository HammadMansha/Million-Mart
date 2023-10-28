
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/allproductController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartpHomeTab.dart';


class MillionMallAllProduct extends StatelessWidget {
  MillionMallAllProduct({this.title});
  final String? title;
  final ALlProductController aLlProductController =
  Get.put(ALlProductController());

  @override
  Widget build(BuildContext context) {
    print("Page Title : "+title.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title??"All Products",
          style: TextStyle(
            color: Color(0xFF0A3966),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFAED0F3),
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      ),
      body: bodyData(context),
    );
  }

  Widget bodyData(BuildContext context) {
    return GetBuilder<ALlProductController>(
      builder: (_) {
        return Container(
          child: GridView.builder(
            // controller: gridScrollController,
            gridDelegate:
             SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              // maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
            ),
          
            padding:
            EdgeInsets.only(top: 5),
            shrinkWrap: true,
            physics:
            BouncingScrollPhysics(),
            itemCount: _.paginationDataController
                .productList.length,
            itemBuilder:
                (BuildContext context,
                int index) {
              return ItemCard(
                mmID: "${_.paginationDataController.productList[index]["store_id"]}",
                id: _.paginationDataController.productList[index]["id"].toString(),
                tag: "${index}2",
                imagurl: _.paginationDataController.productList[index]["photo"],
                itemname: _.paginationDataController.productList[index]["name"],
                descprice: "${_.paginationDataController.productList[index]["previous_price"]}",
                price:
                "${_.paginationDataController.productList[index]["price"]}",
                rating:
                "${_.paginationDataController.productList[index]["rating"]}",
                slug:
                "${_.paginationDataController.productList[index]["slug"]}",
                shadow: false,
              );
            },
          ),
        ).marginOnly(left: 10.0 , right: 10.0);
      },
    );
  }

}
