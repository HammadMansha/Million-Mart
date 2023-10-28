import 'package:flutter/material.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/accountController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartAccountinformation.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMallReturns&Refund.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartBargainItems.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartComparison.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartFAQ.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartOrders.dart';
import 'package:get/get.dart';
import 'MillionMartHelpScreen.dart';
import 'MillionMartSecurity&SettingScreen.dart';

class Account extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'account'.tr,
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFAED0F3),
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        ),
        backgroundColor: Colors.grey[100],
        body: GetBuilder<AccountController>(
          builder: (_) {
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: Get.width,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: AspectRatio(
                              aspectRatio: 1.1 / 1.12,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Color(0xffFDCF09),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  child: Text(
                                    _.name[0],
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )
                              //  ClipOval(
                              //   child: FadeInImage.assetNetwork(
                              //     fit: BoxFit.cover,
                              //     image: 'https://picsum.photos/200',
                              //     placeholder: "assets/image/micon.png",
                              //   ),
                              // ),
                              ),
                          title: Text(
                            "${_.name}",
                            style: TextStyle(
                                color: Color(0xFF0A3966),
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${_.email}",
                            style: TextStyle(
                                color: Color(0xFF0A3966),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListView.builder(
                    itemCount: _.tabslist.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Get.to(() => Orders());
                          } else if (index == 1) {
                            Get.to(() => ComparisonScreen());
                          } else if (index == 2) {
                            Get.to(() => BargainScreen());
                          } else if (index == 3) {
                            Get.to(() => MillionMartReturnsRefund());
                          } else if (index == 4) {
                            Get.to(() => AccountInformation());
                          } else if (index == 5) {
                            Get.to(() => AppSetting());
                          } else if (index == 6) {
                            Get.to(() => MillionMartFAQ());
                          } else if (index == 7) {
                            Get.to(() => Help());
                          }
                        },
                        child: carddata("${_.tabslist[index]['name']}"),
                      );
                    },
                  )
                ],
              ),
            );
          },
        ));
  }

  Widget carddata(String name) {
    return Container(
      height: 60.0,
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name.tr,
                style: TextStyle(
                  color: Color(0xFF0A3966),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 18.0,
                color: Color(0xFF0A3966),
              )
            ],
          ).marginOnly(left: 20.0, right: 20.0),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            color: Colors.grey,
            height: 1,
          )
        ],
      ),
    );
  }
}
