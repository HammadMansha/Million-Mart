import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';


class FullViewImageController extends GetxController{

  String url = "";
  bool isLoading = true;

  late NetworkController networkController;


  @override
  void onInit() {
    if (Get.isRegistered<NetworkController>()) {
      networkController = Get.find<NetworkController>();
    } else {
      networkController = Get.put(NetworkController());
    }
    if(Get.arguments != null)
      {
        url = Get.arguments;
        isLoading = false;
        update();
      }
    super.onInit();
  }

  @override
  void onReady()async {
    super.onReady();
  }

}