import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PlaceHolderProdcutsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/VoiceSearchController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartRequestProduct.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartpHomeTab.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';

class PlaceHolderProducts extends StatefulWidget {
  const PlaceHolderProducts({Key? key,required this.title}) : super(key: key);

  final String title;
  @override
  _PlaceHolderProductsState createState() => _PlaceHolderProductsState();
}

class _PlaceHolderProductsState extends State<PlaceHolderProducts> {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop();
    return true;
  }

  void _filterModalBottomSheet(context) {
    final min = new TextEditingController();
    final max = new TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        width: 100,
                        height: 36,
                      ),
                      child: TextField(
                        controller: min,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(4),
                          hintText: 'Min',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        width: 100,
                        height: 36,
                      ),
                      child: TextField(
                        controller: max,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(4),
                          hintText: 'Max',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
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
                        if(min.text.isEmpty && max.text.isEmpty){
                          Get.snackbar(
                            "error".tr,
                            "fullFields".tr,
                            backgroundColor: notificationBackground,
                            colorText: notificationTextColor,
                          );
                        }
                        else{
                          Get.find<VoiceSearchController>()
                              .fetchFilteredProducts(min.text, max.text);
                          Get.back();
                          FocusScope.of(context).unfocus();
                        }
                        // Get.find<VoiceSearchController>().isLoading.value = true;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Obx(
            () {
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Get.find<PlaceholderProductsController>().isLoading.value
                ? Scaffold(
              body: Center(
                child: Image.asset(
                  'assets/icon/mmgif.gif',
                  height: 50,
                  width: 50,
                ),
              ),
            )
                : Scaffold(
                appBar: AppBar(
                  // actions: [
                  //   IconButton(
                  //     onPressed: () {
                  //       _filterModalBottomSheet(context);
                  //     },
                  //     icon: Icon(Icons.filter_alt_rounded),
                  //   )
                  // ],
                  iconTheme: IconThemeData(color: Color(0xFF0A3966)),
                  backgroundColor: Color(0xFFAED0F3),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: primaryColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    widget.title,
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  // backgroundColor: Colors.white,
                ),
                body: Get.find<PlaceholderProductsController>().placeholderProductList.isEmpty
                    ? Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'This product is not found',
                          style: TextStyle(
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
                            )),
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
                    padding: EdgeInsets.only(top: 5),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: Get.find<PlaceholderProductsController>()
                        .placeholderProductList[0]
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      print("val is here ${Get.find<PlaceholderProductsController>().placeholderProductList[0][0].toString()}");
                      return ItemCard(
                        mmID: "${
                            int.tryParse(Get.find<PlaceholderProductsController>()
                                .placeholderProductList[0][index]['store_id'])}",
                        tag: "${index}2",
                        imagurl: Get.find<PlaceholderProductsController>()
                            .placeholderProductList[0][index]['photo'],

                        itemname:Constants.checkLanguage=="English"? Get.find<PlaceholderProductsController>()
                            .placeholderProductList[0][index]['name']:Get.find<PlaceholderProductsController>()
                            .placeholderProductList[0][index]['name_ur'],
                        descprice: Get.find<PlaceholderProductsController>()
                            .placeholderProductList[0][index]['previous_price'].toString(),
                        price: Get.find<PlaceholderProductsController>()
                            .placeholderProductList[0][index]['price'].toString(),
                        rating: "",
                        id: Get.find<PlaceholderProductsController>()
                            .placeholderProductList[0][index]['id']
                            .toString(),
                        shadow: false,
                        slug: Get.find<PlaceholderProductsController>()
                            .placeholderProductList[0][index]['slug'],
                        // rating: Get.find<VoiceSearchController>().productList[index]['rating']??"",
                      );
                    },
                  ),
                ).marginOnly(left: 10.0, right: 10.0)),
          );
        },
      ),
    );
  }
}
