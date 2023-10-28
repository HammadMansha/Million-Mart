import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutController extends GetxController {
  String? userEmail, userPhone, userName, userId;
  final DatabaseHelper _dBcartManager = new DatabaseHelper();

  String uid = "";
  var res;
  var p;
  var firstOrderPromoCode = '';
  var promoCodeDiscount = ''.obs;
  var discountType = ''.obs;

  @override
  void onInit() async {
    await userData();
    super.onInit();
  }

  @override
  void onReady() async {
    final SharedPreferences getUid = await Constants.prefs;
    if (getUid.getString('id') != null) {
      uid = getUid.getString('id')!;
      print("User id $uid");
      update();
      // username = getUid.getString('name')!;
    }
    await userData();
    print("User Data is get");
  }

  Future<void> userData() async {
    final SharedPreferences _prefs = await Constants.prefs;
    userEmail = _prefs.getString('email');
    print('Profile page: $userEmail');
    userPhone = _prefs.getString('phone');
    userName = _prefs.getString('name');
    Constants.userID = _prefs.getString('id');
    userId = _prefs.getString('id');
    print("Get user id is $userId");
    Constants.userNameData = userName;
    loginCheck.value = _prefs.getBool('loggedIn')!;
    print("Logged In " + loginCheck.value.toString());
  }

  var sumPrice = 0.obs;
  List<Cart> sumPriceData = <Cart>[].obs;

  Future<void> fetchData() async {
    sumPriceData = await _dBcartManager.getCartData();
    sumPrice.value = 0;
    for (int c = 0; c < sumPriceData.length; c++) {
      print(sumPrice.value);
      print(sumPriceData.length);
      print("price" + sumPriceData[c].price!);
      // print("Products Prices ${sumPrice + int.parse(sumPriceData[c].price)* sumPriceData[c].qty}");
      sumPrice.value = sumPrice.value +
          (int.parse(sumPriceData[c].price!) * sumPriceData[c].qty);
      // sumPrice =++ total;
      print('sumPrice $c ' + sumPrice.value.toString());
    }
  }

  Future<void> promoCodeController(String code) async {
    print("PromoCode is " + code);
    var url = Constants.baseUrl;
    final response1 = await http.get(Uri.parse(url + '/gefirstordercoupon'));
    if (response1.statusCode == 200) {
      var data = jsonDecode(response1.body);
      firstOrderPromoCode = data["code"];
    } else {
      print("First order apiis not hit");
    }
    if (firstOrderPromoCode == code) {
      print('Code is $code');
      print('User Id is $uid');
      final res = await http.post(Uri.parse(url + '/coupon'),
          body: {"coupon": code, "userid": uid});
      print("response of coupan api" + res.body);
      var data = jsonDecode(res.body);
      if (res.body.toString().contains("already")) {
        Get.snackbar("Warning", "coupon already used");
      } else {
        promoCodeDiscount.value = data["price"].toString();
        discountType.value = data["type"].toString();
        update();
      }
    } else {
      // var body =
      final response = await http.post(Uri.parse(url + '/coupon'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "coupon": code,
          }));
      // print(response.body);
      var data = jsonDecode(response.body);
      promoCodeDiscount.value = data["price"].toString();
      discountType.value = data["type"].toString();
      if (response.statusCode == 200) {
        res = response.body;
      } else {
        print(response.body);
        Get.snackbar('Warning', "Wrong Code");
        throw Exception('Wrong Code.');
      }
    }
  }
}
