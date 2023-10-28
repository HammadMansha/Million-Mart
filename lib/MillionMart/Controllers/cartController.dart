import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/database/database.dart';
// import 'package:millionmart/FullApp/MillionMart%20App/AddToCart/Database.dart';

class CartController extends GetxController {
  final DatabaseHelper dBcartManager = new DatabaseHelper();
  var cartCoount = <Cart>[].obs;
  var compCount = 0.obs;
  var sumTotal = 0.obs;
  var totalBill = 0.0.obs;

  var sum;

  @override
  void onInit() {
    // getCartCount();
    getTotal();
    super.onInit();
  }

  getCompCount() async {
    compCount.value = await dBcartManager.getCompCount();
    print("Cart Items in DB (Count) :  " + cartCoount.length.toString());
  }

  getCartCount() async {
    cartCoount.value = await dBcartManager.getCartData();
    print("Cart Items in DB (Count) :  " + cartCoount.length.toString());
  }

  double getTotal() {
    var sumTotal = 0.0;
    for (int c = 0; c < cartCoount.length; c++) {
      sumTotal = sumTotal +
          ((double.parse(cartCoount[c].price!)) *
              double.parse(cartCoount[c].qty.toString()));
      print("sumtotal :" + sumTotal.runtimeType.toString());
      print("total price " + cartCoount[c].sub_total.toString());
    }
    return sumTotal;
    // print('sum all prices' + sumTotal.toString());
  }
}
