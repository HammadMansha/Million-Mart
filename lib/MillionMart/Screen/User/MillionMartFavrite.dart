import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartDrawer.dart';
import 'package:millionmart_cleaned/MillionMart/widget/SearchBar.dart';
import 'MillionMartHome.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'NoInternet.dart';

class MillionMartFavrite extends StatefulWidget {
  final bool appbar;

  MillionMartFavrite({Key? key, required this.appbar}) : super(key: key);

  @override
  _MillionMartFavriteState createState() => _MillionMartFavriteState();
}

class _MillionMartFavriteState extends State<MillionMartFavrite>
    with TickerProviderStateMixin {
  ScrollController controller = new ScrollController();

  late String prodID;
  var isLoadingMore = true.obs;
  var favItemsList = [].obs;
  var userID = Constants.userID;
  var deleted = false.obs;

  // Future<void> getUserID() async {
  //   final SharedPreferences _prefs = await Constants.prefs;
  //   userID = _prefs.getString('id')!;
  //   print("User ID is " + userID);
  // }

  @override
  void initState() {
    super.initState();
    favItemsList.value = [];
    // getUserID();
    fetchData();
    print("Screen Loaded");
  }

  @override
  void dispose() {
    super.dispose();
    favItemsList.value = [];
  }

  Future<void> ReloadhData() async {
    // HomeController _controller = Get.find<HomeController>();
    // _controller.isLoading.value = true;

    await Future.delayed(Duration(seconds: 0, milliseconds: 1000), () {
      // _controller.isLoading.value = false;
    });
  }

  Future<void> deleteData(String pId) async {
    print("inside api");
    isLoadingMore.value = true;
    var url = Constants.baseUrl;
    print("Pro Id and User Id IS : " + pId + ":" + userID.toString());
    final response = await http.post(
      Uri.parse(url + '/delete-wishlist'),
      body: {"user_id": userID.toString(), "product_id": pId},
    );
    print("api is called");
    if (response.statusCode == 200) {
      if (response.body.contains('Successfully')) {
        print("response of api " + response.body);
        deleted.value = false;
        fetchData();
        print("api is called");
      } else {
        var data = jsonDecode(response.body);
        print("Api reponse else " + data.toString());
      }
    } else {
      isLoadingMore.value = false;
      favItemsList.value = [];
      throw ("Api not hit");
    }
  }

  Future<void> fetchData() async {
    favItemsList.value = [];
    isLoadingMore.value = true;
    print("inside api");
    var url = Constants.baseUrl;
    print("User Id in Api " + userID.toString());
    final response = await http.post(Uri.parse(url + '/get-wishlist'),
        body: {"user_id": userID.toString()});
    print("api is called : " + response.statusCode.toString());
    if (response.statusCode == 200) {
      isLoadingMore.value = false;
      var data = jsonDecode(response.body);
      print("fav data is: " + data.toString());
      favItemsList.value = data;
      print(favItemsList.length);
    } else {
      isLoadingMore.value = false;
      favItemsList.value = [];
      throw ("Api not hit");
    }
  }

  _showContent() {
    print(favItemsList.length);
    return isLoadingMore.value == true
        ? Center(
            child: Center(
            child: Image.asset(
              'assets/icon/mmgif.gif',
              height: 50,
              width: 50,
            ),
          ))
        : favItemsList.length.toString() == "0"
            ? favEmpty()
            // Center(child: Container(child: Text("No Item"),))
            : ListView.builder(
                // shrinkWrap: true,
                itemCount: favItemsList.length,
                itemBuilder: (BuildContext context, int index) {
                  // var _data = favItemsList[0];
                  print("index is " + index.toString());
                  print(favItemsList[index]['id'].toString());
                  // print("inside of list");
                  return listItem(index);
                  // Text("data"+a[index]['id'].toString());
                  //
                  // T
                },
              );
  }

  Widget listItem(int index) {
    return Card(
      elevation: 1.5,
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () async {
              // await Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     transitionDuration: Duration(seconds: 1),
              //     pageBuilder: (_, __, ___) => MillionMartProductDetail(
              //       imgurl: st.image,
              //       tag: "${st.id}1",
              //     ),
              //   ),
              // );
            },
            child: CachedNetworkImage(
              imageUrl: favItemsList[index]['photo'] ?? '',
              height: 80.0,
              width: 80.0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '${favItemsList[index]['name']}',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      // decoration: TextDecoration.lineThrough,
                                      letterSpacing: 0.7,
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 8),
                          child: Icon(
                            Icons.close,
                            size: 13,
                          ),
                        ),
                        onTap: () async {
                          prodID = favItemsList[index]['id'].toString();
                          deleteData(prodID);
                          // if(deleted.value == false) {
                          //   fetchData();
                          //    //
                          // }

                          print('Index of tap is ' + prodID.toString());
                          // _dbcartmanager.deleteFav(fav.name);
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Row(
                          children: <Widget>[
                            Text(
                              '${favItemsList[index]['previous_price']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .overline!
                                  .copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    letterSpacing: 0.7,
                                  ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '${int.parse(favItemsList[index]['price'].toString())}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(color: Color(0xFFF68628)),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MillionMartHome(),
      ),
    );
    return true;
  }

  favEmpty() {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noFavImage(context),
          noFavText(context),
          // noFavDec(context),
          // shopNow()
        ]),
      ),
    );
  }

  noFavImage(BuildContext context) {
    return Lottie.asset(
      'assets/svgs/favempty.json',
      fit: BoxFit.contain,
    );
  }

  noFavText(BuildContext context) {
    return Container(
        child: Text("wishlist_empty".tr,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: primaryColor, fontWeight: FontWeight.normal)));
  }

  // noFavDec(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
  //     child: Text("Looking like you haven't added anything to your Wishlist",
  //         textAlign: TextAlign.center,
  //         style: Theme.of(context).textTheme.headline6!.copyWith(
  //               color: lightblack,
  //               fontWeight: FontWeight.normal,
  //             )),
  //   );
  // }

  NetworkController networkController = Get.put(NetworkController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: networkController.networkStatus.value == true
            ? Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Color(0xFF0A3966)),
                  backgroundColor: Color(0xFFAED0F3),
                  centerTitle: true,
                  title: Text("favorite_items".tr,style: TextStyle(color: primaryColor),),
                  // SearchBar(),
                ),
                drawer: MillionMartDrawer(),
                backgroundColor: Colors.white10,
                extendBodyBehindAppBar: true,
                body: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: fetchData,
                    child: Stack(
                      children: <Widget>[
                        _showContent(),
                      ],
                    ),
                  ),
                ),
              )
            : NoInternetScreen(),
      );
    });
  }
}
