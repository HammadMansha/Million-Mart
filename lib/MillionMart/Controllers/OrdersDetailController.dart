import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/models/ordersData.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loadOrders = true.obs;

Future<List<OrdersData>> orderDetailController() async {
  var url = Constants.baseUrl;

  final SharedPreferences _prefs = await Constants.prefs;

  var uid = _prefs.getString("id");
  print("User Id is : "+uid.toString());
  final response = await http.post(Uri.parse(url + '/orderhistory'),
      body:{
    "user_id":uid.toString()
      });
  if (response.statusCode == 200) {
    {
      loadOrders.value = false;
      var data = response.body;
      print("Res ${response.body}");
      return ordersDataFromJson(data);
    }
  } else {
    loadOrders.value = false;
    print(response.body);
    throw Exception('Failed to save Data.');
  }
}
