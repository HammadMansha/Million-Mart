import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/models/GetBargainModelClass.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ConfigFileController extends GetxController
{
  // bool isLoading = true;
  List<GetBargain> bargainItemsData = [];

  List datalist = [];

  List tabslist = [];

  String? userId;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady()async {
    await getConfigController();
    // isLoading = false;
    update();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  Future<void> getConfigController() async {
    final SharedPreferences _prefs = await Constants.prefs;
    userId = _prefs.getString('id');
    print(userId);
    var url = Constants.baseUrl;
    print(url.runtimeType);
    print(userId);
    final response = await http.get(Uri.parse(url + '/bargain/$userId'));
    if (response.statusCode == 200) {
      print(response.statusCode);
      if(response.body.contains("User Not Found")){
        var data = jsonDecode(response.body);
        log("Check Data ${data.toString()}");
        // datalist.addAll(data);
        update();
      }
      else{
        var data = jsonDecode(response.body);
        log("Check Data ${data.toString()}");
        datalist.addAll(data);
        update();
        await getData();
      }
    } else {
      throw Exception('Error to Load Data');
    }
  }

  Future<List<GetBargain>> getData() async
  {
    datalist.forEach((element) {
      bargainItemsData.add(GetBargain.fromJson(element));
    });
    update();
    return bargainItemsData;
  }


}
