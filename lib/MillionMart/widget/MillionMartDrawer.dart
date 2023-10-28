import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartAccounts.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartCart.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartHome.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartLogin.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartPrivacyPolicy.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartSingUp.dart';
import 'package:get/get.dart';

class MillionMartDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    print("User Id ${homeController.ischeck}");
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              MillionMartDrawerHeader(),
              MillionMartDrawerListTile(
                title: 'home'.tr,
                icon: Icons.home,
                route: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MillionMartHome(),
                    ),
                  );
                },
                imgurl: '',
              ),
              _getDivider(),
              MillionMartDrawerListTile(
                title: 'cart'.tr,
                icon: Icons.shopping_cart,
                route: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MillionMartCart(),
                    ),
                  );
                },
                imgurl: '',
              ),
              _getDivider(),
              // MillionMartDrawerListTile(
              //   // img: true,
              //   // imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/pro_trackorder.svg",
              //   title: 'Seller Panel',
              //   icon: Icons.business_center_sharp,
              //   route: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => SellerLogin(
              //             // appbar: true,
              //             ),
              //       ),
              //     );
              //   },
              //   imgurl: '',
              // ),
              // _getDivider(),
              // MillionMartDrawerListTile(
              //   // img: true,
              //   // imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/pro_trackorder.svg",
              //   title: TRACK_ORDER,
              //   icon: Icons.bike_scooter,
              //   route: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => MillionMartTreackOrder(
              //           appbar: true,
              //         ),
              //       ),
              //     );
              //   },
              //   imgurl: '',
              // ),
              // _getDivider(),
              MillionMartDrawerListTile(
                // img: true,
                // imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/profile.svg",
                title: 'account'.tr,
                icon: Icons.business_center_sharp,
                route: () {
                  Navigator.of(context).pop();
                  Constants.prefs.then((value) {
                    value.getBool('loggedIn') == true
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Account(),
                            ),
                          )
                        : Get.snackbar('error'.tr, 'loginFirst'.tr,
                        backgroundColor: notificationBackground,
                        colorText: notificationTextColor);
                  });
                },
                imgurl: '',
              ),
              _getDivider(),
              // MillionMartDrawerListTile(
              //   // img: true,
              //   // imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/pro_od.svg",
              //   title: ORDER_DETAIL,
              //   icon: Icons.content_paste_sharp,
              //   route: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => MillionMartOrderDetails(),
              //       ),
              //     );
              //   },
              //   imgurl: '',
              // ),
              // _getDivider(),
              // MillionMartDrawerListTile(
              //   img: true,
              //   imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/pro_notification.svg",
              //   title: NOTIFICATION,
              //   icon: Icons.notification_important,
              //   route: () {
              //     Navigator.of(context).pop();
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => MillionMartNotification(
              //           // appbar: true,
              //         ),
              //       ),
              //     );
              //   },
              // // ),
              // // _getDivider(),
              // MillionMartDrawerListTile(
              //   // img: true,
              //   // imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/pro_favourite.svg",
              //   title: FAVORITE,
              //   icon: Icons.favorite,
              //   route: () {
              //     Navigator.of(context).pop();
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => MillionMartFavrite(
              //           appbar: true,
              //         ),
              //       ),
              //     );
              //   },
              //   imgurl: '',
              // ),
              // _getDivider(),
              // MillionMartDrawerListTile(
              //   // img: true,
              //   // imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/pro_favourite.svg",
              //   title: 'Report',
              //   icon: Icons.report,
              //   route: () {
              //     Navigator.of(context).pop();
              //     // Navigator.pushReplacement(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //     builder: (context) => ReportScreen(
              //     //         // appbar: true,
              //     //         ),
              //     //   ),
              //     // );
              //     Navigator.push(context, MaterialPageRoute(builder: (_) {
              //       return ReportScreen();
              //     }));
              //   },
              //   imgurl: '',
              // ),
              // _getDivider(),
              MillionMartDrawerListTile(
                // img: true,
                // imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/pro_favourite.svg",
                title: 'privacy_policy'.tr,
                icon: Icons.privacy_tip_rounded,
                route: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return PrivacyPolicy();
                  }));
                },
                imgurl: '',
              ),
              _getDivider(),
              // MillionMartDrawerListTile(
              //   title: 'CHECK'.tr,
              //   icon: Icons.account_balance,
              //   route: () {
              //     Get.back();
              //     Get.to(() =>OrderNoPage());
              //   },
              //   imgurl: '',
              // ),
              homeController.ischeck == false
                  ? Column(
                      children: [
                        MillionMartDrawerListTile(
                          title: 'signin'.tr,
                          icon: Icons.login,
                          route: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MillionMartLogin(),
                              ),
                            );
                          },
                          imgurl: '',
                        ),
                        _getDivider(),
                      ],
                    )
                  : MillionMartDrawerListTile(
                      title: 'sign_out'.tr,
                      icon: Icons.logout,
                      route: () {
                        Constants.userID = null;
                        print(Constants.userID);
                        Navigator.of(context).pop();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              //Checked

                              Constants.prefs.then(
                                  (value) => value.setBool("loggedIn", false));
                              // Constants.prefs.setBool("loggedIn", false);
                              return MillionMartLogin();
                            },
                          ),
                        );
                      },
                      imgurl: '',
                    ),
              _getDivider(),
              homeController.ischeck == false
                  ? MillionMartDrawerListTile(
                      title: 'sign_up'.tr,
                      icon: Icons.account_box_rounded,
                      route: () {
                        Constants.userID = null;
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MillionMartSingUp(),
                          ),
                        );
                      },
                      imgurl: '',
                    )
                  : SizedBox(),
            ],
          ),
          Spacer(),
          Platform.isAndroid
              ? Center(
                  child: Text('version'.tr+': 1.0.2 (2)'),
                )
              : Center(
                  child: Text('version'.tr+' 1.0.2 (2)'),
                ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  _getDivider() {
    return Divider(
      color: Colors.grey,
      height: 1,
    );
  }
}

class MillionMartDrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title, imgurl;
  final VoidCallback route;
  final bool img;

  const MillionMartDrawerListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.route,
    this.img = false,
    required this.imgurl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: img == true
          ? SvgPicture.network(
              imgurl,
              width: 28.0,
              color: MillionMartcolor2,
            )
          : Icon(
              icon,
              color: MillionMartcolor2,
            ),
      title: Text(
        title,
        style: TextStyle(color: textcolor),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: MillionMartcolor2,
      ),
      onTap: route,
    );
  }
}

class MillionMartDrawerHeader extends StatelessWidget {
  const MillionMartDrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        // decoration: BoxDecoration(gradient: MillionMartgradient),
        padding: EdgeInsets.only(top: 24),
        child: InkWell(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              // margin: EdgeInsets.all(35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/micon.png',
                    width: 60.0,
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 26,
                  // ),
                  // Text(
                  //   "Happy Shop",
                  //   style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Open sans', fontWeight: FontWeight.w700),
                  // )
                ],
              ),
            ),
          ),
          onTap: () {
            Get.back();
          },
        ),
      ),
    );
  }
}
