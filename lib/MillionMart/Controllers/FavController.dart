// import 'package:get/get.dart';
// import 'package:millionmart_cleaned/MillionMart/models/favDb.dart';

// class FavController extends GetxController{
//   FavController(this.pName);
//   String pName;
//   DbFavManager dBcartManager = new DbFavManager();
//   var isFavExist =true.obs;
//   // var sumTotal=0.obs;

//   findFavExist()async{
//     isFavExist.value= await dBcartManager.findFav(pName);
//     print('response from db Classs...... ${isFavExist.value}');
//     // print('cart count in controller..'+cartCoount.length.toString());

//   }

//   @override
//   void onInit() {
//     findFavExist();
//     // getCartCount();
//     // getTotal();
//     // TODO: implement onInit
//     super.onInit();


//   }



// }