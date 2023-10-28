import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/GetBargainController.dart';
import 'package:get/get.dart';

class BargainScreen extends StatelessWidget {
  final BargainController bargainController = Get.put(BargainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'bargain_items'.tr,
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFAED0F3),
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        ),
        body: GetBuilder<BargainController>(builder: (_) {
          return _.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _.bargainItemsData.length == 0
                  ? Container(
                      child: Center(
                        child: Text("No Items"),
                      ),
                    )
                  : Container(
                      child: ListView.builder(
                        itemCount: _.bargainItemsData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ExpansionTile(
                              iconColor: primaryColor,
                              textColor: primaryColor,
                              collapsedIconColor: primaryColor,
                              collapsedTextColor: primaryColor,
                              title: Text(
                                "Product Name",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                      "${_.bargainItemsData[index].prodcut_name!}")
                                  .marginOnly(top: 10.0),
                              // leading: Icon(
                              //   Icons.shopping_cart,
                              //   color: primary,
                              // ),
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: Get.width / 2.25,
                                      child: Text(
                                        "Product Image",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width / 2.25,
                                      child: AspectRatio(
                                        aspectRatio: 15 / 16,
                                        child: ClipOval(
                                          child: FadeInImage.assetNetwork(
                                            fit: BoxFit.cover,
                                            image:
                                                '${_.bargainItemsData[index].photo!}',
                                            placeholder:
                                                "assets/image/micon.png",
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ).marginOnly(left: 10.0, right: 10.0),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: Get.width / 2.25,
                                      child: Text(
                                        "Price",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width / 2.25,
                                      child: Text(
                                        "${_.bargainItemsData[index].competitorPrice}",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ).marginOnly(left: 10.0, right: 10.0),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: Get.width / 2.25,
                                      child: Text(
                                        "Link",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width / 2.25,
                                      child: Text(
                                        "${_.bargainItemsData[index].competitorLink}",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ).marginOnly(left: 10.0, right: 10.0),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      color: Colors.white10,
                    );
        }));
  }
}
