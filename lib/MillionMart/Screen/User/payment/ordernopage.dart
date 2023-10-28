import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/payment/ordernopage_controller.dart';

class OrderNoPage extends StatelessWidget {
  const OrderNoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment'.tr,
          style: TextStyle(color: Color(0xFF0A3966)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFAED0F3),
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      ),
      body: GetBuilder<OrderNoController>(
        init: OrderNoController(),
        builder: (_) {
          return _.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              :
          // InAppWebView(
          //         initialUrlRequest: URLRequest(
          //             url: Uri.parse("https://sandbox.bankalfalah.com/HS/HS/HS"),
          //             method: 'POST',
          //             body: Uint8List.fromList(utf8.encode(
          //                 "HS_RequestHash=HS_${_.hashkey.toString()}&HS_IsRedirectionRequest=1&HS_ChannelId=1001&HS_ReturnURL=http://192.168.100.187/million_final_code/checkout/payment/return&HS_MerchantId=9728&HS_StoreId=017342&HS_MerchantHash=zWsOsg0VNuBwmQH5oZC9rh3mM5b4chnMUbQ8aTqX5wOjyyOeZnrlG6G6gD3nSe5oa4M2JmBb/P3IXb4twlGH8sfsO5VG7je0&HS_MerchantUsername=movehe&HS_MerchantPassword=HdiKE8FZlkZvFzk4yqF7CA==&HS_TransactionReferenceNumber=${int.parse(_.no.text)}")),
          //             headers: {
          //               'Content-Type': 'application/x-www-form-urlencoded'
          //             }),
          //       );
          // InAppWebView(
          //   initialUrlRequest: URLRequest(
          //       url: Uri.parse("https://sandbox.bankalfalah.com/HS/HS/HS"),
          //       // url: Uri.parse("https://sandbox.bankalfalah.com/SSO/SSO/SSO"),
          //       method: 'POST',
          //       // body: Uint8List.fromList(utf8.encode("HS_TransactionReferenceNumber=2956")),
          //       // body: Uint8List.fromList(utf8.encode("TransactionTypeId=2&TransactionReferenceNumber=789&TransactionAmount=785")),
          //       body: Uint8List.fromList(utf8.encode("HS_RequestHash=HS_${_.hashkey.toString()}&HS_IsRedirectionRequest=1&HS_ChannelId=1001&HS_ReturnURL=http://192.168.100.187/million_final_code/checkout/payment/return&HS_MerchantId=9728&HS_StoreId=017342&HS_MerchantHash=zWsOsg0VNuBwmQH5oZC9rh3mM5b4chnMUbQ8aTqX5wOjyyOeZnrlG6G6gD3nSe5oa4M2JmBb/P3IXb4twlGH8sfsO5VG7je0&HS_MerchantUsername=movehe&HS_MerchantPassword=HdiKE8FZlkZvFzk4yqF7CA==&HS_TransactionReferenceNumber=${int.parse(_.no.text)}")),
          //       headers: {
          //         'Content-Type': 'application/x-www-form-urlencoded'
          //       }
          //   ),
          // );

          Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _.no,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_circle_outlined,
                    ),
                    // errorText: '',
                    hintText: 'Order No'.tr,
                    prefixIconConstraints:
                    BoxConstraints(minWidth: 40, maxHeight: 20),
                    isDense: true,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0))),
              ),
              SizedBox(height: 20.0,),
              TextButton(
                //yes button
                child: Text(
                  'Yes',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: primaryColor,
                ),
                onPressed: () {
                  _.checkData();
                },
              ),
            ],
          );
          return WebviewScaffold(
            withJavascript: true,
            appCacheEnabled: true,
            url: new Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
          );
        },
      ),
    );
  }

  String _loadHTML() {
    return r'''
      <html>
      <script                                                                                                                                                                                           
       src="https://code.jquery.com/jquery-1.12.4.min.js"                                                                                                                                              
       integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ="                                                                                                                                 
       crossorigin="anonymous"></script><script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
        <body onload="document.f.submit();">
        <input id="Key1" name="Key1" type="hidden" value="5MnjerfTzSJw6nD9">                                                                                                                              
     <input id="Key2" name="Key2" type="hidden" value="3144955280540143"> 
          <form action="https://sandbox.bankalfalah.com/HS/HS/HS" id="HandshakeForm" method="post">                                                                                                      
         <input id="HS_RequestHash" name="HS_RequestHash" type="hidden" value="">                                                                                                                      
         <input id="HS_IsRedirectionRequest" name="HS_IsRedirectionRequest" type="hidden" value="1">                                                                                                   
         <input id="HS_ChannelId" name="HS_ChannelId" type="hidden" value="1001">                                                                                                                      
         <input id="HS_ReturnURL" name="HS_ReturnURL" type="hidden" value="http://192.168.100.187/million_final_code/checkout/payment/return">                                                                     
         <input id="HS_MerchantId" name="HS_MerchantId" type="hidden" value="9728">                                                                                                                     
         <input id="HS_StoreId" name="HS_StoreId" type="hidden" value="017342">                                                                                                                     
         <input id="HS_MerchantHash" name="HS_MerchantHash" type="hidden" value="zWsOsg0VNuBwmQH5oZC9rh3mM5b4chnMUbQ8aTqX5wOjyyOeZnrlG6G6gD3nSe5oa4M2JmBb/P3IXb4twlGH8vsdZ6UKBpwo">                            
         <input id="HS_MerchantUsername" name="HS_MerchantUsername" type="hidden" value="azacub">                                                                                                      
         <input id="HS_MerchantPassword" name="HS_MerchantPassword" type="hidden" value="CC9vci4s3lxvFzk4yqF7CA==">                                                                                    
         <input id="HS_TransactionReferenceNumber" name="HS_TransactionReferenceNumber" autocomplete="off" placeholder="Order ID"  value="">                                                                                     
         <button type="submit" class="btn btn-custon-four btn-danger" id="handshake">Handshake</button>                                                                                                
     </form>
        </body>
      </html>
    ''';
  }
}
