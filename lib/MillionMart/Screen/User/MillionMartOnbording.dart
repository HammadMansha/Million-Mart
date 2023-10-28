import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/widget/SearchBar.dart';
import 'package:resize/src/resizeExtension.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MillionMartLogin.dart';
import 'package:lottie/lottie.dart';

class MillionMartOnbording extends StatefulWidget {
  MillionMartOnbording({Key? key}) : super(key: key);

  @override
  _MillionMartOnbordingState createState() => _MillionMartOnbordingState();
}

class _MillionMartOnbordingState extends State<MillionMartOnbording> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    oneTimeOnBoard();
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void oneTimeOnBoard() async {
    SharedPreferences prefs = await Constants.prefs;
    prefs.setBool('seen', true);
  }

  List<Widget> indicators = [];

  void onAddButtonTapped(int index) {
    // use this to animate to the page
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 1000), curve: Curves.elasticInOut);

    // or this to jump to it without animating
    _pageController.jumpToPage(index);
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 5,
        width: isActive ? 15 : 5,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // gradient:
          // LinearGradient(begin: Alignment.centerLeft,
          // end: Alignment.centerRight, colors: [color1, color1]),
          color: isActive ? Color(0xFFFB2A59) : Color(0xFF7E152D),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        throw 'Checked';
      },
      child: Scaffold(
          body: Stack(
        children: [
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: <Widget>[
              IntroPage(
                imgurl: "assets/svgs/search.json",
                titletext: 'easy_search'.tr,
                // subtext: 'we_connect'.tr,
                index: currentIndex,
              ),
              IntroPage(
                imgurl: "assets/svgs/sharecart.json",
                titletext: 'share_cart'.tr,
                index: currentIndex,
                // subtext: 'we_connect'.tr,
              ),
              IntroPage(
                imgurl: "assets/svgs/voiceCommands.json",
                titletext: 'voice_cmds'.tr,
                index: currentIndex,
                // subtext: 'we_offer'.tr,
              ),
            ],
          ),
          Positioned(
            bottom: 10.0,
            left: MediaQuery.of(context).size.width / 8,
            right: MediaQuery.of(context).size.width / 8,
            child: InkWell(
              onTap: () {
                if (currentIndex == 0) {
                  setState(() {
                    indicators.add(_indicator(true));

                    currentIndex = 1;
                    onAddButtonTapped(currentIndex);
                  });
                } else if (currentIndex == 1) {
                  setState(() {
                    indicators.add(_indicator(true));
                    currentIndex = 2;
                    onAddButtonTapped(currentIndex);
                  });
                } else if (currentIndex == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MillionMartLogin(),
                    ),
                  );
                }
              },
              child: Container(
                height: 50.0,
                child: Center(
                  child: Text(
                    currentIndex == 0
                        ? 'next'.tr
                        : currentIndex == 1
                            ? "Next"
                            : 'start_now'.tr,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [btnGradientColor0, btnGradientColor1])),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({
    Key? key,
    required this.imgurl,
    required this.titletext,
    required this.index,
    // required this.subtext,
  }) : super(key: key);

  final String imgurl, titletext;

  // subtext;
  final int index;

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  late AnimationController _animationController, animationController;
  bool dragFromLeft = false;

  double opacityLevel = 0.0;
  late Animation animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.forward();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ScreenTypeLayout(
        mobile: Container(
          padding: EdgeInsets.only(
            left: 40,
            right: 50,
            bottom: 60,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Column(
              //   children: <Widget>[
              //
              //     // SizedBox(
              //     //   height: width / 18,
              //     // ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                flex: 1,
                child: Lottie.asset(
                  widget.imgurl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.titletext,
                  style: TextStyle(
                      color: onBoardTitleTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              widget.index == 0
                  ? Column(
                      // physics: AlwaysScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      children: [
                        _bottomSec(
                          title: 'titleS1T1'.tr,
                          detail: 'desS1D1'.tr,
                          icon: Icons.search,
                          sicon: "",
                          isSearch: true,
                        ),
                        // SizedBox(
                        //   height: 10.0,
                        // ),
                        _bottomSec(
                            title: 'titleS1T2'.tr,
                            detail: 'desS1D2'.tr,
                            icon: Icons.mic,
                            isSearch: true,
                            sicon: "m"),
                        // SizedBox(
                        //   height: 10.0,
                        // ),
                        _bottomSec(
                            title: 'titleS1T3'.tr,
                            detail: 'desS1D3'.tr,
                            sicon: "i",
                            isSearch: true,
                            icon: Icons.image_search_outlined),
                        // SizedBox(
                        //   height: 10.0,
                        // ),
                        _bottomSec(
                            title: 'titleS1T4'.tr,
                            detail: 'desS1D4'.tr,
                            sicon: "q",
                            isSearch: false,
                            icon: Icons.qr_code_scanner),
                        // _bottomSec(),
                        // _bottomSec(),
                        // _bottomSec()
                      ],
                    )
                  : widget.index == 1
                      ? Column(
                          children: [
                            _bottomSec(
                                title: 'titleS2T1'.tr,
                                detail: 'desS2D1'.tr,
                                sicon: "ad",
                                isSearch: false,
                                icon: Icons.add_shopping_cart),
                            _bottomSec(
                                title: 'titleS2T2'.tr,
                                detail: 'desS2D2'.tr,
                                sicon: "sh",
                                isSearch: false,
                                icon: Icons.share_outlined),
                            _bottomSec(
                                title: 'titleS2T3'.tr,
                                detail: 'desS2D3'.tr,
                                sicon: "social",
                                isSearch: false,
                                icon: Icons.group_add_outlined),
                            _bottomSec(
                                title: 'titleS2T4'.tr,
                                detail: 'desS2D4'.tr,
                                sicon: "rc",
                                isSearch: false,
                                icon: Icons.call_received_sharp),
                            // _bottomSec(),
                            // _bottomSec(),
                            // _bottomSec()
                          ],
                        )
                      : Column(
                        children: [
                          _bottomSec(
                              title: 'titleS3T1'.tr,
                              detail: 'desS3D1'.tr,
                              sicon: "vc",
                              isSearch: false,
                              icon: Icons.shopping_cart),
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                          _bottomSec(
                              title: 'titleS3T2'.tr,
                              detail: 'desS3D2'.tr,
                              sicon: "ra",
                              isSearch: false,
                              icon: Icons.shopping_cart_outlined),
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                          _bottomSec(
                              title: 'titleS3T3'.tr,
                              detail: 'desS3D3'.tr,
                              sicon: "fu",
                              isSearch: false,
                              icon: Icons.add_shopping_cart_outlined),
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                          _bottomSec(
                              title: 'titleS3T4'.tr,
                              detail: 'desS3D4'.tr,
                              sicon: "pro",
                              isSearch: false,
                              icon: Icons.fact_check_outlined),
                          // _bottomSec(),
                          // _bottomSec(),
                          // _bottomSec()
                        ],
                      ),
              // FadeTransition(
              //   opacity:
              //       animationController.drive(CurveTween(curve: Curves.easeIn)),
              //   child: Container(
              //     alignment: Alignment.center,
              //     child: Text(
              //       widget.subtext,
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         color: primaryColor,
              //         fontSize: 14,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomSec(
      {required String title,
      required String detail,
      required IconData icon,
      required String sicon,
      required bool isSearch}) {
    return Container(
      width: Get.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            child: Center(
              child: Icon(
                icon,
                size: 40.0,
                color: onBoardTitleTextColor,
              ),
            ),
          ).marginOnly(
            bottom: 20,
          ),
          Spacer(),
          Container(
            width: Get.width / 1.7,
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                isSearch == true ? serachwidget(sicon) : appbarwidget(sicon),
                SizedBox(
                  height: 10.0,
                ),
                Text(detail),
              ],
            ),
          )
        ],
      ).marginOnly(bottom: 5.0),
    );
  }

  Widget serachwidget(String sicon) {
    return Card(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: true,
              controller: searchController,
              autofocus: false,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 10.sp),
                hintText: 'search'.tr,
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF0A3966),
                  size: 24,
                ),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 40, maxHeight: 24),
                isDense: true,
                // suffixIcon:
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                // suffixIcon:
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                sicon == "m"
                    ? InkWell(
                        child: Image.asset(
                          'assets/icon/icon.png',
                          width: 24,
                          height: 24,
                        ),
                      )
                    : sicon == "i"
                        ? InkWell(
                            child: Icon(
                              Icons.camera_alt,
                              size: 24,
                              color: Color(0xFF0A3966),
                            ),
                          )
                        : sicon == "q"
                            ? InkWell(
                                child: Icon(
                                  Icons.qr_code_scanner,
                                  size: 24,
                                  color: Color(0xFF0A3966),
                                ),
                              )
                            : SizedBox(),
                SizedBox(
                  width: 8,
                ),
                // InkWell(
                //   child: Icon(
                //     Icons.qr_code_scanner,
                //     size: 24,
                //     color: Color(0xFF0A3966),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget appbarwidget(String sicon) {
    return Card(
      color: sicon == 'ra'
          ? Colors.white
          : sicon == "pro"
              ? Colors.white
              : sicon == "fu"
                  ? Colors.white
                  : sicon == 'vc'
                      ? Colors.white
                      : statusBarColor,
      // color:sicon == 'ra' ? Colors.white : sicon == "pro" : Colors.white : sicon =="fu" ? Colors.white :  Colors.white : statusBarColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: true,
              controller: searchController,
              autofocus: false,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 10.0),
                prefixIcon: sicon == "q"
                    ? Image.asset(
                        'assets/icon/mmlogo.png',
                        width: 80.0,
                        // height: 18.0,
                        fit: BoxFit.cover,
                      ).marginOnly(left: 20.0)
                    : SizedBox(),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 40, maxHeight: 24),
                isDense: true,
                // suffixIcon:
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                // suffixIcon:
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                sicon == "ad"
                    ? InkWell(
                        child: Icon(
                        Icons.shopping_cart,
                      ))
                    : sicon == "q"
                        ? InkWell(
                            child: Icon(
                              Icons.qr_code_scanner,
                              size: 24,
                              color: Color(0xFF0A3966),
                            ),
                          )
                        : sicon == "sh"
                            ? InkWell(
                                child: MaterialButton(
                                onPressed: () {},
                                minWidth: 100.0,
                                height: 35.0,
                                color: Color(0xFFF68628),
                                child: Row(
                                  // textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "share_cart".tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ))
                            : sicon == "social"
                                ? InkWell(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/icon/whatsapp-new.png",
                                          height: 30,
                                          width: 30.0,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Icon(Icons.copy),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Icon(Icons.email_outlined),
                                      ],
                                    ),
                                  )
                                : sicon == 'rc'
                                    ? InkWell(
                                        child: Text(
                                          "Receive Cart",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      )
                                    : sicon == 'vc'
                                        ? InkWell(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "View cart by tapping ",
                                                  style:
                                                      TextStyle(fontSize: 10.sp),
                                                ),
                                                CircleAvatar(
                                                  backgroundColor:
                                                      statusBarColor,
                                                  radius: 18,
                                                  child: Icon(
                                                    Icons.mic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : sicon == 'ra'
                                            ? InkWell(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Remove products by tapping ",
                                                      style: TextStyle(
                                                          fontSize: 10.sp),
                                                    ),
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          statusBarColor,
                                                      radius: 18,
                                                      child: Icon(
                                                        Icons.mic,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : sicon == 'fu'
                                                ? InkWell(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Fill up cart by tapping ",
                                                          style: TextStyle(
                                                              fontSize: 10.sp),
                                                        ),
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              statusBarColor,
                                                          radius: 18,
                                                          child: Icon(
                                                            Icons.mic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : sicon == 'pro'
                                                    ? InkWell(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Checkout by tapping ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp),
                                                            ),
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  statusBarColor,
                                                              radius: 18,
                                                              child: Icon(
                                                                Icons.mic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(),
                // InkWell(
                //   child: Icon(
                //     Icons.qr_code_scanner,
                //     size: 24,
                //     color: Color(0xFF0A3966),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
