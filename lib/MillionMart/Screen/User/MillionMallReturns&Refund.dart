import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MillionMartReturnsRefund extends StatefulWidget {
  const MillionMartReturnsRefund({Key? key}) : super(key: key);

  @override
  _MillionMartReturnsRefundState createState() => _MillionMartReturnsRefundState();
}

class _MillionMartReturnsRefundState extends State<MillionMartReturnsRefund> {
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Policy',
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          backgroundColor: Color(0xFFAED0F3),
          centerTitle: true,
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
        ),
      ),
    );
  }
}
