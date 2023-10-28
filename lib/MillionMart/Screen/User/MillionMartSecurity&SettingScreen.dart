import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartHome.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartSplash.dart';
import 'package:millionmart_cleaned/MillionMart/app_translations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSetting extends StatefulWidget {
  // const ({Key? key}) : super(key: key);
  @override
  _AppSettingState createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  String _selectedLang = LocalizationService.langs.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'settings'.tr,
          style: TextStyle(color: Color(0xFF0A3966)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFAED0F3),
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          // customCard('notifications', 'assets/icon/notifications.png'),
          // customCard('password', 'assets/icon/password.png'),
          // customCard('chat', 'assets/icon/chat.png'),
          // customCard('login_activity', 'assets/icon/login_activity.png'),
          // customCard('logout', 'assets/icon/logout.png'),
          Container(
            height: 30.0,
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'language'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton(
                  icon: Icon(Icons.arrow_drop_down),
                  value: _selectedLang,
                  items: LocalizationService.langs.map((String lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (String? value) async{
                    // updates dropdown selected value
                    print('Updated Lang is $value');
                    setState(() => _selectedLang = value!);
                    // // gets language and changes the locale
                    LocalizationService().changeLocale(value!);
                    Constants.checkLanguage=value;
                    // Get.delete<HomeController>();
                    // Get.put(HomeController());
                    HomeController homeController = Get.find<HomeController>();
                    homeController.isLoading.value = true;
                    homeController.getCartCount();
                    homeController.carouselController();
                    homeController.fetchProducts();
                    homeController.checkLogin();
                    homeController.isLoading.value = false;
                    Get.offAll(MillionMartHome());
                  },
                ),
              ],
            ).marginOnly(left: 20.0, right: 20.0),
          ),
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
