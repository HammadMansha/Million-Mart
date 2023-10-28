import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/contactusController.dart';
import 'package:url_launcher/url_launcher.dart';


Contactus contactus = Get.find<Contactus>();

callToOrder() async {
  final number = '+${contactus.no}';
  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  print(res);
}

emailContactus() async
{
  final email = '${contactus.email}';
  launch("mailto:$email");
}