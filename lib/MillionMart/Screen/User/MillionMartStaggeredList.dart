import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PaginationProductsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/ViewAllProductController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartpHomeTab.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MillionMartStaggeredList extends StatefulWidget {
  MillionMartStaggeredList({Key? key}) : super(key: key);

  @override
  _MillionMartStaggeredListState createState() =>
      _MillionMartStaggeredListState();
}

// ViewAllProductController _controller;
class _MillionMartStaggeredListState extends State<MillionMartStaggeredList> {
  // late ViewAllProductController _controller;
  PaginationDataController paginationData = Get.put(PaginationDataController());
  var isDisplay = false.obs;

  @override
  void initState() {
    // _controller = Get.put(ViewAllProductController());
    // TODO: implement initState
    super.initState();

    // print("Oninit View All Pro Data " + _controller.allProductList.toString());
    // print("page created");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: primaryColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "All Products",
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
              backgroundColor: Color(0xFFAED0F3),
              centerTitle: true,
            ),
            body: paginationData.isLoading.value == true
                ? CircularProgressIndicator()
                : paginationData.productList.length == 0
                    ? Text("No Data Found")
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: ScreenTypeLayout(
                          mobile: SingleChildScrollView(
                            child: Column(
                              // alignment: Alignment.bottomCenter,
                              children: [
                                GridView.builder(
                                  // controller: gridScrollController,
                                  // controller: gridScrollController,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2,
                                    childAspectRatio:
                                        isDisplay.value == true ? 0.68 : 0.72,
                                    // crossAxisSpacing: 20,
                                    // mainAxisSpacing: 20
                                  ),
                                  padding: EdgeInsets.only(top: 5),
                                  shrinkWrap: true,
                                  // scrollDirection: Axis.horizontal,
                                  itemCount: paginationData.productList.length,
                                  // paginationData.productList.length,
                                  physics: ScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                      id: paginationData.productList[index]
                                              ["id"]
                                          .toString(),
                                      // Todo
                                      tag: "${index}2",
                                      imagurl: paginationData.productList[index]
                                          ["photo"],
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
                                      shadow: false,
                                    );
                                  },
                                ),
                                paginationData.totalProductsLimit.isTrue
                                    ? Text("no_more_products".tr)
                                        .marginOnly(top: 20)
                                    : paginationData.isLoadingScroll.isTrue
                                        ? ItemCardShimmer(
                                            length: loadMoreSize,
                                          )
                                        : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      )
            // StaggeredGridView.countBuilder(
            //     crossAxisCount: 2,
            //     itemCount: _controller.allProductList.length,
            //     staggeredTileBuilder: (index) {
            //       return new StaggeredTile.fit(1);
            //     },
            //     itemBuilder: (context, index) {
            //       return GestureDetector(
            //         onTap: () {},
            //         child:
            //         // Container(
            //         //   decoration: BoxDecoration(
            //         //       borderRadius: BorderRadius.circular(10.0)),
            //         //   child: StaggerdCard(
            //         //     imgurl: _controller.allProductList[index]['photo']
            //         //         .toString(),
            //         //     itemname: _controller.allProductList[index]['name']
            //         //         .toString(),
            //         //     descprice: _controller.allProductList[index]
            //         //             ['previous_price']
            //         //         .toString(),
            //         //     price: _controller.allProductList[index]['price']
            //         //         .toString(),
            //         //     rating: '',
            //         //     // rating: _listUrl[index]['rating'],
            //         //   ),
            //         // ),
            //       );
            //     }),
            ),
      );
    });
  }
}

// class StaggerdCard extends StatefulWidget {
//   StaggerdCard(
//       {Key? key,
//       required this.imgurl,
//       required this.rating,
//       required this.itemname,
//       required this.price,
//       required this.descprice})
//       : super(key: key);
//   final String imgurl, rating, itemname, price, descprice;

//   @override
//   _StaggerdCardState createState() => _StaggerdCardState();
// }

// class _StaggerdCardState extends State<StaggerdCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(5), topRight: Radius.circular(5)),
//       ),
//       child: Card(
//         elevation: 1.0,
//         child: Column(
//           children: [
//             Stack(
//               alignment: Alignment.topRight,
//               children: [
//                 ClipRRect(
//                   borderRadius: widget.itemname != null
//                       ? BorderRadius.only(
//                           topLeft: Radius.circular(5),
//                           topRight: Radius.circular(5))
//                       : BorderRadius.circular(5.0),
//                   child: CachedNetworkImage(
//                     imageUrl: widget.imgurl,
//                     fit: BoxFit.fill,
//                     width: double.infinity,
//                   ),
//                 ),
//                 widget.rating != null
//                     ? Card(
//                         child: Padding(
//                         padding: const EdgeInsets.all(1.5),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.star,
//                               color: Colors.yellow,
//                               size: 10,
//                             ),
//                             Text(
//                               widget.rating,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .overline!
//                                   .copyWith(letterSpacing: 0.2),
//                             ),
//                           ],
//                         ),
//                       ))
//                     : Container(),
//               ],
//             ),
//             widget.itemname != null
//                 ? Padding(
//                     padding: const EdgeInsets.all(0.0),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Expanded(
//                           child: Text(
//                             widget.itemname,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .overline!
//                                 .copyWith(
//                                     color: Colors.black,
//                                     fontSize: 16.0,
//                                     letterSpacing: 0.5),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Container(),
//             widget.price != null
//                 ? Padding(
//                     padding: const EdgeInsets.only(left: 5.0, bottom: 5),
//                     child: Row(
//                       children: <Widget>[
//                         Row(
//                           children: [
//                             Text(
//                               " " + CUR_CURRENCY,
//                               style: TextStyle(color: Colors.blue[900]),
//                             ),
//                             Text(
//                               " " + widget.price.split('.')[0],
//                               style: TextStyle(color: Colors.orange),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 5.0,
//                         ),
//                         widget.price != null
//                             ? Text(
//                                 CUR_CURRENCY +
//                                     "" +
//                                     widget.descprice.split('.')[0],
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .overline!
//                                     .copyWith(
//                                         decoration: TextDecoration.lineThrough,
//                                         letterSpacing: 1),
//                               )
//                             : Container(),
//                       ],
//                     ),
//                   )
//                 : Container()
//           ],
//         ),
//       ),
//     );
//   }
// }
