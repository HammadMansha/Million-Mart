import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'Constants/MillionMartColor.dart';
import 'Screen/User/MillionMartSplash.dart';

class MillionMartMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Million Mart",
      theme: ThemeData(
          // primarySwatch: primary_app,
          textSelectionTheme: TextSelectionThemeData(cursorColor: primaryColor),
          fontFamily: 'Open sans',
          textTheme: TextTheme(
              headline6: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ))),
      debugShowCheckedModeBanner: false,
      home: MillionMartSplash(),
    );
  }
}
