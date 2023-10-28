import 'package:flutter/material.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  _AccountInformationState createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var numberController = TextEditingController();
  var passwordController = TextEditingController();
  var accountTypeController = TextEditingController();
  List<bool> readonly = [true, true, true, true, true];
  @override
  void initState() {
    super.initState();
    userData();
  }

  String? userEmail, userPhone, userName, userId;

  userData() async {
    final SharedPreferences _prefs = await Constants.prefs;
    userEmail = _prefs.getString('email');
    print('Profile page: $userEmail');
    userPhone = _prefs.getString('phone');
    userName = _prefs.getString('name');
    userId = _prefs.getString('id');
    Constants.userNameData = userName;
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'account_info'.tr,
          style: TextStyle(color: Color(0xFF0A3966)),
        ),
        backgroundColor: Color(0xFFAED0F3),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.0,
            ),
            accountTile(
              "id".tr,
              userId ?? "ID",
            ),
            SizedBox(
              height: 15.0,
            ),
            accountTile(
              "user_name",
              userName ?? "Username",
            ),
            SizedBox(
              height: 15.0,
            ),
            accountTile(
              "email",
              userEmail ?? "Email",
            ),
            SizedBox(
              height: 15.0,
            ),
            accountTile("phone_number", userPhone ?? "Phone Number"),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget accountTile(String? mainText, String? subText) {
    return Container(
      height: 60.0,
      width: Get.width,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                mainText!.tr,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                subText!,
                style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold),
              ),
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
