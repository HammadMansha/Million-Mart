import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/ReportthisItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReportScreen extends StatefulWidget {
  var productID;
  var productTitle;
  ReportScreen({this.productID,this.productTitle});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var textStyle = TextStyle(fontSize: 15, color: Colors.blue[900]);
  var boxDecoration = BoxDecoration(
    color: Colors.orange,
    borderRadius: BorderRadius.circular(30),
  );
  Completer<WebViewController> _controller = Completer<WebViewController>();

  TextEditingController _desController = TextEditingController();
  var id;
  void getID()async{
    final SharedPreferences _prefs = await Constants.prefs;
    id = _prefs.getString('id') ?? "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'File a report',
          style: TextStyle(
            color: primaryColor,
          ),
          textAlign: TextAlign.left,
        ),
        brightness: Brightness.light,
        elevation: 5,
        backgroundColor: Color(0xFFAED0F3),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      ),
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            } // currentFocus.dispose();
          },
          child:Container(
          padding: EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Report Product', style: textStyle),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _desController,
                    decoration: InputDecoration(
                    // labelText: "Write Detail Reason",
                    hintText: "Write Detail Reason"

                  ),
                  maxLines: 10,),
                  SizedBox(
                    height: 30,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Before reporting an item, please review the ',
                          style: textStyle,
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('here');
                              WebView(
                                initialUrl: 'google.com',
                                onWebViewCreated:
                                    (WebViewController webViewController) {
                                  _controller.complete(webViewController);
                                },
                                javascriptMode: JavascriptMode.unrestricted,
                              );
                            },
                          text: 'Million Mart ',
                          style: TextStyle(fontSize: 15, color: Colors.orange),
                        ),
                        TextSpan(
                          text: 'listing policies.',
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      if(_desController.text.isNotEmpty){
                        reportItemController(widget.productTitle,widget.productID.toString(),id,_desController.text);
                      }
                      else{
                        Fluttertoast.showToast(msg: 'Reason is Empty');
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: boxDecoration,
                      child: Center(
                        child: Text(
                          'Submit Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
