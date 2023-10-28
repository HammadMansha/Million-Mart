import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/PaginationProductsController.dart';


class ALlProductController extends GetxController{

  late PaginationDataController paginationDataController;

  @override
  void onInit() {
    if(Get.isRegistered<PaginationDataController>())
    {
      paginationDataController = Get.find<PaginationDataController>();
    }
    else
    {
      paginationDataController = Get.put(PaginationDataController());
    }
    super.onInit();
  }

  @override
  void onReady()async {

    super.onReady();
  }


}