import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MillionMartHome.dart';
import 'MillionMartOnbording.dart';
import 'package:get/get.dart';

class MillionMartSplash extends StatefulWidget {
  MillionMartSplash({Key? key}) : super(key: key);

  @override
  _MillionMartSplashState createState() => _MillionMartSplashState();
}

class _MillionMartSplashState extends State<MillionMartSplash> {
  // bool _isConnected = true;

  // void checkConnectivity() async {
  //   try {
  //     final response = await InternetAddress.lookup('www.google.com');
  //     if (response.isNotEmpty) {
  //       setState(() {
  //         _isConnected = true;
  //       });
  //     }
  //   } on SocketException catch (err) {
  //     setState(() {
  //       _isConnected = false;
  //     });
  //     print(err);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // checkConnectivity();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    print("Splash Scaffold");
    return WillPopScope(
      onWillPop: () {
        throw 'Checked';
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: back(),
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/image/micon.png",
                        width: 100.0,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        "Million Mart",
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'open sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 28),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  back() {
    return BoxDecoration(
      color: Colors.white,
      // gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryLight2, primaryLight3], stops: [0, 1]),
    );
  }

  startTime() async {
    var _duration = Duration(milliseconds: 1500);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    //one time Onboard Screen Check
    SharedPreferences prefs = await Constants.prefs;
    bool _seen = prefs.getBool('seen') ?? false;

    print("Splash Navigation");
    // _isConnected == false
    //     ? showDialog(
    //         barrierDismissible: false,
    //         context: context,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             title: Text('Internet Connection'),
    //             content: Text("Network Status: Not Connected"),
    //             actions: [
    //               TextButton(
    //                 onPressed: () {
    //                   checkConnectivity();
    //                   navigationPage();
    //                 },
    //                 child: Text("Retry"),
    //               )
    //             ],
    //           );
    //         })
    //     :
    Constants.prefs.then(
      (value) {
        value.getBool('loggedIn') == true
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MillionMartHome(),
                ),
              )
            : !_seen
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MillionMartOnbording(),
                    ),
                  )
                : Get.offAll(
                    () => MillionMartHome(),
                  );
      },
    );
  }
}
