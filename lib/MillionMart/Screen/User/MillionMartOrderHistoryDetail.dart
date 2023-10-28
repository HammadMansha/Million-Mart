import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/orderHistoryController.dart';
// import 'package:rating_dialog/rating_dialog.dart';

class OrderProducts extends StatelessWidget {
  final OrderHistoryController orderHistoryController =
      Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(
            'order_details'.tr,
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          backgroundColor: Color(0xFFAED0F3),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        ),
        body: bodyData(context));
  }

  Widget bodyData(context) {
    return GetBuilder<OrderHistoryController>(
      builder: (_) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _.orderHistorydetail.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: Get.width / 2.25,
                                child: texttitle("name".tr)),
                            Container(
                                width: Get.width / 2.25,
                                child: textsubtitle(
                                    "${_.orderHistorydetail[index]['customer_name']}")),
                          ],
                        ),
                        spacing(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: Get.width / 2.25,
                                child: texttitle("email".tr)),
                            Container(
                                width: Get.width / 2.25,
                                child: textsubtitle(
                                    "${_.orderHistorydetail[index]['customer_email']}")),
                          ],
                        ),
                        spacing(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: Get.width / 2.25,
                                child: texttitle("phone_number".tr)),
                            Container(
                                width: Get.width / 2.25,
                                child: textsubtitle(
                                    "${_.orderHistorydetail[index]['customer_phone']}")),
                          ],
                        ),
                        spacing(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: Get.width / 2.25,
                                child: texttitle("address".tr)),
                            Container(
                                width: Get.width / 2.25,
                                child: textsubtitle(
                                    "${_.orderHistorydetail[index]['customer_address']}")),
                          ],
                        ),
                        spacing(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: Get.width / 2.25,
                                child: texttitle("payment_method".tr)),
                            Container(
                                width: Get.width / 2.25,
                                child: textsubtitle(
                                    "${_.orderHistorydetail[index]['payment_method']}")),
                          ],
                        ),
                        spacing(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: Get.width / 2.25,
                                child: texttitle("status".tr)),
                            Container(
                                width: Get.width / 2.25,
                                child: textsubtitle(
                                    "${_.orderHistorydetail[index]['payment_status']}")),
                          ],
                        ),
                        spacing(),
                        items(
                            _,
                            _.orderHistorydetail[index]['items'],
                            context,
                            _.orderHistorydetail[index]['payment_status']
                                .toString()
                                .toLowerCase()),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ).marginOnly(left: 10.0, right: 10.0, top: 20.0);
      },
    );
  }

  Widget texttitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
        color: Color(0xFF0A3966),
      ),
    );
  }

  Widget textsubtitle(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.black,
      ),
    );
  }

  Widget spacing() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget items(OrderHistoryController _, var itemdata, context, status) {
    // _.itemlist.clear();
    String key = itemdata.keys.elementAt(0).toString();
    print("Check item list ${itemdata["$key"]['item']['id']}");
    _.itemlist.add(itemdata["$key"]['item']);
    _.itemlist.forEach((e) {
      print("iTEAM list $e");
    });
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width / 7,
              height: 40.0,
              color: Color(0xFF0A3966),
              child: Center(
                child: Text(
                  "id".tr,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ),
            Container(
              width: Get.width / 5,
              height: 40.0,
              color: Color(0xFF0A3966),
              child: Center(
                child: Text(
                  "name".tr,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ),
            Container(
              width: Get.width / 7,
              height: 40.0,
              color: Color(0xFF0A3966),
              child: Center(
                child: Text(
                  "detail".tr,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ),
            Container(
              width: Get.width / 7,
              height: 40.0,
              color: Color(0xFF0A3966),
              child: Center(
                child: Text(
                  "price".tr,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ),
            Container(
              width: Get.width / 7,
              height: 40.0,
              color: Color(0xFF0A3966),
              child: Center(
                child: Text(
                  "total".tr,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ),
            Container(
              width: Get.width / 7,
              height: 40.0,
              color: Color(0xFF0A3966),
              child: Center(
                child: Text(
                  "action".tr,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          itemCount: _.itemsOrder.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            print('Item Length is ${_.itemsOrder.length}');
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width / 7,
                  height: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF0A3966))),
                  child: Center(
                    child: Text(
                      "${_.itemsOrder[index]['id']}",
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                    ),
                  ),
                ),
                Container(
                  width: Get.width / 5,
                  height: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF0A3966))),
                  child: Center(
                    child: Text(
                      "${_.itemsOrder[index]['name']}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  width: Get.width / 7,
                  height: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF0A3966))),
                  child: Center(
                    child: Text(
                      "Qty ${itemdata["$key"]['qty']}",
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                    ),
                  ),
                ),
                Container(
                  width: Get.width / 7,
                  height: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF0A3966))),
                  child: Center(
                    child: Text(
                      "${_.itemsOrder[index]['price']}",
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                    ),
                  ),
                ),
                Container(
                  width: Get.width / 7,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF0A3966))),
                  height: 100.0,
                  child: Center(
                    child: Text(
                      "${_.itemsOrder[index]['price'] * itemdata["$key"]['qty']}",
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                    ),
                  ),
                ),
                Container(
                  width: Get.width / 7,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF0A3966))),
                  height: 100.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        status == "completed"
                            ? IconButton(
                                onPressed: () {
                                  showAlertBox(_, ctx,
                                      _.itemsOrder[index]['id'].toString());
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) => RatingDialog(
                                  //       title: 'Rating Dialog',
                                  //       message:
                                  //           'Tap a star to set your rating. Add more description here if you want.',
                                  //       image: Image.asset(
                                  //         'assets/image/micon.png',
                                  //         width: 64,
                                  //         height: 64,
                                  //       ),
                                  //       submitButton: 'Submit',
                                  //       onCancelled: () => print('cancelled'),
                                  //       onSubmitted: (response) {
                                  //         _.reviewItemApi(
                                  //             response.comment,
                                  //             _.itemlist[index]['id']
                                  //                 .toString(),
                                  //             response.rating.toString());
                                  //         print(
                                  //             'rating: ${response.rating}, comment: ${response.comment}');
                                  //         if (response.rating < 3.0) {
                                  //         } else {
                                  //           // _rateAndReviewApp();
                                  //         }
                                  //       },
                                  //       onPressed: () {
                                  //         _.selectImage();
                                  //       },
                                  //       onPressed1: () {
                                  //         _.selectVideo();
                                  //       }),
                                  // );
                                },
                                icon: Icon(
                                  Icons.reviews,
                                  size: 15.0,
                                  color: Colors.blueGrey,
                                ),
                              )
                            : SizedBox(),
                        IconButton(
                          onPressed: () {
                            print(_.itemsOrder[index]['slug']);
                            _.addToCart(_.itemsOrder[index]['slug']);
                          },
                          icon: Icon(
                            Icons.shopping_basket_rounded,
                            size: 15.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  showAlertBox(OrderHistoryController _, context, String id) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.clear,
                size: 17.0,
              ),
            ),
          ],
        ),
        content: Container(
          height: 360,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/image/micon.png',
                          width: 64,
                          height: 64,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Rating Dialog',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Tap a star to set your rating. Add more description here if you want.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: RatingBar.builder(
                          initialRating: _.rating.toDouble(),
                          glowColor: Colors.amber,
                          minRating: 1.0,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            _.rating = rating.toInt();
                            _.update();
                          },
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Stack(alignment: Alignment.centerRight, children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _.comment,
                          decoration: InputDecoration(
                            hintText: 'Tell us your comments',
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 40, maxHeight: 20),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 4),
                                width: 1.0,
                                height: 30.0,
                                color: secondaryColor,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _.selectImage();
                                },
                                child: Icon(
                                  Icons.image,
                                  size: 20.0,
                                  color: secondaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _.selectVideo();
                                },
                                child: Icon(
                                  Icons.video_collection,
                                  size: 20.0,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  _.reviewItemApi(_.comment.text, id, _.rating.toString());
                  if (_.rating < 3) {
                  } else {
                    // _rateAndReviewApp();
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
