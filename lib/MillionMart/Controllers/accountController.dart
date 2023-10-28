import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  bool isLoading = true;
  List tabslist = [];

  String name = "";
  String email = "";

  @override
  void onInit() {
    tabslist = [
      {"name": "orders"},
      {"name": "comparison_items"},
      {"name": "bargain"},
      {"name": "return"},
      {"name": "account_info"},
      {"name": "settings"},
      {"name": "faq"},
      {"name": "help"},
    ];
    super.onInit();
  }

  @override
  void onReady() async {
    final SharedPreferences getUid = await Constants.prefs;
    name = getUid.getString('name')!;
    email = getUid.getString('email')!;
    isLoading = false;
    update();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
