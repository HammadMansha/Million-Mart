import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/widget/ManagerDialog.dart';
// import 'ManagerDialog.dart';

class MillionMallAppBar extends StatelessWidget {
  MillionMallAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Scaffold.of(context).openDrawer();
        },
        child: Icon(
          Icons.menu,
          color: Color(0xFF0A3966),
        ),
      ),
      titleSpacing: 0,
      // title: Text('Million Mall'),
      title: Image.asset(
        'assets/icon/mmicon.png',
        width: 135.0,
        // height: 18.0,
        fit: BoxFit.cover,
      ),
      centerTitle: false,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      backgroundColor: Color(0xFFAED0F3),

      actions: <Widget>[
        InkWell(
          child: ImageIcon(
            AssetImage('assets/image/manager.png'),
            color: Color(0xFF0A3965),
            // withOpacity(0.5),
            size: 26,
          ),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => searchBar(),
            //     ));
            showDialog(
                context: context,
                builder: (context) => ManaGerDialog(),
                barrierDismissible: true);
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        InkWell(
          child: new Stack(children: <Widget>[
            Center(
              child: Icon(
                Icons.shopping_cart_rounded,
                color: Color(0xFF0A3965),
                // .withOpacity(0.5),
                size: 26,
              ),
            ),
            (
                    // CUR_CART_COUNT != null &&
                    // CUR_CART_COUNT.isNotEmpty &&
                    CUR_CART_COUNT != 0)
                ? new Positioned(
                    top: 0.0,
                    right: 5.0,
                    bottom: 15,
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: new Center(
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: new Text(
                              CUR_CART_COUNT.toString(),
                              style: TextStyle(fontSize: 4),
                            ),
                          ),
                        )),
                  )
                : Container()
          ]),
          onTap: () async {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => MillionMartCart(),
            //     ));
          },
        ),
        SizedBox(
          width: 10.0,
        ),
      ],

      // backgroundColor: Colors.transparent,
      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     // gradient: MillionMartgradient
      //   ),
      // ),
      // bottom: PreferredSize(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Padding(
      //       padding:
      //       const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
      //       child: searchBar(),
      //     ),
      //   ),
      //   preferredSize: Size.fromHeight(120),
      // ),
      elevation: 2.0,
    );
  }
}
