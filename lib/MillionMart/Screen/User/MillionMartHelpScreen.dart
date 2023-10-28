import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/ProductDetail/Components/callToOrder.dart';

class Help extends StatelessWidget {
  // const contact_us({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'help'.tr,
          style: TextStyle(color: Color(0xFF0A3966)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFAED0F3),
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: customCard('call', 'assets/icon/call.png'),
            onTap: () {
              callToOrder();
            },
          ),
          GestureDetector(
            onTap: () {
              emailContactus();
            },
            child: customCard('email', 'assets/icon/email.png'),
          ),
          ElevatedButton(
            onPressed: () {
              callToOrder();
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF0A3966),
              textStyle: TextStyle(
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: Color(0xFF0A3966),
                ),
              ),
            ),
            child: Text(
              'contact_us'.tr,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget customCard(String nametext, String iconString) {
    return Container(
      height: 60.0,
      width: Get.width,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                nametext.tr,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Image.asset(
                iconString,
                height: 20,
                width: 20,
              )
            ],
          ).marginOnly(left: 20.0, right: 20.0),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            color: Colors.grey,
            height: 1,
          )
        ],
      ),
    );
  }
}
