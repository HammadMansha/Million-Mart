import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartHome.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/Seller/SellerAddNewProduct.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/Seller/SellerAllProdcuts.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/Seller/SellerDashBoard.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/Seller/SellerProductCatalog.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/Seller/SellerProfile.dart';

class SellerDashboardDrawer extends StatelessWidget {
  const SellerDashboardDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            MillionMartDrawerHeader(),
            MillionMartDrawerListTile(
              title: HOME_LBL,
              icon: Icons.home,
              route: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellerDashBoard(),
                  ),
                );
              },
              imgurl: '',
            ),
            _getDivider(),
            MillionMartDrawerListTile(
              title: 'Profile',
              icon: Icons.account_circle,
              route: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellerPeofile(
                      appbar: true,
                    ),
                  ),
                );
              },
              imgurl: '',
            ),
            _getDivider(),
            ExpansionTile(
              iconColor: primaryColor,
              textColor: primaryColor,
              collapsedIconColor: primaryColor,
              collapsedTextColor: primaryColor,
              title: Text(
                'Products',
                style: TextStyle(
                    // color: primary,
                    ),
              ),
              leading: Icon(
                Icons.shopping_cart,
                color: primaryColor,
              ),
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewProduct()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ListTile(
                      leading: Text('Add New Products'),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllProducts()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ListTile(
                      leading: Text('All Products'),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductsCatalog()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ListTile(
                      leading: Text('Products Catalog'),
                    ),
                  ),
                )
              ],
            ),
            _getDivider(),
            ExpansionTile(
              iconColor: primaryColor,
              textColor: primaryColor,
              collapsedIconColor: primaryColor,
              collapsedTextColor: primaryColor,
              title: Text(
                'Orders',
                style: TextStyle(
                    // color: primary,
                    ),
              ),
              leading: Icon(
                Icons.delivery_dining,
                color: primaryColor,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    leading: Text('All Orders'),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5,
              ),
              child: MillionMartDrawerListTile(
                title: 'Logout',
                icon: Icons.exit_to_app,
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
            )
            // MillionMartDrawerListTile(
            //   title: CART,
            //   icon: Icons.shopping_cart,
            //   route: () {
            //     Navigator.of(context).pop();
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MillionMartCart(),
            //       ),
            //     );
            //   },
            // ),
            // _getDivider(),
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
            //           // appbar: true,
            //         ),
            //       ),
            //     );
            //   },
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
            // ),
            // _getDivider(),
            // MillionMartDrawerListTile(
            //   // img: true,
            //   // imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/profile.svg",
            //   title: 'Account',
            //   icon: Icons.business_center_sharp,
            //   route: () {
            //     Navigator.of(context).pop();
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => Account(),
            //       ),
            //     );
            //   },
            // ),
            // _getDivider(),
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
            // ),
            // _getDivider(),
            // // MillionMartDrawerListTile(
            // //   img: true,
            // //   imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/pro_notification.svg",
            // //   title: NOTIFICATION,
            // //   icon: Icons.notification_important,
            // //   route: () {
            // //     Navigator.of(context).pop();
            // //     Navigator.pushReplacement(
            // //       context,
            // //       MaterialPageRoute(
            // //         builder: (context) => MillionMartNotification(
            // //           // appbar: true,
            // //         ),
            // //       ),
            // //     );
            // //   },
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
            // ),
            // _getDivider(),
            // MillionMartDrawerListTile(
            //   // img: true,
            //   // imgurl: "https://smartkit.wrteam.in/smartkit/MillionMart/pro_favourite.svg",
            //   title: 'Report',
            //   icon: Icons.favorite,
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
            // ),
            // _getDivider(),
            // MillionMartDrawerListTile(
            //   title: "LOGIN",
            //   icon: Icons.login,
            //   route: () {
            //     Navigator.of(context).pop();
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MillionMartLogin(),
            //       ),
            //     );
            //   },
            // ),
            // _getDivider(),
            // MillionMartDrawerListTile(
            //   title: "SingUp",
            //   icon: Icons.account_box_rounded,
            //   route: () {
            //     Navigator.of(context).pop();
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MillionMartSingUp(),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
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
    return Container(
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
        onTap: () {},
      ),
    );
  }
}
