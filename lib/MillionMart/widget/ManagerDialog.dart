import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/contactusController.dart';
import 'package:url_launcher/url_launcher.dart';

class ManaGerDialog extends StatefulWidget {
  ManaGerDialog({this.isshowChat = true});

  final bool isshowChat;

  @override
  _ManaGerDialogState createState() => _ManaGerDialogState();
}

class _ManaGerDialogState extends State<ManaGerDialog> {
  final HomeController homeController = Get.find<HomeController>();

  _getDivider() {
    return Divider(
      color: Colors.grey,
      height: 1,
    );
  }

  _sizeBox() {
    return SizedBox(
      height: 8.0,
    );
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                callNumber();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("call".tr,
                      style: Theme.of(context).textTheme.subtitle1!),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0,right: 4.0),
                    child: Image.asset(
                      "assets/callCus.png",
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),
            // _sizeBox(),
            // widget.isshowChat ?
            _getDivider(),
            _sizeBox(),
            widget.isshowChat
                ? InkWell(
                    onTap: () async {
                      homeController.ischeck == false
                          ? Get.snackbar('error'.tr, 'loginFirst'.tr,
                              backgroundColor: notificationBackground,
                        colorText: notificationTextColor,)
                          : await homeController.addUser();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("chat".tr,
                            style: Theme.of(context).textTheme.subtitle1!),
                        Icon(
                          Icons.chat,
                          color: primaryColor,
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            // _sizeBox(),
            // widget.isshowChat ?
            _getDivider(),
            _sizeBox(),
            InkWell(
              onTap: () {
                _whatsAppNumber();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("whatsapp".tr,
                      style: Theme.of(context).textTheme.subtitle1!),
                  Image.asset(
                    "assets/icon/whatsapp-new.png",
                    height: 34,
                    width: 34,
                  ),
                ],
              ),
            ),
            // _sizeBox(),
            // widget.isshowChat
            _getDivider(),
            _sizeBox(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: primaryColor, shape: StadiumBorder()),
                child: Text(
                  "close".tr,
                  style: TextStyle(
                    // color: Color(0xffF68628),
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            // InkWell(
            //     child: Text(
            //       "close".tr,
            //       style: TextStyle(
            //         color: Color(0xffF58323),
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //     onTap: () {
            //       Navigator.pop(context);
            //     })
          ],
        ),
      ),
    );
  }
}

Contactus contactus = Get.find<Contactus>();

callNumber() async {
  var number = "+${contactus.no}";
  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  print(res);
}

_whatsAppNumber() async {
  var whatsapp = "+${contactus.no}";
  var whatappURLios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  if (Platform.isIOS) {
    if (await canLaunch(whatappURLios)) {
      await launch(whatappURLios, forceSafariVC: false);
    } else {
      print("No Whatsapp installed.");
    }
  } else {
    await launch("https://wa.me/+$whatsapp/?text=${Uri.parse("")}");
  }
}
