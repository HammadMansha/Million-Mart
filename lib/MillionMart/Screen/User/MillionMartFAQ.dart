import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class MillionMartFAQ extends StatefulWidget {
  const MillionMartFAQ({Key? key}) : super(key: key);

  @override
  _MillionMartFAQState createState() => _MillionMartFAQState();
}

class _MillionMartFAQState extends State<MillionMartFAQ> {
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'faq'.tr,
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFAED0F3),
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        ),
        body: Stack(
          children: [
            WebView(
              key: _key,
              initialUrl: 'https://millionmart.com/mfaq',
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ).paddingOnly(left: 7.0,right: 7.0),
      ),
    );
  }
}
