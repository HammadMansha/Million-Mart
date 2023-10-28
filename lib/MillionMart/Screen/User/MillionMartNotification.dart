import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/notificationController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartpHomeTab.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/NoInternet.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartDrawer.dart';
import 'package:millionmart_cleaned/MillionMart/widget/SearchBar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MillionMartNotification extends StatefulWidget {
  const MillionMartNotification({Key? key}) : super(key: key);

  @override
  State<MillionMartNotification> createState() => _MillionMartNotificationState();
}

class _MillionMartNotificationState extends State<MillionMartNotification> {


  Future<void> fetchDataNoti () async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000), () {
      print("updated");
    });
  }

  @override
  Widget build(BuildContext context) {
    NetworkController networkController = Get.put(NetworkController());
    return GetBuilder<NotificationController>(
        init: NotificationController(),
        builder: (_) {
          return Obx(() {
            return networkController.networkStatus.value == true
                ? Scaffold(
                    // appBar: widget.appbar == false
                    appBar: AppBar(
                      centerTitle: true,
                      iconTheme: IconThemeData(color: Color(0xFF0A3966)),
                      backgroundColor: Color(0xFFAED0F3),
                      title: Text("notifications".tr,style: TextStyle(color: primaryColor),),
                      // SearchBar(),
                    ),
                    drawer: MillionMartDrawer(),
                    // : PreferredSize(preferredSize: Size.fromHeight(0), child: AppBar()),
                    body: _.isLoading
                        ? Center(
                            child: Image.asset(
                              'assets/icon/mmgif.gif',
                              height: 50,
                              width: 50,
                            ),
                          )
                        : _.notificationlist.length == 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: kToolbarHeight),
                                child: Center(
                                  child: Text("No Notification Yet"),
                                ),
                              )
                            : SafeArea(
                                child:  ScreenTypeLayout(
                                    mobile: _.notificationlist.length == 0
                                        ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: kToolbarHeight),
                                              child: Center(
                                                child:
                                                    Text("Not Notification Yet"),
                                              ),
                                            )
                                        : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  _.notificationlist.length,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  // elevation: 0.1,
                                                  shadowColor: MillionMartcolor5,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Row(
                                                          // alignment: WrapAlignment.spaceBetween,
                                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Text(
                                                              _.notificationlist[
                                                                      index]
                                                                  ['title'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              _.notificationlist[
                                                              index]
                                                              ['create_at'],
                                                              style: TextStyle(
                                                                  color: primaryColor),
                                                            ),

                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          _.notificationlist[
                                                          index][
                                                          'description'],
                                                          style:
                                                          TextStyle(),
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                ),
                              ),
                  )
                : NoInternetScreen();
          });
        });
  }
}
