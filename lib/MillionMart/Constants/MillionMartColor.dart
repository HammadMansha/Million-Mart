import 'package:flutter/material.dart';
import 'package:millionmart_cleaned/MillionMart/ConfigFile/configFile.dart';
// //
// MaterialColor primary_app = const MaterialColor(
//   0xffFF7479,
//    <int, Color>{
//     50: primaryColor,
//     100: primaryColor,
//     200: primaryColor,
//     300: primaryColor,
//     400: primaryColor,
//     500: primaryColor,
//     600: primaryColor,
//     700: primaryColor,
//     800: primaryColor,
//     900: primaryColor,
//   },
// );

final Color MillionMartcolor1 = Color(0xfffff1f4);
final Color MillionMartcolor2 = Color(0xFF0A3965);
final Color MillionMartcolor3 = Color(0xffF566A2);
final Color MillionMartcolor4 = Color(0xfffff1f4);
final Color MillionMartcolor5 = Color(0x33ff819c);
final Color MillionMartcolor6 = Color(0xFFFDE5EA);

final Color MillionMartcolor8 = Colors.green;

Gradient MillionMartgradient = LinearGradient(
  begin: Alignment(1.0, 1.0),
  end: Alignment(-1.0, -1.0),
  colors: [MillionMartcolor3, MillionMartcolor2],
  stops: [0.0, 1.0],
);

//Config File Variables
final Color primaryColor = Color(int.parse(configFile['color']['primaryColor']));
final Color notificationBackground = Color(int.parse(configFile['color']['notificationBackground']));
final Color secondaryColor = Color(int.parse(configFile['color']['secondaryColor']));
final Color statusBarColor = Color(int.parse(configFile['color']['statusBarColor']));
final Color systemNavigationBarColor = Color(int.parse(configFile['color']['systemNavigationBarColor']));
final Color btnGradientColor0 = Color(int.parse(configFile['color']['btnGradientColor0']));
final Color btnGradientColor1 = Color(int.parse(configFile['color']['btnGradientColor1']));
final Color onBoardTitleTextColor = Color(int.parse(configFile['color']['onBoardTitleTextColor']));
final Color onBoardBtnTitleTextColor = Color(int.parse(configFile['color']['onBoardBtnTitleTextColor']));
final Color subtitleColor = Color(int.parse(configFile['color']['subtitleColor']));
final Color backgroundColor = Color(int.parse(configFile['color']['backgroundColor']));
final Color notificationTextColor = Color(int.parse(configFile['color']['notificationTextColor']));






const Color primaryLight = Color(0xFF0B3C68);
Color primaryLight2 = Color(0xFF0B3C68).withOpacity(0.1);
const Color primaryLight3 = Color(0xFF0B3C68);
const Color textcolor = Colors.black;

const Color pink = Color(0xffd4001d);
const Color blue = Color(0xff1977f3);
const Color red = Colors.red;

const Color lightblack = Color(0xff666666);
const Color lightblack2 = Color(0xff7f7f7f);
const Color lightgrey = Color(0xffE8E8E8);
const Color darkgrey = Color(0xff909090);
const Color white = Color(0xffFFFFFF);
